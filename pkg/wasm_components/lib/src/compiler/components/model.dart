/// Utilities to build a WebAssembly component.
final class ModelBuilder {}

/**
TODO: Be able to generate something like this

(component
  (type $result (result))
  (type $exit-type (func (param "status" $result)))

  (type $ty-exit-instance (instance
      (export (;0;) "exit" (func (type $exit-type)))
  ))
  (import "wasi:cli/exit@0.2.12" (instance $exit-instance (type $ty-exit-instance)))

  (core module $C
    (func $exit (import "runtime" "exit") (param i32))
    (func (export "add") (result i32) (i32.const 1))
  )

  (alias export $exit-instance "exit" (func $exit))
  (canon lower (func $exit) (core func $exit))
  (core instance $host-imports
    (export "exit" (func $exit))
  )

  (core instance $c (instantiate $C (with "runtime" (instance $host-imports))))

  (type $main (func (result (result))))
  (component $exports
    (import "import-main" (func (type $main)))
    (export "run" (func 0) (func (type $main)))
  )

  (canon lift (core func $c "add") (func $run (type $main)))
  (instance $mainInstance (instantiate $exports
    (with "import-main" (func $run))
  ))
  (export "wasi:cli/run@0.2.12" (instance $mainInstance))
)

 */
