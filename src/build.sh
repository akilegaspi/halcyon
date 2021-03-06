create_build_tag () {
	local prefix label source_hash constraints_hash magic_hash \
		ghc_version ghc_magic_hash \
		cabal_version cabal_magic_hash \
		sandbox_magic_hash
	expect_args prefix label source_hash constraints_hash magic_hash \
		ghc_version ghc_magic_hash \
		cabal_version cabal_magic_hash \
		sandbox_magic_hash -- "$@"

	create_tag "${prefix}" "${label}" "${source_hash}" "${constraints_hash}" "${magic_hash}" \
		"${ghc_version}" "${ghc_magic_hash}" \
		"${cabal_version}" "${cabal_magic_hash}" '' ''  \
		"${sandbox_magic_hash}"
}


detect_build_tag () {
	local tag_file
	expect_args tag_file -- "$@"

	local tag_pattern
	tag_pattern=$(
		create_build_tag '.*' '.*' '.*' '.*' '.*' \
			'.*' '.*' \
			'.*' '.*' \
			'.*'
	)

	local tag
	if ! tag=$( detect_tag "${tag_file}" "${tag_pattern}" ); then
		log_error 'Failed to detect build tag'
		return 1
	fi

	echo "${tag}"
}


derive_build_tag () {
	local tag
	expect_args tag -- "$@"

	local prefix label source_hash constraints_hash magic_hash \
		ghc_version ghc_magic_hash \
		cabal_version cabal_magic_hash \
		sandbox_magic_hash
	prefix=$( get_tag_prefix "${tag}" )
	label=$( get_tag_label "${tag}" )
	source_hash=$( get_tag_source_hash "${tag}" )
	constraints_hash=$( get_tag_constraints_hash "${tag}" )
	magic_hash=$( get_tag_magic_hash "${tag}" )
	ghc_version=$( get_tag_ghc_version "${tag}" )
	ghc_magic_hash=$( get_tag_ghc_magic_hash "${tag}" )
	cabal_version=$( get_tag_cabal_version "${tag}" )
	cabal_magic_hash=$( get_tag_cabal_magic_hash "${tag}" )
	sandbox_magic_hash=$( get_tag_sandbox_magic_hash "${tag}" )

	create_build_tag "${prefix}" "${label}" "${source_hash}" "${constraints_hash}" "${magic_hash}" \
		"${ghc_version}" "${ghc_magic_hash}" \
		"${cabal_version}" "${cabal_magic_hash}" \
		"${sandbox_magic_hash}"
}


derive_configured_build_tag_pattern () {
	local tag
	expect_args tag -- "$@"

	local prefix label constraints_hash magic_hash \
		ghc_version ghc_magic_hash \
		cabal_version cabal_magic_hash \
		sandbox_magic_hash
	prefix=$( get_tag_prefix "${tag}" )
	label=$( get_tag_label "${tag}" )
	constraints_hash=$( get_tag_constraints_hash "${tag}" )
	magic_hash=$( get_tag_magic_hash "${tag}" )
	ghc_version=$( get_tag_ghc_version "${tag}" )
	ghc_magic_hash=$( get_tag_ghc_magic_hash "${tag}" )
	cabal_version=$( get_tag_cabal_version "${tag}" )
	cabal_magic_hash=$( get_tag_cabal_magic_hash "${tag}" )
	sandbox_magic_hash=$( get_tag_sandbox_magic_hash "${tag}" )

	create_build_tag "${prefix}" "${label//./\.}" '.*' "${constraints_hash}" '.*' \
		"${ghc_version//./\.}" "${ghc_magic_hash}" \
		"${cabal_version//./\.}" "${cabal_magic_hash}" \
		"${sandbox_magic_hash}"
}


derive_potential_build_tag_pattern () {
	local tag
	expect_args tag -- "$@"

	local label \
		ghc_version ghc_magic_hash \
		cabal_version cabal_magic_hash
	label=$( get_tag_label "${tag}" )
	ghc_version=$( get_tag_ghc_version "${tag}" )
	ghc_magic_hash=$( get_tag_ghc_magic_hash "${tag}" )
	cabal_version=$( get_tag_cabal_version "${tag}" )
	cabal_magic_hash=$( get_tag_cabal_magic_hash "${tag}" )

	# NOTE: Build directories created with cabal-install 1.20.0.3 are
	# not usable with cabal-install 1.22.0.0.
	# https://github.com/haskell/cabal/issues/2320
	create_build_tag '.*' "${label//./\.}" '.*' '.*' '.*' \
		"${ghc_version//./\.}" "${ghc_magic_hash}" \
		"${cabal_version//./\.}" "${cabal_magic_hash}" \
		'.*'
}


format_build_archive_name () {
	local tag
	expect_args tag -- "$@"

	local label
	label=$( get_tag_label "${tag}" )

	echo "halcyon-build-${label}.tar.gz"
}


do_build_app () {
	expect_vars HALCYON_BASE \
		HALCYON_APP_NO_STRIP

	local tag must_copy must_configure source_dir build_dir
	expect_args tag must_copy must_configure source_dir build_dir -- "$@"

	expect_existing "${source_dir}" || return 1
	if (( must_copy )); then
		copy_dir_over "${source_dir}" "${build_dir}" || return 1
	else
		expect_existing "${build_dir}/.halcyon-tag" || return 1
	fi

	local prefix ghc_version cabal_version
	prefix=$( get_tag_prefix "${tag}" )
	ghc_version=$( get_tag_ghc_version "${tag}" )
	cabal_version=$( get_tag_cabal_version "${tag}" )

	if (( must_copy )) || (( must_configure )); then
		log 'Configuring app'

		local -a opts_a
		opts_a=()
		if [[ -f "${source_dir}/.halcyon/extra-configure-flags" ]]; then
			opts_a=( $( <"${source_dir}/.halcyon/extra-configure-flags" ) ) || true
		fi
		opts_a+=( --prefix="${prefix}" )
		opts_a+=( --verbose )

		local stdout
		stdout=$( get_tmp_file 'cabal-configure.stdout' ) || return 1

		if ! sandboxed_cabal_do "${build_dir}" configure "${opts_a[@]}" >"${stdout}" 2>&1 | quote; then
			quote <"${stdout}"

			log_error 'Failed to configure app'
			return 1
		fi

		# NOTE: Storing the data dir helps implement
		# HALCYON_EXTRA_DATA_FILES, which works around unusual Cabal
		# globbing for the data-files package description entry.
		# https://github.com/haskell/cabal/issues/713
		# https://github.com/haskell/cabal/issues/784
		local data_dir
		if ! data_dir=$(
			awk '	/Data files installed in:/ { i = 1 }
				/Documentation installed in:/ { i = 0 }
				i' <"${stdout}" |
			strip_trailing_newline |
			tr '\n' ' ' |
			sed 's/^Data files installed in: //'
		) ||
			! echo "${data_dir}" >"${build_dir}/dist/.halcyon-data-dir"
		then
			log_error 'Failed to write data directory file'
			return 1
		fi
	else
		expect_existing "${build_dir}/dist/.halcyon-data-dir" || return 1
	fi

	if [[ -f "${source_dir}/.halcyon/pre-build-hook" ]]; then
		log 'Executing pre-build hook'
		if ! HALCYON_INTERNAL_RECURSIVE=1 \
			HALCYON_GHC_VERSION="${ghc_version}" \
			HALCYON_CABAL_VERSION="${cabal_version}" \
			"${source_dir}/.halcyon/pre-build-hook" \
				"${tag}" "${source_dir}" "${build_dir}" 2>&1 | quote
		then
			log_error 'Failed to execute pre-build hook'
			return 1
		fi
		log 'Pre-build hook executed'
	fi

	log 'Building app'

	local built_size
	if ! sandboxed_cabal_do "${build_dir}" build 2>&1 | quote ||
		! built_size=$( get_size "${build_dir}" )
	then
		log_error 'Failed to build app'
		return 1
	fi
	log "App built, ${built_size}"

	if [[ -f "${source_dir}/.halcyon/post-build-hook" ]]; then
		log 'Executing post-build hook'
		if ! HALCYON_INTERNAL_RECURSIVE=1 \
			HALCYON_GHC_VERSION="${ghc_version}" \
			HALCYON_CABAL_VERSION="${cabal_version}" \
			"${source_dir}/.halcyon/post-build-hook" \
				"${tag}" "${source_dir}" "${build_dir}" 2>&1 | quote
		then
			log_error 'Failed to execute post-build hook'
			return 1
		fi
		log 'Post-build hook executed'
	fi

	if ! (( HALCYON_APP_NO_STRIP )); then
		log_indent_begin 'Stripping app...'

		local stripped_size
		if ! strip_tree "${build_dir}" ||
			! stripped_size=$( get_size "${build_dir}" )
		then
			log_indent_end 'error'
			return 1
		fi
		log_indent_end "done, ${stripped_size}"
	fi

	if ! derive_build_tag "${tag}" >"${build_dir}/.halcyon-tag"; then
		log_error 'Failed to write build tag'
		return 1
	fi
}


archive_build_dir () {
	expect_vars HALCYON_NO_ARCHIVE \
		HALCYON_INTERNAL_PLATFORM

	local build_dir
	expect_args build_dir -- "$@"

	if (( HALCYON_NO_ARCHIVE )); then
		return 0
	fi

	expect_existing "${build_dir}/.halcyon-tag" || return 1

	local build_tag ghc_id archive_name
	build_tag=$( detect_build_tag "${build_dir}/.halcyon-tag" ) || return 1
	ghc_id=$( format_ghc_id "${build_tag}" )
	archive_name=$( format_build_archive_name "${build_tag}" )

	log 'Archiving build directory'

	create_cached_archive "${build_dir}" "${archive_name}" || return 1
	upload_cached_file "${HALCYON_INTERNAL_PLATFORM}/ghc-${ghc_id}" "${archive_name}" || return 1
}


validate_potential_build_dir () {
	local tag build_dir
	expect_args tag build_dir -- "$@"

	local potential_pattern
	potential_pattern=$( derive_potential_build_tag_pattern "${tag}" )
	detect_tag "${build_dir}/.halcyon-tag" "${potential_pattern}" || return 1
}


validate_configured_build_dir () {
	local tag build_dir
	expect_args tag build_dir -- "$@"

	local configured_pattern
	configured_pattern=$( derive_configured_build_tag_pattern "${tag}" )
	detect_tag "${build_dir}/.halcyon-tag" "${configured_pattern}" || return 1

	if [[ ! -f "${build_dir}/dist/setup-config" ]]; then
		return 1
	fi
}


validate_build_dir () {
	local tag build_dir
	expect_args tag build_dir -- "$@"

	local build_tag
	build_tag=$( derive_build_tag "${tag}" )
	detect_tag "${build_dir}/.halcyon-tag" "${build_tag//./\.}" || return 1

	if [[ ! -f "${build_dir}/dist/setup-config" ]]; then
		return 1
	fi
}


restore_build_dir () {
	expect_vars HALCYON_INTERNAL_PLATFORM

	local tag build_dir
	expect_args tag build_dir -- "$@"

	local ghc_id archive_name
	ghc_id=$( format_ghc_id "${tag}" )
	archive_name=$( format_build_archive_name "${tag}" )

	log 'Restoring build directory'

	if ! extract_cached_archive_over "${archive_name}" "${build_dir}" ||
		! validate_potential_build_dir "${tag}" "${build_dir}" >'/dev/null'
	then
		rm -rf "${build_dir}" || true
		cache_stored_file "${HALCYON_INTERNAL_PLATFORM}/ghc-${ghc_id}" "${archive_name}" || return 1

		if ! extract_cached_archive_over "${archive_name}" "${build_dir}" ||
			! validate_potential_build_dir "${tag}" "${build_dir}" >'/dev/null'
		then
			rm -rf "${build_dir}" || true

			log_warning 'Failed to restore build directory'
			return 1
		fi
	else
		touch_cached_file "${archive_name}"
	fi
}


prepare_build_dir () {
	local tag source_dir build_dir
	expect_args tag source_dir build_dir -- "$@"

	expect_existing "${source_dir}" "${build_dir}/.halcyon-tag" \
		"${build_dir}/dist/setup-config" || return 1

	local -a opts_a
	opts_a=()
	# NOTE: Ignoring the same files as in hash_source.
	opts_a+=( \( -name '.git' )
	opts_a+=( -o -name '.gitmodules' )
	opts_a+=( -o -name '.ghc' )
	opts_a+=( -o -name '.cabal' )
	opts_a+=( -o -name '.cabal-sandbox' )
	opts_a+=( -o -name 'cabal.sandbox.config' )
	if [[ -f "${source_dir}/.halcyon/extra-source-hash-ignore" ]]; then
		local ignore
		while read -r ignore; do
			opts_a+=( -o -name "${ignore}" )
		done <"${source_dir}/.halcyon/extra-source-hash-ignore"
	fi
	# NOTE: Ignoring files expected in build dir only, even though
	# they may also be in source dir.
	opts_a+=( -o -name '.halcyon-tag' )
	opts_a+=( -o -name 'dist' )
	opts_a+=( \) -prune -o )

	local all_files
	all_files=$( compare_tree "${build_dir}" "${source_dir}" "${opts_a[@]}" )

	local changed_files
	if ! changed_files=$(
		filter_not_matching '^= ' <<<"${all_files}" |
		match_at_least_one
	); then
		return 0
	fi

	log 'Examining source changes'

	quote <<<"${changed_files}"

	local label prepare_dir
	label=$( get_tag_label "${tag}" )
	prepare_dir=$( get_tmp_dir "prepare-${label}" ) || return 1

	copy_dir_over "${source_dir}" "${prepare_dir}" || return 1

	# NOTE: Restoring file modification times of unchanged files is
	# necessary to avoid needless recompilation.
	local file
	filter_matching '^= ' <<<"${all_files}" |
		while read -r file; do
			touch -r "${build_dir}/${file#= }" "${prepare_dir}/${file#= }" || true
		done

	# NOTE: Any build products outside dist will have to be rebuilt.
	# See alex or happy for examples.
	rm -rf "${prepare_dir}/dist" || return 1
	mv "${build_dir}/.halcyon-tag" "${prepare_dir}/.halcyon-tag" || return 1
	mv "${build_dir}/dist" "${prepare_dir}/dist" || return 1
	rm -rf "${build_dir}" || return 1
	mv "${prepare_dir}" "${build_dir}" || return 1

	# NOTE: With build-type: Custom, changing Setup.hs requires manually
	# re-running configure, as Cabal fails to detect the change.
	# Detecting changes in cabal.config works around a Cabal issue.
	# https://github.com/mietek/haskell-on-heroku/issues/29
	# https://github.com/haskell/cabal/issues/1992
	if filter_matching "^. (\.halcyon/extra-configure-flags|cabal\.config|Setup\.hs|.*\.cabal)$" <<<"${changed_files}" |
		match_at_least_one >'/dev/null'
	then
		rm -f "${build_dir}/dist/setup-config" || true
	fi
}


build_app () {
	expect_vars HALCYON_NO_BUILD \
		HALCYON_APP_REBUILD HALCYON_APP_RECONFIGURE \
		HALCYON_SANDBOX_REBUILD

	local tag source_dir build_dir
	expect_args tag source_dir build_dir -- "$@"

	# NOTE: Returns 2 if build is needed.
	if (( HALCYON_NO_BUILD )); then
		log_error 'Cannot build app'
		return 2
	fi

	if ! (( HALCYON_APP_REBUILD )) && ! (( HALCYON_SANDBOX_REBUILD )) &&
		restore_build_dir "${tag}" "${build_dir}"
	then
		if ! (( HALCYON_APP_RECONFIGURE )) &&
			validate_build_dir "${tag}" "${build_dir}" >'/dev/null'
		then
			return 0
		fi

		local must_copy must_configure
		must_copy=0
		must_configure="${HALCYON_APP_RECONFIGURE}"
		if ! prepare_build_dir "${tag}" "${source_dir}" "${build_dir}"; then
			must_copy=1
		elif ! validate_configured_build_dir "${tag}" "${build_dir}" >'/dev/null'; then
			must_configure=1
		fi
		do_build_app "${tag}" "${must_copy}" "${must_configure}" "${source_dir}" "${build_dir}" || return 1
		archive_build_dir "${build_dir}" || return 1
		return 0
	fi

	local must_copy must_configure
	must_copy=1
	must_configure=1
	do_build_app "${tag}" "${must_copy}" "${must_configure}" "${source_dir}" "${build_dir}" || return 1
	archive_build_dir "${build_dir}" || return 1
}
