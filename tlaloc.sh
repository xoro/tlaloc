#!/bin/sh

# tlaloc script
# Copyright Timo Pallach <timo@pallach.de>, see LICENSE for details

#set -o errexit
#set -o nounset
#if [ "$(set -o|grep pipefail)" ]; then
#  set -o pipefail
#fi

# Set some tlaloc global variables
TLALOC_VERSION=0.0.1

. ./tlaloc.conf
. ./tlaloc.sub

# Set the variables to default
show_config=${DEFAULT_SHOW_CONFIG}

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

package_list=${DEFAULT_PACKAGE_LIST}
binary_list=${DEFAULT_BINARY_LIST}

com0_speed=${DEFAULT_COM0_SPEED}
image_size=${DEFAULT_IMAGE_SIZE}
resflash_commit=${DEFAULT_RESFLASH_COMMIT}
resflash_source_url=${DEFAULT_RESFLASH_SOURCE_URL}

enable_debug=${DEFAULT_ENABLE_DEBUG}

# Check if the script is executes as root user
if [ $(id -u) -ne 0 ]; then
  echo 'Please run the script as root user.'
  exit 1
fi

# Check if git is installed
type git &> /dev/null
if [ ${?} -ne 0 ]; then
  echo "Git is not installed on the system but it is required to get resflash."
  echo "Please install it using the following command:"
  echo "pkg_add git"
  exit 1
fi

# Parse options first
while :; do
  # Exit the while loop if we have no options passed.
  if [ ${#} -eq 0 ]; then
    break;
  fi
  case ${1} in
    --help)                 print_usage;                  shift;;
    --version)              print_version && exit 1;      shift;;
    --show-config)          show_config=YES;              shift;;
    --enable-debug)         enable_debug=YES;             shift;;

    --openbsd-version)      change_openbsd_version ${2};  shift 2;;
    --openbsd-arch)         change_openbsd_arch ${2};     shift 2;;
    --openbsd-url)          openbsd_url=${2}              shift 2;;

    --package-directory)    package_directory=${2};       shift 2;;
    --binary-directory)     binary_directory=${2};        shift 2;;
    --base-directory)       base_directory=${2};          shift 2;;
    --image-directory)      image_directory=${2};         shift 2;;

    --package-list)         package_list=${2};            shift 2;;
    --binary-list)          binary_list=${2};             shift 2;;

    --com0-speed)           com0_speed=${2};              shift 2;;
    --image-size)           image_size=${2};              shift 2;;
    --resflash-commit)      resflash_commit=${2};         shift 2;;
    --resflash-source-url)  resflash_source_url=${2};     shift 2;;
    -*|--*)                 print_usage;;
    *)                      break;;
  esac
done

# Show the configuration and exit
if [ "${show_config}" == "YES" ]; then
  print_config
fi

# TODO: get the resflash sources

# TODO: get the packages to be installed on the resflash image

# TODO: get the OpenBSD binary packages

# TODO: populate the base directory

# TODO: do the final base directory modifications

# TODO: call the resflash script to create the image and filesystem files

# TODO: move the image and filesystem files to the image directory
