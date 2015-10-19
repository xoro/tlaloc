#!/bin/sh

# tlaloc script
# Copyright Timo Pallach <timo@pallach.de>, see LICENSE for details

# Set some tlaloc global variables
TLALOC_VERSION=1.0.1
TLALOC_DIRECTORY=`pwd`

. ./tlaloc.conf
. ./tlaloc.sub

# Set the variables to default
show_config=${DEFAULT_SHOW_CONFIG}
enable_debug=${DEFAULT_ENABLE_DEBUG}
enable_vga=${DEFAULT_ENABLE_VGA}
skip_base_update=${DEFAULT_SKIP_BASE_UPDATE}

cleanup_directories=${DEFAULT_CLEANUP_DIRECTORIES}
cleanup_base_directory=${DEFAULT_CLEANUP_BASE_DIRECTORY}
cleanup_package_directory=${DEFAULT_CLEANUP_PACKAGE_DIRECTORY}
cleanup_binary_directory=${DEFAULT_CLEANUP_BINARY_DIRECTORY}
cleanup_image_directory=${DEFAULT_CLEANUP_IMAGE_DIRECTORY}
cleanup_resflash_directory=${DEFAULT_CLEANUP_RESFLASH_DIRECTORY}

openbsd_version=${DEFAULT_OPENBSD_VERSION}
openbsd_version_short=${DEFAULT_OPENBSD_VERSION_SHORT}
openbsd_arch=${DEFAULT_OPENBSD_ARCH}
openbsd_url=${DEFAULT_OPENBSD_URL}
openbsd_package_url=${DEFAULT_OPENBSD_PACKAGE_URL}
openbsd_binary_url=${DEFAULT_OPENBSD_BINARY_URL}

base_directory=${DEFAULT_BASE_DIRECTORY}
package_directory=${DEFAULT_PACKAGE_DIRECTORY}
binary_directory=${DEFAULT_BINARY_DIRECTORY}
image_directory=${DEFAULT_IMAGE_DIRECTORY}
resflash_directory=${DEFAULT_RESFLASH_DIRECTORY}

package_list=${DEFAULT_PACKAGE_LIST}
binary_list=${DEFAULT_BINARY_LIST}

com0_speed=${DEFAULT_COM0_SPEED}
image_size=${DEFAULT_IMAGE_SIZE}
resflash_treeish=${DEFAULT_RESFLASH_TREEISH}
resflash_source_url=${DEFAULT_RESFLASH_SOURCE_URL}

# The user of tlaloc has the posibility to overwrite the default configuration
# options by copying his own script tlaloc.conf.logl into the tlaloc root directory.
if [ -f ./tlaloc.conf.local ]; then
  . ./tlaloc.conf.local
  change_openbsd_version ${openbsd_version}
  change_openbsd_arch ${openbsd_arch}
fi

# Parse options first
while :; do
  # Exit the while loop if we have no options passed.
  if [ ${#} -eq 0 ]; then
    break;
  fi
  case ${1} in
    --help)                       print_usage;                    shift;;
    --version)                    print_version && exit 1;        shift;;
    --show-config)                show_config=YES;                shift;;
    --enable-debug)               enable_debug=YES;               shift;;
    --enable-vga)                 enable_vga=YES;                 shift;;
    --skip-base-update)           skip_base_update=YES;           shift;;

    --cleanup-directories)        cleanup_directories=YES;        shift;;
    --cleanup-base-directory)     cleanup_base_directory=YES;     shift;;
    --cleanup-package-directory)  cleanup_package_directory=YES;  shift;;
    --cleanup-binary-directory)   cleanup_binary_directory=YES;   shift;;
    --cleanup-image-directory)    cleanup_image_directory=YES;    shift;;
    --cleanup-resflash-directory) cleanup_resflash_directory=YES; shift;;

    --openbsd-version)            change_openbsd_version ${2};    shift 2;;
    --openbsd-arch)               change_openbsd_arch ${2};       shift 2;;
    --openbsd-url)                openbsd_url=${2}                shift 2;;

    --package-directory)          package_directory=${2};         shift 2;;
    --binary-directory)           binary_directory=${2};          shift 2;;
    --base-directory)             base_directory=${2};            shift 2;;
    --image-directory)            image_directory=${2};           shift 2;;

    --package-list)               package_list=${2};              shift 2;;
    --binary-list)                binary_list=${2};               shift 2;;

    --com0-speed)                 com0_speed=${2};                shift 2;;
    --image-size)                 image_size=${2};                shift 2;;
    --resflash-treeish)           resflash_treeish=${2};          shift 2;;
    --resflash-source-url)        resflash_source_url=${2};       shift 2;;
    -*|--*)                       print_usage;;
    *)                            break;;
  esac
done

# Enable some additional options if the enable-debug configuration parameter is Set
debug "DEBUG" "Checking if the enable debug was set to activate some more options."
if [ "${enable_debug}" == "YES" ]; then
  debug "DEBUG" "Execute \"set -o errexit\" and other options."
  set -o errexit
  set -o nounset
  if [ "$(set -o|grep pipefail)" ]; then
    set -o pipefail
  fi
fi

# Show the configuration and exit
show_config

# Check if the script is executed as root user
is_user_root

# Delete the working directories base, package, binary, image and resflash.
cleanup_working_directories

# Check if git is installed
is_git_installed

# Get the resflash sources and checkout the specific treeish
get_resflash

# Get the packages to be installed on the resflash image
get_packages

# Get the OpenBSD binary packages
get_binaries

# Populate the base directory
populate_base_directory

# Do the final base directory modifications
do_base_modifications

# Call the resflash script to create the image and filesystem files
run_resflash

# Move the image and filesystem files to the image directory
move_image_files
