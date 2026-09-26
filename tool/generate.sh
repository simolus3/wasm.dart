#!/bin/sh

pushd pkg/wasi
./generate.sh
popd

pushd integration_tests
dart run tool/generate.dart
popd

pushd pkg/test_runner
dart run wasm_tools witgen -i world.wit
popd

pushd pkg/wasm_tools/example/greeting
dart run wasm_tools witgen -i test.wit
popd
