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
openbsd_version=${DEFAULT_OPENBSD_VERSION}
openbsd_version_short=${DEFAULT_OPENBSD_VERSION_SHORT}
openbsd_architecture=${DEFAULT_OPENBSD_ARCHITECTURE}
openbsd_url=${DEFAULT_OPENBSD_URL}
package_path_url=${DEFAULT_PACKAGE_PATH_URL}
binary_path_url=${DEFAULT_BINARY_PATH_URL}
package_directory=${DEFAULT_PACKAGE_DIRECTORY}
package_list=${DEFAULT_PACKAGE_LIST}
binary_list=${DEFAULT_BINARY_LIST}
com0_speed=${DEFAULT_COM0_SPEED}
image_size=${DEFAULT_IMAGE_SIZE}
base_directory=${DEFAULT_BASE_DIRECTORY}
binary_directory=${DEFAULT_BINARY_DIRECTORY}
resflash_commit=${DEFAULT_RESFLASH_COMMIT}
resflash_source_url=${DEFAULT_RESFLASH_SOURCE_URL}

# Check if the script is executes as root user
if [ $(id -u) -ne 0 ]; then
  echo 'Please run the script as root user.'
  exit 1
fi

# TODO: check if git is installed

# Parse options first
while :; do
  case ${1} in
    -h|--help)                        print_usage;                      shift;;
    -v|--version)                     print_version  && exit 1;         shift;;
    -d|--change-openbsd-version)      change_openbsd_version ${2};      shift 2;;
    -a|--change-openbsd-architecture) change_openbsd_architecture ${2}; shift 2;;
    -p|--package-directory)           package_directory=${2};           shift 2;;
    -b|--base-directory)              base_directory=${2};              shift 2;;
    -l|--package-list)                package_list=${2};                shift 2;;
    -x|--binary-list)                 binary_list=${2};                 shift 2;;
    -m|--image-directory)             image_directory=${2};             shift 2;;
    -s|--com0-speed)                  com0_speed=${2};                  shift 2;;
    -i|--image-size)                  image_size=${2};                  shift 2;;
    -r|--resflash-commit)             resflash_commit=${2};             shift 2;;
    -u|--resflash-source-url)         resflash_source_url=${2};         shift 2;;
    -*|--*)                           print_usage;;
    *)                                print_usage;;
  esac
done

# TODO: get the resflash sources

# TODO: get the packages to be installed on the resflash image

# TODO: get the OpenBSD binary packages

# TODO: populate the base directory

# TODO: do the final base directory modifications

# TODO: call the resflash script to create the image and filesystem files

# TODO: move the image and filesystem files to the image directory
