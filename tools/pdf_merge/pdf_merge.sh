#!/bin/bash

function usage {
  echo "Given a pdf book, it generates a new one scaling and merging the pages."
  echo "If 4x1 it generates the cover full page and 4 pages per portrait sheet."
  echo "If 2x1 it generates 2 pages per landspace sheet."
  echo ""
  echo "usage:"
  echo 'pdf_merge [4x1|2x1] file'
  echo ''
}

function convert_4x1 {
  original=$1

  if [ ! -f "$original" ]; then
  	echo "${original} doesn't exist"
  	return
  fi

  originalFilename=`basename "$original"`
  originalDir=`dirname "$original"`
  output="${originalDir}/4x1_${originalFilename}"

  if [ -f "${output}" ]; then
  	echo "${output} already exists exist"
  	return
  fi

  echo "Converting: ${originalFilename}"

  scaleContentToFit "${original}" "scaled.pdf"
  merge4x1 "scaled.pdf" "merged.pdf"
  extractCover "${original}" "cover.pdf"
  mergeCoverAndContent "cover.pdf" "merged.pdf" "${output}"

  rm "scaled.pdf"
  rm "merged.pdf"
  rm "cover.pdf"

  echo "Succesfully converted, saved at ${output}"
}

function convert_2x1 {
  original=$1

  if [ ! -f "$original" ]; then
      echo "${original} doesn't exist"
      return
  fi

  originalFilename=`basename "$original"`
  originalDir=`dirname "$original"`
  output="${originalDir}/2x1_${originalFilename}"

  if [ -f "${output}" ]; then
      echo "${output} already exists exist"
      return
  fi

  echo "Converting: ${originalFilename}"

  scaleContentToFit "${original}" "scaled.pdf"
  merge2x1 "scaled.pdf" "${output}"
  
  rm "scaled.pdf"

  echo "Succesfully converted, saved at ${output}"
}

function scaleContentToFit {
  in="$1"
  out="$2"
  echo $1
  echo $2
  execute "  Scaling content to fit..." "cpdf -scale-to-fit a4portrait \"${in}\" -o \"${out}\""
}

function merge4x1 {
  in="$1"
  out="$2"
  execute "  Merging 4 pages into 1..." "pdfnup --quiet --nup 2x2 --no-landscape --frame true --delta \"0.2cm 0.2cm\" --scale 0.95 \"${in}\" --outfile \"${out}\""
}

function merge2x1 {
  in="$1"
  out="$2"
  execute "  Merging 2 pages into 1..." "pdfnup --quiet --nup 2x1 --rotateoversize true --frame true --delta \"0.2cm 0.2cm\" --scale 0.95 \"${in}\" --outfile \"${out}\""
}

function extractCover {
  in="$1"
  out="$2"
  execute "  Extracting cover..." "pdfjam --quiet \"${in}\" 1 -o \"${out}\""
}

function mergeCoverAndContent {
  cover="$1"
  content="$2"
  output="$3"
  execute "  Adding cover to content..." "pdfjam --quiet \"${cover}\" \"${content}\" --outfile \"${output}\""
}

function execute {
  desc=$1
  cmd=$2
  echo "${desc}"
  foutput=$(eval ${cmd})
}

MODE=''

if [ -z "$1" ] || [ -z "$2" ]; then
  usage; exit 1
fi

if [ "$1" == "4x1" ]; then
  convert_4x1 "$2"
elif [ "$1" == "2x1" ]; then
  convert_2x1 "$2"
else
  usage
fi

exit 1

# pdfcrop original.pdf a.pdf
# cpdf -scale-to-fit a4portrait a.pdf -o b.pdf
# pdfnup --nup 2x2 --no-landscape --frame true --delta "0.2cm 0.2cm" --scale 0.95 b.pdf --outfile c.pdf
# pdfjam original.pdf 1 -o cover.pdf
# pdfjam cover.pdf c.pdf --outfile output.pdf
# rm cover.pdf
# rm c.pdf
# rm b.pdf
# rm a.pdf

# brew cask install basictex
# set PATH /Library/TeX/texbin/ $PATH
# brew install ghostscript
# brew tap oncletom/brew
# brew install cpdf
# sudo tlmgr install pdfcrop


