#!/bin/sh

dart run wasm_tools witgen -i wit/ -w "wasi:cli/command" -w "wasi:http/service"
