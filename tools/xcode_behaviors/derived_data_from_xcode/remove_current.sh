#! /bin/bash
WORKSPACE_NAME=`basename ${XcodeWorkspace} .xcworkspace`
DERIVED_DATA_FOLDER="${HOME}/Library/Developer/Xcode/DerivedData/"
for WORKSPACE_FOLDER in `ls "${DERIVED_DATA_FOLDER}" | grep "${WORKSPACE_NAME}-.*$"`
do
  WORKSPACE_FOLDER_IN_DERIVED_DATA="${DERIVED_DATA_FOLDER}${WORKSPACE_FOLDER}"
  rm -rf "${WORKSPACE_FOLDER_IN_DERIVED_DATA}"
done
