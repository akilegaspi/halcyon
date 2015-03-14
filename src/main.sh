set_halcyon_vars () {
	if ! (( ${HALCYON_INTERNAL_VARS:-0} )); then
		export HALCYON_INTERNAL_VARS=1

		export HALCYON_DEFAULT_ROOT='/'
		export HALCYON_DEFAULT_CACHE='/var/tmp/halcyon-cache'
		export HALCYON_DEFAULT_PUBLIC_STORAGE_URL='https://halcyon.global.ssl.fastly.net'
		export HALCYON_DEFAULT_S3_ENDPOINT='s3.amazonaws.com'
		export HALCYON_DEFAULT_S3_ACL='private'
		export HALCYON_DEFAULT_GHC_VERSION='7.8.4'
		export HALCYON_DEFAULT_CABAL_VERSION='1.20.0.3'
		export HALCYON_DEFAULT_CABAL_REMOTE_REPO='hackage:http://hackage.haskell.org/packages/archive'

		# NOTE: HALCYON_BASE is set in paths.sh.
		export HALCYON_PREFIX="${HALCYON_PREFIX:-${HALCYON_BASE}}"
		export HALCYON_ROOT="${HALCYON_ROOT:-${HALCYON_DEFAULT_ROOT}}"
		export HALCYON_NO_APP="${HALCYON_NO_APP:-0}"
		export HALCYON_NO_MODIFY_HOME="${HALCYON_NO_MODIFY_HOME:-0}"
		export HALCYON_LOG_TIMESTAMP="${HALCYON_LOG_TIMESTAMP:-0}"

		export HALCYON_EXTRA_SOURCE_HASH_IGNORE="${HALCYON_EXTRA_SOURCE_HASH_IGNORE:-}"
		export HALCYON_CONSTRAINTS="${HALCYON_CONSTRAINTS:-}"
		export HALCYON_IGNORE_ALL_CONSTRAINTS="${HALCYON_IGNORE_ALL_CONSTRAINTS:-0}"
		export HALCYON_EXTRA_CONFIGURE_FLAGS="${HALCYON_EXTRA_CONFIGURE_FLAGS:-}"
		export HALCYON_PRE_BUILD_HOOK="${HALCYON_PRE_BUILD_HOOK:-}"
		export HALCYON_POST_BUILD_HOOK="${HALCYON_POST_BUILD_HOOK:-}"
		export HALCYON_APP_REBUILD="${HALCYON_APP_REBUILD:-0}"
		export HALCYON_APP_RECONFIGURE="${HALCYON_APP_RECONFIGURE:-0}"
		export HALCYON_NO_BUILD="${HALCYON_NO_BUILD:-0}"
		export HALCYON_NO_BUILD_DEPENDENCIES="${HALCYON_NO_BUILD_DEPENDENCIES:-0}"
		export HALCYON_DEPENDENCIES_ONLY="${HALCYON_DEPENDENCIES_ONLY:-0}"

		export HALCYON_EXTRA_APPS="${HALCYON_EXTRA_APPS:-}"
		export HALCYON_EXTRA_APPS_CONSTRAINTS="${HALCYON_EXTRA_APPS_CONSTRAINTS:-}"
		export HALCYON_EXTRA_DATA_FILES="${HALCYON_EXTRA_DATA_FILES:-}"
		export HALCYON_EXTRA_OS_PACKAGES="${HALCYON_EXTRA_OS_PACKAGES:-}"
		export HALCYON_PRE_INSTALL_HOOK="${HALCYON_PRE_INSTALL_HOOK:-}"
		export HALCYON_POST_INSTALL_HOOK="${HALCYON_POST_INSTALL_HOOK:-}"
		export HALCYON_APP_REINSTALL="${HALCYON_APP_REINSTALL:-0}"
		export HALCYON_KEEP_DEPENDENCIES="${HALCYON_KEEP_DEPENDENCIES:-0}"

		export HALCYON_CACHE="${HALCYON_CACHE:-${HALCYON_DEFAULT_CACHE}}"
		export HALCYON_PURGE_CACHE="${HALCYON_PURGE_CACHE:-0}"
		export HALCYON_NO_ARCHIVE="${HALCYON_NO_ARCHIVE:-0}"
		export HALCYON_NO_CLEAN_CACHE="${HALCYON_NO_CLEAN_CACHE:-0}"

		export HALCYON_PUBLIC_STORAGE_URL="${HALCYON_PUBLIC_STORAGE_URL:-${HALCYON_DEFAULT_PUBLIC_STORAGE_URL}}"
		export HALCYON_NO_PUBLIC_STORAGE="${HALCYON_NO_PUBLIC_STORAGE:-0}"

		export HALCYON_AWS_ACCESS_KEY_ID="${HALCYON_AWS_ACCESS_KEY_ID:-}"
		export HALCYON_AWS_SECRET_ACCESS_KEY="${HALCYON_AWS_SECRET_ACCESS_KEY:-}"
		export HALCYON_S3_BUCKET="${HALCYON_S3_BUCKET:-}"
		export HALCYON_S3_ENDPOINT="${HALCYON_S3_ENDPOINT:-${HALCYON_DEFAULT_S3_ENDPOINT}}"
		export HALCYON_S3_ACL="${HALCYON_S3_ACL:-${HALCYON_DEFAULT_S3_ACL}}"
		export HALCYON_NO_PRIVATE_STORAGE="${HALCYON_NO_PRIVATE_STORAGE:-0}"
		export HALCYON_NO_UPLOAD="${HALCYON_NO_UPLOAD:-0}"
		export HALCYON_NO_CLEAN_PRIVATE_STORAGE="${HALCYON_NO_CLEAN_PRIVATE_STORAGE:-0}"

		export HALCYON_GHC_VERSION="${HALCYON_GHC_VERSION:-${HALCYON_DEFAULT_GHC_VERSION}}"
		export HALCYON_GHC_PRE_BUILD_HOOK="${HALCYON_GHC_PRE_BUILD_HOOK:-}"
		export HALCYON_GHC_POST_BUILD_HOOK="${HALCYON_GHC_POST_BUILD_HOOK:-}"
		export HALCYON_GHC_REBUILD="${HALCYON_GHC_REBUILD:-0}"

		export HALCYON_CABAL_VERSION="${HALCYON_CABAL_VERSION:-${HALCYON_DEFAULT_CABAL_VERSION}}"
		export HALCYON_CABAL_REMOTE_REPO="${HALCYON_CABAL_REMOTE_REPO:-${HALCYON_DEFAULT_CABAL_REMOTE_REPO}}"
		export HALCYON_CABAL_PRE_BUILD_HOOK="${HALCYON_CABAL_PRE_BUILD_HOOK:-}"
		export HALCYON_CABAL_POST_BUILD_HOOK="${HALCYON_CABAL_POST_BUILD_HOOK:-}"
		export HALCYON_CABAL_PRE_UPDATE_HOOK="${HALCYON_CABAL_PRE_UPDATE_HOOK:-}"
		export HALCYON_CABAL_POST_UPDATE_HOOK="${HALCYON_CABAL_POST_UPDATE_HOOK:-}"
		export HALCYON_CABAL_REBUILD="${HALCYON_CABAL_REBUILD:-0}"
		export HALCYON_CABAL_UPDATE="${HALCYON_CABAL_UPDATE:-0}"

		export HALCYON_SANDBOX_EXTRA_CONFIGURE_FLAGS="${HALCYON_SANDBOX_EXTRA_CONFIGURE_FLAGS:-}"
		export HALCYON_SANDBOX_SOURCES="${HALCYON_SANDBOX_SOURCES:-}"
		export HALCYON_SANDBOX_EXTRA_APPS="${HALCYON_SANDBOX_EXTRA_APPS:-}"
		export HALCYON_SANDBOX_EXTRA_APPS_CONSTRAINTS="${HALCYON_SANDBOX_EXTRA_APPS_CONSTRAINTS:-}"
		export HALCYON_SANDBOX_EXTRA_OS_PACKAGES="${HALCYON_SANDBOX_EXTRA_OS_PACKAGES:-}"
		export HALCYON_SANDBOX_PRE_BUILD_HOOK="${HALCYON_SANDBOX_PRE_BUILD_HOOK:-}"
		export HALCYON_SANDBOX_POST_BUILD_HOOK="${HALCYON_SANDBOX_POST_BUILD_HOOK:-}"
		export HALCYON_SANDBOX_REBUILD="${HALCYON_SANDBOX_REBUILD:-0}"

		export HALCYON_INTERNAL_COMMAND="${HALCYON_INTERNAL_COMMAND:-}"
		export HALCYON_INTERNAL_RECURSIVE="${HALCYON_INTERNAL_RECURSIVE:-0}"
		export HALCYON_INTERNAL_REMOTE_SOURCE="${HALCYON_INTERNAL_REMOTE_SOURCE:-0}"
		export HALCYON_INTERNAL_TOLERATE_GHC_USER_DB="${HALCYON_INTERNAL_TOLERATE_GHC_USER_DB:-0}"
		export HALCYON_INTERNAL_NO_ANNOUNCE_INSTALL="${HALCYON_INTERNAL_NO_ANNOUNCE_INSTALL:-0}"
		export HALCYON_INTERNAL_NO_CLEANUP="${HALCYON_INTERNAL_NO_CLEANUP:-0}"
		export HALCYON_INTERNAL_NO_COPY_LOCAL_SOURCE="${HALCYON_INTERNAL_NO_COPY_LOCAL_SOURCE:-0}"
		export HALCYON_INTERNAL_CABAL_MAGIC_HASH="${HALCYON_INTERNAL_CABAL_MAGIC_HASH:-}"
		export HALCYON_INTERNAL_GHC_MAGIC_HASH="${HALCYON_INTERNAL_GHC_MAGIC_HASH:-}"
	fi

	if (( HALCYON_INTERNAL_RECURSIVE )); then
		export HALCYON_LOG_TIMESTAMP=0

		export HALCYON_EXTRA_SOURCE_HASH_IGNORE=''
		export HALCYON_CONSTRAINTS=''
		export HALCYON_IGNORE_ALL_CONSTRAINTS=0
		export HALCYON_EXTRA_CONFIGURE_FLAGS=''
		export HALCYON_PRE_BUILD_HOOK=''
		export HALCYON_POST_BUILD_HOOK=''
		export HALCYON_APP_REBUILD=0
		export HALCYON_APP_RECONFIGURE=0
		export HALCYON_DEPENDENCIES_ONLY=0

		export HALCYON_EXTRA_APPS=''
		export HALCYON_EXTRA_APPS_CONSTRAINTS=''
		export HALCYON_EXTRA_DATA_FILES=''
		export HALCYON_EXTRA_OS_PACKAGES=''
		export HALCYON_PRE_INSTALL_HOOK=''
		export HALCYON_POST_INSTALL_HOOK=''
		export HALCYON_APP_REINSTALL=0
		export HALCYON_KEEP_DEPENDENCIES=0

		export HALCYON_GHC_REBUILD=0

		export HALCYON_CABAL_REBUILD=0
		export HALCYON_CABAL_UPDATE=0

		export HALCYON_SANDBOX_EXTRA_CONFIGURE_FLAGS=''
		export HALCYON_SANDBOX_SOURCES=''
		export HALCYON_SANDBOX_EXTRA_APPS=''
		export HALCYON_SANDBOX_EXTRA_APPS_CONSTRAINTS=''
		export HALCYON_SANDBOX_EXTRA_OS_PACKAGES=''
		export HALCYON_SANDBOX_PRE_BUILD_HOOK=''
		export HALCYON_SANDBOX_POST_BUILD_HOOK=''
		export HALCYON_SANDBOX_REBUILD=0

		export HALCYON_INTERNAL_NO_ANNOUNCE_INSTALL=0
	fi
}


halcyon_main () {
	expect_vars HALCYON_DIR

	expect_existing "${HALCYON_DIR}" || return 1

	local cmd
	local -a args_a
	cmd=''
	args_a=()

	while (( $# )); do
		case "$1" in

	# General options
		'--base')
			shift
			expect_args base_dir -- "$@"
			export HALCYON_BASE="${base_dir}";;
		'--base='*)
			export HALCYON_BASE="${1#*=}";;
		'--prefix')
			shift
			expect_args prefix -- "$@"
			export HALCYON_PREFIX="${prefix}";;
		'--prefix='*)
			export HALCYON_PREFIX="${1#*=}";;
		'--root')
			shift
			expect_args root -- "$@"
			export HALCYON_ROOT="${root}";;
		'--root='*)
			export HALCYON_ROOT="${1#*=}";;
		'--no-app')
			export HALCYON_NO_APP=1;;
		'--no-modify-home')
			export HALCYON_NO_MODIFY_HOME=1;;
		'--log-timestamp')
			export HALCYON_LOG_TIMESTAMP=1;;

	# Build-time options
		'--extra-source-hash-ignore')
			shift
			expect_args extra_source_hash_ignore -- "$@"
			export HALCYON_EXTRA_SOURCE_HASH_IGNORE="${extra_source_hash_ignore}";;
		'--extra-source-hash-ignore='*)
			export HALCYON_EXTRA_SOURCE_HASH_IGNORE="${1#*=}";;
		'--constraints')
			shift
			expect_args constraints -- "$@"
			export HALCYON_CONSTRAINTS="${constraints}";;
		'--constraints='*)
			export HALCYON_CONSTRAINTS="${1#*=}";;
		'--ignore-all-constraints')
			export HALCYON_IGNORE_ALL_CONSTRAINTS=1;;
		'--extra-configure-flags')
			shift
			expect_args extra_configure_flags -- "$@"
			export HALCYON_EXTRA_CONFIGURE_FLAGS="${extra_configure_flags}";;
		'--extra-configure-flags='*)
			export HALCYON_EXTRA_CONFIGURE_FLAGS="${1#*=}";;
		'--pre-build-hook')
			shift
			expect_args pre_build_hook -- "$@"
			export HALCYON_PRE_BUILD_HOOK="${pre_build_hook}";;
		'--pre-build-hook='*)
			export HALCYON_PRE_BUILD_HOOK="${1#*=}";;
		'--post-build-hook')
			shift
			expect_args post_build_hook -- "$@"
			export HALCYON_POST_BUILD_HOOK="${post_build_hook}";;
		'--post-build-hook='*)
			export HALCYON_POST_BUILD_HOOK="${1#*=}";;
		'--app-rebuild')
			export HALCYON_APP_REBUILD=1;;
		'--app-reconfigure')
			export HALCYON_APP_RECONFIGURE=1;;
		'--no-build')
			export HALCYON_NO_BUILD=1;;
		'--no-build-dependencies')
			export HALCYON_NO_BUILD_DEPENDENCIES=1;;
		'--dependencies-only')
			export HALCYON_DEPENDENCIES_ONLY=1;;

	# Install-time options
		'--extra-apps')
			shift
			expect_args extra_apps -- "$@"
			export HALCYON_EXTRA_APPS="${extra_apps}";;
		'--extra-apps='*)
			export HALCYON_EXTRA_APPS="${1#*=}";;
		'--extra-apps-constraints')
			shift
			expect_args extra_apps_constraints -- "$@"
			export HALCYON_EXTRA_APPS_CONSTRAINTS="${extra_apps_constraints}";;
		'--extra-apps-constraints='*)
			export HALCYON_EXTRA_APPS_CONSTRAINTS="${1#*=}";;
		'--extra-data-files')
			shift
			expect_args extra_data_files -- "$@"
			export HALCYON_EXTRA_DATA_FILES="${extra_data_files}";;
		'--extra-data-files='*)
			export HALCYON_EXTRA_DATA_FILES="${1#*=}";;
		'--extra-os-packages')
			shift
			expect_args extra_os_packages -- "$@"
			export HALCYON_EXTRA_OS_PACKAGES="${extra_os_packages}";;
		'--extra-os-packages='*)
			export HALCYON_EXTRA_OS_PACKAGES="${1#*=}";;
		'--pre-install-hook')
			shift
			expect_args pre_install_hook -- "$@"
			export HALCYON_PRE_INSTALL_HOOK="${pre_install_hook}";;
		'--pre-install-hook='*)
			export HALCYON_PRE_INSTALL_HOOK="${1#*=}";;
		'--post-install-hook')
			shift
			expect_args post_install_hook -- "$@"
			export HALCYON_POST_INSTALL_HOOK="${post_install_hook}";;
		'--post-install-hook='*)
			export HALCYON_POST_INSTALL_HOOK="${1#*=}";;
		'--app-reinstall')
			export HALCYON_APP_REINSTALL=1;;
		'--keep-dependencies')
			export HALCYON_KEEP_DEPENDENCIES=1;;

	# Cache options
		'--cache')
			shift
			expect_args cache_dir -- "$@"
			export HALCYON_CACHE="${cache_dir}";;
		'--cache='*)
			export HALCYON_CACHE="${1#*=}";;
		'--purge-cache')
			export HALCYON_PURGE_CACHE=1;;
		'--no-archive')
			export HALCYON_NO_ARCHIVE=1;;
		'--no-clean-cache')
			export HALCYON_NO_CLEAN_CACHE=1;;

	# Public storage options
		'--public-storage-url')
			shift
			expect_args public_storage_url -- "$@"
			export HALCYON_PUBLIC_STORAGE_URL="${public_storage_url}";;
		'--public-storage-url='*)
			export HALCYON_PUBLIC_STORAGE_URL="${1#*=}";;
		'--no-public-storage')
			export HALCYON_NO_PUBLIC_STORAGE=1;;

	# Private storage options
		'--aws-access-key-id')
			shift
			expect_args aws_access_key_id -- "$@"
			export HALCYON_AWS_ACCESS_KEY_ID="${aws_access_key_id}";;
		'--aws-access-key-id='*)
			export HALCYON_AWS_ACCESS_KEY_ID="${1#*=}";;
		'--aws-secret-access-key')
			shift
			expect_args aws_secret_access_key -- "$@"
			export HALCYON_AWS_SECRET_ACCESS_KEY="${aws_secret_access_key}";;
		'--aws-secret-access-key='*)
			export HALCYON_AWS_SECRET_ACCESS_KEY="${1#*=}";;
		'--s3-bucket')
			shift
			expect_args s3_bucket -- "$@"
			export HALCYON_S3_BUCKET="${s3_bucket}";;
		'--s3-bucket='*)
			export HALCYON_S3_BUCKET="${1#*=}";;
		'--s3-endpoint')
			shift
			expect_args s3_endpoint -- "$@"
			export HALCYON_S3_ENDPOINT="${s3_endpoint}";;
		'--s3-endpoint='*)
			export HALCYON_S3_ENDPOINT="${1#*=}";;
		'--s3-acl')
			shift
			expect_args s3_acl -- "$@"
			export HALCYON_S3_ACL="${s3_acl}";;
		'--s3-acl='*)
			export HALCYON_S3_ACL="${1#*=}";;
		'--no-private-storage')
			export HALCYON_NO_PRIVATE_STORAGE=1;;
		'--no-upload')
			export HALCYON_NO_UPLOAD=1;;
		'--no-clean-private-storage')
			export HALCYON_NO_CLEAN_PRIVATE_STORAGE=1;;

	# GHC options
		'--ghc-version')
			shift
			expect_args ghc_version -- "$@"
			export HALCYON_GHC_VERSION="${ghc_version}";;
		'--ghc-version='*)
			export HALCYON_GHC_VERSION="${1#*=}";;
		'--ghc-pre-build-hook')
			shift
			expect_args ghc_pre_build_hook -- "$@"
			export HALCYON_GHC_PRE_BUILD_HOOK="${ghc_pre_build_hook}";;
		'--ghc-pre-build-hook='*)
			export HALCYON_GHC_PRE_BUILD_HOOK="${1#*=}";;
		'--ghc-post-build-hook')
			shift
			expect_args ghc_post_build_hook -- "$@"
			export HALCYON_GHC_POST_BUILD_HOOK="${ghc_post_build_hook}";;
		'--ghc-post-build-hook='*)
			export HALCYON_GHC_POST_BUILD_HOOK="${1#*=}";;
		'--ghc-rebuild')
			export HALCYON_GHC_REBUILD=1;;

	# Cabal options
		'--cabal-version')
			shift
			expect_args cabal_version -- "$@"
			export HALCYON_CABAL_VERSION="${cabal_version}";;
		'--cabal-version='*)
			export HALCYON_CABAL_VERSION="${1#*=}";;
		'--cabal-remote-repo')
			shift
			expect_args cabal_remote_repo -- "$@"
			export HALCYON_CABAL_REMOTE_REPO="${cabal_remote_repo}";;
		'--cabal-remote-repo='*)
			export HALCYON_CABAL_REMOTE_REPO="${1#*=}";;
		'--cabal-pre-build-hook')
			shift
			expect_args cabal_pre_build_hook -- "$@"
			export HALCYON_CABAL_PRE_BUILD_HOOK="${cabal_pre_build_hook}";;
		'--cabal-pre-build-hook='*)
			export HALCYON_CABAL_PRE_BUILD_HOOK="${1#*=}";;
		'--cabal-post-build-hook')
			shift
			expect_args cabal_post_build_hook -- "$@"
			export HALCYON_CABAL_POST_BUILD_HOOK="${cabal_post_build_hook}";;
		'--cabal-post-build-hook='*)
			export HALCYON_CABAL_POST_BUILD_HOOK="${1#*=}";;
		'--cabal-pre-update-hook')
			shift
			expect_args cabal_pre_update_hook -- "$@"
			export HALCYON_CABAL_PRE_UPDATE_HOOK="${cabal_pre_update_hook}";;
		'--cabal-pre-update-hook='*)
			export HALCYON_CABAL_PRE_UPDATE_HOOK="${1#*=}";;
		'--cabal-post-update-hook')
			shift
			expect_args cabal_post_update_hook -- "$@"
			export HALCYON_CABAL_POST_UPDATE_HOOK="${cabal_post_update_hook}";;
		'--cabal-post-update-hook='*)
			export HALCYON_CABAL_POST_UPDATE_HOOK="${1#*=}";;
		'--cabal-rebuild')
			export HALCYON_CABAL_REBUILD=1;;
		'--cabal-update')
			export HALCYON_CABAL_UPDATE=1;;

	# Sandbox options
		'--sandbox-extra-configure-flags')
			shift
			expect_args sandbox_extra_configure_flags -- "$@"
			export HALCYON_SANDBOX_EXTRA_CONFIGURE_FLAGS="${sandbox_extra_configure_flags}";;
		'--sandbox-extra-configure-flags='*)
			export HALCYON_SANDBOX_EXTRA_CONFIGURE_FLAGS="${1#*=}";;
		'--sandbox-sources')
			shift
			expect_args sandbox_sources -- "$@"
			export HALCYON_SANDBOX_SOURCES="${sandbox_sources}";;
		'--sandbox-sources='*)
			export HALCYON_SANDBOX_SOURCES="${1#*=}";;
		'--sandbox-extra-apps')
			shift
			expect_args sandbox_extra_apps -- "$@"
			export HALCYON_SANDBOX_EXTRA_APPS="${sandbox_extra_apps}";;
		'--sandbox-extra-apps='*)
			export HALCYON_SANDBOX_EXTRA_APPS="${1#*=}";;
		'--sandbox-extra-apps-constraints')
			shift
			expect_args sandbox_extra_apps_constraints -- "$@"
			export HALCYON_SANDBOX_EXTRA_APPS_CONSTRAINTS="${sandbox_extra_apps_constraints}";;
		'--sandbox-extra-apps-constraints='*)
			export HALCYON_SANDBOX_EXTRA_APPS_CONSTRAINTS="${1#*=}";;
		'--sandbox-extra-os-packages')
			shift
			expect_args sandbox_extra_os_packages -- "$@"
			export HALCYON_SANDBOX_EXTRA_OS_PACKAGES="${sandbox_extra_os_packages}";;
		'--sandbox-extra-os-packages='*)
			export HALCYON_SANDBOX_EXTRA_OS_PACKAGES="${1#*=}";;
		'--sandbox-pre-build-hook')
			shift
			expect_args sandbox_pre_build_hook -- "$@"
			export HALCYON_SANDBOX_PRE_BUILD_HOOK="${sandbox_pre_build_hook}";;
		'--sandbox-pre-build-hook='*)
			export HALCYON_SANDBOX_PRE_BUILD_HOOK="${1#*=}";;
		'--sandbox-post-build-hook')
			shift
			expect_args sandbox_post_build_hook -- "$@"
			export HALCYON_SANDBOX_POST_BUILD_HOOK="${sandbox_post_build_hook}";;
		'--sandbox-post-build-hook='*)
			export HALCYON_SANDBOX_POST_BUILD_HOOK="${1#*=}";;
		'--sandbox-rebuild')
			export HALCYON_SANDBOX_REBUILD=1;;

		'-h'|'--help')
			help_usage
			return 0
			;;
		'--')
			shift
			while (( $# )); do
				if [[ -z "${cmd}" ]]; then
					cmd="$1"
				else
					args_a+=( "$1" )
				fi
				shift
			done
			break
			;;
		'-'*)
			log_error "Unexpected option: $1"
			help_usage
			return 1
			;;
		*)
			if [[ -z "${cmd}" ]]; then
				cmd="$1"
			else
				args_a+=( "$1" )
			fi
		esac
		shift
	done

	# NOTE: In some circumstances, Cabal can break sandbox isolation.
	# https://github.com/haskell/cabal/issues/2400
	if ! (( HALCYON_INTERNAL_TOLERATE_GHC_USER_DB )) &&
		find_tree ~/.ghc \( -name 'ghci_history' \) -prune -o -type f -print |
		match_at_least_one >'/dev/null'
	then
		log_error 'Unexpected GHC user package database'
		log
		quote <<-EOF
			To disable the GHC user package database:
			$ mv ~/.ghc ~/.ghc.original
EOF
		return 1
	fi

	export HALCYON_INTERNAL_COMMAND="${cmd}"

	if (( HALCYON_LOG_TIMESTAMP )); then
		export BASHMENOT_LOG_TIMESTAMP=1
		export BASHMENOT_TIMESTAMP_EPOCH=$( get_current_time )
	fi

	# NOTE: HALCYON_CACHE must not be /tmp, as the cache cleaning
	# functionality will get confused.
	if [[ "${HALCYON_CACHE}" == '/tmp' ]]; then
		export HALCYON_CACHE='/tmp/halcyon-cache'
	fi

	export BASHMENOT_APT_DIR="${HALCYON_CACHE}/apt"

	export BASHMENOT_AWS_ACCESS_KEY_ID="${HALCYON_AWS_ACCESS_KEY_ID}"
	export BASHMENOT_AWS_SECRET_ACCESS_KEY="${HALCYON_AWS_SECRET_ACCESS_KEY}"
	export BASHMENOT_S3_ENDPOINT="${HALCYON_S3_ENDPOINT}"

	local tmp_dir
	tmp_dir=''
	if [[ -z "${BASHMENOT_INTERNAL_TMP:-}" ]]; then
		tmp_dir=$( get_tmp_dir 'halcyon' ) || return 1

		if ! mkdir -p "${tmp_dir}"; then
			log_error 'Failed to create temporary directory'
			return 1
		fi

		export BASHMENOT_INTERNAL_TMP="${tmp_dir}"
	fi

	# NOTE: Returns 2 if build is needed.
	local status
	status=0
	case "${HALCYON_INTERNAL_COMMAND}" in
	'install'|'build')
		halcyon_install ${args_a[@]:+"${args_a[@]}"} || status="$?"
		;;
	'label'|'executable'|'constraints'|'tag')
		HALCYON_NO_CLEAN_CACHE=1 \
			halcyon_install ${args_a[@]:+"${args_a[@]}"} || status="$?"
		;;
	'paths')
		echo -e "export HALCYON_DIR='${HALCYON_DIR}'"
		echo -e "export HALCYON_INTERNAL_PLATFORM='${HALCYON_INTERNAL_PLATFORM}'\n"

		if ! cat "${HALCYON_DIR}/src/paths.sh"; then
			log_error 'Failed to export paths'
			status=1
		fi
		;;
	'help')
		help_usage
		;;
	'')
		log_error 'Expected command'
		help_usage
		status=1
		;;
	*)
		log_error "Unexpected command: ${cmd} ${args_a[*]:-}"
		help_usage
		status=1
	esac

	if ! (( HALCYON_INTERNAL_NO_CLEANUP )) && [[ -n "${tmp_dir}" ]]; then
		rm -rf "${tmp_dir}" || true
	fi

	return "${status}"
}
