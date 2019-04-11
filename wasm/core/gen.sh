#!/bin/bash
#
# Generate the test JS files using the WebAssembly reference interpreter, and
# the WebAssembly core testsuite.
#
# Reference Interpreter: https://github.com/WebAssembly/spec/tree/master/interpreter
# Core testsuite: https://github.com/WebAssembly/spec/tree/master/test/core
#
set -e

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <reference interpreter> <core test dir>"
  exit 1
fi

wasm=$1
core_test_dir=$2

for orig in ${core_test_dir}/*.wast; do
  filename=${orig##*/}        # Strip directory.
  basename=${filename%.*}     # Strip extension.
  temp=${basename}.tmp.js     # Must end with .js.
  dest=${basename}.any.js

  # -h:  Don't use default harness.
  # -d:  Don't run the test in the interpreter.
  echo "Processing ${filename} -> ${dest}"
  ${wasm} -h -d ${orig} -o ${temp}
  cat HEADER ${temp} > ${dest}
  rm ${temp}
done
echo "Done."
