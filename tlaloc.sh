#!/bin/sh

# tlaloc script
# Copyright Timo Pallach <timo@pallach.de>, see LICENSE for details

# Set some tlaloc global variables
TLALOC_VERSION=0.0.1

. ./tlaloc.conf
. ./tlaloc.sub

# Set the variables to default
show_config=${DEFAULT_SHOW_CONFIG}
enable_debug=${DEFAULT_ENABLE_DEBUG}

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
resflash_commit=${DEFAULT_RESFLASH_COMMIT}
resflash_source_url=${DEFAULT_RESFLASH_SOURCE_URL}

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
debug "DEBUG" "Checking if the user wants only to show the current configuration."
if [ "${show_config}" == "YES" ]; then
  print_config
fi

# Check if the script is executed as root user
debug "DEBUG" "Checking if the user executing the script is root."
if [ $(id -u) -ne 0 ]; then
  debug "DEBUG" "The script is not run as root user."
  echo 'Please run the script as root user.'
  exit 1
else
  debug "DEBUG" "The script is run as root user."
fi

# Check if git is installed
debug "DEBUG" "Checking if git is installed on the system."
type git &> /dev/null
if [ ${?} -ne 0 ]; then
  debug "DEBUG" "Git is not installed on the system."
  echo "Git is not installed on the system but it is required to get resflash."
  echo "Please install it using the following command:"
  echo "pkg_add git"
  exit 1
else
  debug "DEBUG" "Git is installed on the system."
fi

# TODO: get the resflash sources
debug "DEBUG" "Getting the resflash sources."
git clone ${resflash_source_url} ${resflash_directory}

# TODO: get the packages to be installed on the resflash image

# TODO: get the OpenBSD binary packages

# TODO: populate the base directory

# TODO: do the final base directory modifications

# TODO: call the resflash script to create the image and filesystem files

# TODO: move the image and filesystem files to the image directory
