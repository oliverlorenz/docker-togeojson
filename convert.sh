#!/bin/bash

function getLowerFileExt {
	SOURCE_FILENAME=$1
	TARGET_FILE_NAME=`echo $SOURCE_FILENAME | cut -d. -f1`
	TARGET_FILE_EXTENSION=`echo $SOURCE_FILENAME | cut -d. -f2-3 | tr -t [:upper:] [:lower:] | sed -e 's/gpx/json/'`
	echo "${TARGET_FILE_NAME}.${TARGET_FILE_EXTENSION}"
}

function convertSourceToTargetFileName () 
{
    SOURCE_FILE_PATH=${1:-$(</dev/stdin)};
    SOURCE_FILE_NAME=$(basename $SOURCE_FILE_PATH)
    TARGET_FILE_NAME=$(getLowerFileExt ${SOURCE_FILE_NAME})
    echo "${TARGET_FILE_NAME}"
}

function convertSourceToTargetDirectory () 
{
    SOURCE_FILE_PATH=$1;
    TARGET_FILE_PATH=$(echo ${SOURCE_FILE_PATH} | sed -e 's/\.\/_data\/gpx/.\/_data\/geojson/')
    echo "${TARGET_FILE_PATH}"
}

function convertSourceToTargetFilePath () {
    SOURCE_FILE_PATH=${1:-$(</dev/stdin)};
    echo $(convertSourceToTargetDirectory $SOURCE_FILE_PATH)/$(convertSourceToTargetFileName $SOURCE_FILE_PATH)
}

function isFileAlreadyConverted ()
{
    SOURCE_FILE_PATH=${1:-$(</dev/stdin)};
    FULL_PATH=$(getTargetFilePath ${SOURCE_FILE_PATH})
    if [ -f "${FULL_PATH}" ]; then
        return 0;
    else
        return 1;
    fi
}

function getTargetFilePath ()
{
    SOURCE_FILE_PATH=$1;
    THUMBNAIL_SIZES=$2;
    SOURCE_DIRECTORY=$(dirname $SOURCE_FILE_PATH)
    echo "$(convertSourceToTargetDirectory $SOURCE_DIRECTORY)/$(convertSourceToTargetFileName $SOURCE_FILE_PATH)"
}

function convertFile ()
{
    SOURCE_FILE_PATH=$1;
    THUMBNAIL_SIZE=$2

    TARGET_FILE_PATH=$(getTargetFilePath ${SOURCE_FILE_PATH})
    echo "$SOURCE_FILE_PATH -> $TARGET_FILE_PATH"
    togeojson $SOURCE_FILE_PATH > $TARGET_FILE_PATH;
}

SOURCE_FILE_PATH_LIST=$(find ./_data/gpx -type f \( -name "*.gpx" \))
SOURCE_DIRECTORIES_LIST=$(echo "$SOURCE_FILE_PATH_LIST" | xargs dirname | sort | uniq)

for SOURCE_DIRECTORY in ${SOURCE_DIRECTORIES_LIST}; do
    DIRECTORY_TO_CREATE=$(convertSourceToTargetDirectory $SOURCE_DIRECTORY)
    if [ ! -d $DIRECTORY_TO_CREATE ]; then
        echo "create directory \"${DIRECTORY_TO_CREATE}\""
        mkdir -p ${DIRECTORY_TO_CREATE}
    fi
done

for SOURCE_FILE_PATH in ${SOURCE_FILE_PATH_LIST}; do
    if isFileAlreadyConverted $SOURCE_FILE_PATH; then
        echo "${SOURCE_FILE_PATH} -> already converted"
    else
        convertFile $SOURCE_FILE_PATH
    fi
done
