has_public_storage () {
	expect_vars HALCYON_BASE HALCYON_NO_PUBLIC_STORAGE

	# NOTE: All archives in public storage assume HALCYON_BASE is /app.
	[[ "${HALCYON_BASE}" == '/app' ]] || return 1

	! (( HALCYON_NO_PUBLIC_STORAGE )) || return 1
	[[ -n "${HALCYON_PUBLIC_STORAGE_URL}" ]] || return 1
}


has_private_storage () {
	expect_vars HALCYON_NO_PRIVATE_STORAGE

	! (( HALCYON_NO_PRIVATE_STORAGE )) || return 1
	[[ -n "${HALCYON_AWS_ACCESS_KEY_ID:+_}" ]] || return 1
	[[ -n "${HALCYON_AWS_SECRET_ACCESS_KEY:+_}" ]] || return 1
	[[ -n "${HALCYON_S3_BUCKET:+_}" ]] || return 1
	[[ -n "${HALCYON_S3_ENDPOINT:+_}" ]] || return 1
	[[ -n "${HALCYON_S3_ACL:+_}" ]] || return 1
}


has_not_public_private_storage () {
	has_private_storage || return 1

	if has_public_storage &&
		[[ "${HALCYON_S3_BUCKET}" == "${HALCYON_DEFAULT_PUBLIC_STORAGE_S3_BUCKET}" ]]
	then
		return 1
	fi
}


format_public_storage_url () {
	expect_vars HALCYON_PUBLIC_STORAGE_URL

	local object
	expect_args object -- "$@"

	echo "${HALCYON_PUBLIC_STORAGE_URL}/${object}"
}


describe_storage () {
	if has_private_storage && has_public_storage; then
		log_indent_label 'External storage:' 'private and public'
	elif has_private_storage; then
		log_indent_label 'External storage:' 'private'
	elif has_public_storage; then
		log_indent_label 'External storage:' 'public'
	else
		log_indent_label 'External storage:' 'none'
	fi
}


create_cached_archive () {
	expect_vars HALCYON_CACHE

	local src_dir dst_file_name
	expect_args src_dir dst_file_name -- "$@"

	expect_existing "${src_dir}" || return 1

	if ! create_archive "${src_dir}" "${HALCYON_CACHE}/${dst_file_name}"; then
		log_error 'Failed to create cached archive'
		return 1
	fi
}


extract_cached_archive_over () {
	expect_vars HALCYON_CACHE

	local src_file_name dst_dir
	expect_args src_file_name dst_dir -- "$@"

	if [[ ! -f "${HALCYON_CACHE}/${src_file_name}" ]]; then
		return 1
	fi

	if ! extract_archive_over "${HALCYON_CACHE}/${src_file_name}" "${dst_dir}"; then
		rm -rf "${dst_dir}" || true

		log_error 'Failed to extract cached archive'
		return 1
	fi
}


touch_cached_file () {
	expect_vars HALCYON_CACHE

	local file_name
	expect_args file_name -- "$@"

	if [[ ! -f "${HALCYON_CACHE}/${file_name}" ]]; then
		return 0
	fi

	touch "${HALCYON_CACHE}/${file_name}" || return 0
}


touch_cached_ghc_and_cabal_files () {
	expect_vars HALCYON_CACHE

	local name
	find_tree "${HALCYON_CACHE}" -maxdepth 1 -type f |
		filter_matching "^(halcyon-ghc-.*|halcyon-cabal-.*)$" |
		while read -r name; do
			touch "${HALCYON_CACHE}/${name}" || true
		done || return 0
}


check_s3_status () {
	local s3_status
	expect_args s3_status -- "$@"

	# NOTE: Requests using the wrong S3 endpoint fail with 301.
	# https://github.com/mietek/haskell-on-heroku/issues/37
	if (( s3_status == 3 )); then
		log_error "Unexpected HALCYON_S3_ENDPOINT for HALCYON_S3_BUCKET (${HALCYON_S3_BUCKET}): ${HALCYON_S3_ENDPOINT}"
		return 1
	fi
}


upload_cached_file () {
	expect_vars HALCYON_CACHE HALCYON_NO_UPLOAD

	local prefix file_name
	expect_args prefix file_name -- "$@"

	if (( HALCYON_NO_UPLOAD )) || ! has_private_storage; then
		return 0
	fi

	local object file
	object="${prefix:+${prefix}/}${file_name}"
	file="${HALCYON_CACHE}/${file_name}"

	local status
	status=0
	s3_upload "${file}" "${HALCYON_S3_BUCKET}" "${object}" "${HALCYON_S3_ACL}" || status="$?"
	if (( status )); then
		log_error 'Failed to upload cached file'
		check_s3_status "${status}" || return 1
		return 1
	fi
}


cache_stored_file () {
	expect_vars HALCYON_CACHE

	local prefix file_name
	expect_args prefix file_name -- "$@"

	local object file
	object="${prefix:+${prefix}/}${file_name}"
	file="${HALCYON_CACHE}/${file_name}"

	if has_not_public_private_storage; then
		local status
		status=0
		s3_download "${HALCYON_S3_BUCKET}" "${object}" "${file}" || status="$?"
		if ! (( status )); then
			return 0
		fi
		check_s3_status "${status}" || return 1
	fi

	if ! has_public_storage; then
		return 1
	fi

	local public_url
	public_url=$( format_public_storage_url "${object}" )

	curl_download "${public_url}" "${file}" || return 1
	upload_cached_file "${prefix}" "${file_name}" || return 1
}


cache_original_stored_file () {
	expect_vars HALCYON_CACHE

	local original_url
	expect_args original_url -- "$@"

	local file_name file
	file_name=$( basename "${original_url}" ) || return 1
	file="${HALCYON_CACHE}/${file_name}"

	if cache_stored_file 'original' "${file_name}"; then
		return 0
	fi

	curl_download "${original_url}" "${file}" || return 1
	upload_cached_file 'original' "${file_name}" || return 1
}


acquire_original_source () {
	local original_url dst_dir
	expect_args original_url dst_dir -- "$@"

	local original_name
	original_name=$( basename "${original_url}" ) || return 1

	if ! extract_cached_archive_over "${original_name}" "${dst_dir}"; then
		cache_original_stored_file "${original_url}" || return 1

		if ! extract_cached_archive_over "${original_name}" "${dst_dir}"; then
			log_error 'Failed to acquire original source'
			return 1
		fi
	else
		touch_cached_file "${original_name}"
	fi
}


delete_private_stored_file () {
	expect_vars HALCYON_NO_UPLOAD HALCYON_NO_CLEAN_PRIVATE_STORAGE

	local prefix file_name
	expect_args prefix file_name -- "$@"

	if (( HALCYON_NO_UPLOAD )) ||
		(( HALCYON_NO_CLEAN_PRIVATE_STORAGE )) ||
		! has_private_storage
	then
		return 0
	fi

	local object status
	object="${prefix:+${prefix}/}${file_name}"
	status=0
	s3_delete "${HALCYON_S3_BUCKET}" "${object}" || status="$?"
	if (( status )); then
		log_error 'Failed to delete private stored file'
		check_s3_status "${status}" || return 1
		return 1
	fi
}


list_private_stored_files () {
	local prefix
	expect_args prefix -- "$@"

	if ! has_private_storage; then
		return 0
	fi

	local status
	status=0
	s3_list "${HALCYON_S3_BUCKET}" "${prefix}" || status="$?"
	if (( status )); then
		log_error 'Failed to list private stored files'
		check_s3_status "${status}" || return 1
		return 1
	fi
}


list_public_stored_files () {
	local prefix
	expect_args prefix -- "$@"

	if ! has_public_storage; then
		return 0
	fi

	local public_url
	public_url=$( format_public_storage_url "${prefix:+?prefix=${prefix}}" )

	if ! curl_list_s3 "${public_url}"; then
		log_error 'Failed to list public stored files'
		return 1
	fi
}


list_stored_files () {
	local prefix
	expect_args prefix -- "$@"

	local private_files
	if ! private_files=$( list_private_stored_files "${prefix}" ); then
		return 1
	fi

	echo "${private_files}"

	local public_files
	if ! public_files=$( list_public_stored_files "${prefix}" ); then
		return 1
	fi

	echo "${public_files}"
}


delete_matching_private_stored_files () {
	expect_vars HALCYON_NO_UPLOAD HALCYON_NO_CLEAN_PRIVATE_STORAGE

	local prefix match_prefix match_pattern save_name
	expect_args prefix match_prefix match_pattern save_name -- "$@"

	if (( HALCYON_NO_UPLOAD )) ||
		(( HALCYON_NO_CLEAN_PRIVATE_STORAGE )) ||
		! has_private_storage
	then
		return 0
	fi

	local old_name
	list_private_stored_files "${prefix}/${match_prefix}" |
		sed "s:^${prefix}/::" |
		filter_matching "^${match_pattern}$" |
		filter_not_matching "^${save_name//./\.}$" |
		while read -r old_name; do
			delete_private_stored_file "${prefix}" "${old_name}" || return 1
		done || return 0
}


prepare_cache () {
	expect_vars HALCYON_CACHE HALCYON_PURGE_CACHE HALCYON_NO_CLEAN_CACHE \
		HALCYON_INTERNAL_RECURSIVE

	local cache_dir
	expect_args cache_dir -- "$@"

	if (( HALCYON_NO_CLEAN_CACHE )) || (( HALCYON_INTERNAL_RECURSIVE )); then
		return 0
	fi

	if (( HALCYON_PURGE_CACHE )); then
		log 'Purging cache'
		log

		rm -rf "${HALCYON_CACHE}" || return 1
	fi

	mkdir -p "${HALCYON_CACHE}" "${cache_dir}" || return 1

	if ! (( HALCYON_PURGE_CACHE )); then
		local files
		if files=$(
			find_tree "${HALCYON_CACHE}" -maxdepth 1 -type f |
			sort_natural |
			match_at_least_one
		); then
			log 'Examining cache contents'

			copy_dir_over "${HALCYON_CACHE}" "${cache_dir}" || return 1

			quote <<<"${files}"
			log
		fi
	fi

	touch "${cache_dir}" || return 1
}


clean_cache () {
	expect_vars HALCYON_CACHE HALCYON_NO_CLEAN_CACHE \
		HALCYON_INTERNAL_RECURSIVE

	local cache_dir
	expect_args cache_dir -- "$@"

	if (( HALCYON_NO_CLEAN_CACHE )) || (( HALCYON_INTERNAL_RECURSIVE )); then
		return 0
	fi

	local mark_time
	mark_time=$( get_modification_time "${cache_dir}" ) || return 1

	rm -f "${HALCYON_CACHE}/"*'.constraints' || true

	local file
	find "${HALCYON_CACHE}" -maxdepth 1 -type f 2>'/dev/null' |
		while read -r file; do
			local file_time
			if file_time=$( get_modification_time "${file}" ) &&
				(( file_time < mark_time ))
			then
				rm -f "${file}" || true
			fi
		done

	local -a opts_a
	opts_a=()
	opts_a+=( \( -name 'apt' )
	opts_a+=( \) -prune -o )

	local changed_files
	if changed_files=$(
		compare_tree "${cache_dir}" "${HALCYON_CACHE}" "${opts_a[@]}" |
		filter_not_matching '^= ' |
		match_at_least_one
	); then
		log
		log 'Examining cache changes'

		quote <<<"${changed_files}"
	fi
}
