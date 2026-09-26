import 'dart:convert';

import 'package:test/test.dart';
import 'package:wasm_tools/src/compiler/abi/abi.dart';
import 'package:wasm_tools/src/compiler/abi/linker.dart';
import 'package:wasm_tools/src/compiler/abi/reader.dart';
import 'package:wasm_tools/src/compiler/components/component.dart';
import 'package:wasm_tools/src/compiler/components/definition.dart';

import '../components/utils.dart';

void main() {
  group('Package', () {
    test('parse', () {
      expect(Package.parse('wasi:foo'), Package('wasi:foo'));
      expect(Package.parse('wasi:foo@0.3.0'), Package('wasi:foo', '0.3.0'));

      expect(() => Package.parse('invalid:package@1@2'), throwsArgumentError);
    });

    test('fullInterfaceName', () {
      expect(Package('wasi:foo').fullInterfaceName('bar'), 'wasi:foo/bar');
      expect(
        Package('wasi:foo', '0.3.0').fullInterfaceName('bar'),
        'wasi:foo/bar@0.3.0',
      );
    });
  });

  group('abi', () {
    test('interface types', () async {
      final abi = ProgramAbi();
      readAbi(abi, json.decode(_exampleAbi) as Map<String, Object?>);

      final component = ComponentBuilder();
      final linker = Linker(component);
      linker.importInstance(abi.interfaces['wasi:cli/stdout@0.3.0']!);

      expect(await componentToWat(component), r'''
(component
  (type (;0;)
    (instance
      (type (;0;) (enum "io" "illegal-byte-sequence" "pipe"))
      (export (;1;) "error-code" (type (eq 0)))
    )
  )
  (import "wasi:cli/types@0.3.0" (instance (;0;) (type 0)))
  (alias export 0 "error-code" (type (;1;)))
  (type (;2;)
    (instance
      (alias outer 1 1 (type (;0;)))
      (export (;1;) "error-code" (type (eq 0)))
      (type (;2;) u8)
      (type (;3;) (stream 2))
      (type (;4;) (result (error 1)))
      (type (;5;) (future 4))
      (type (;6;) (func (param "data" 3) (result 5)))
      (export (;0;) "write-via-stream" (func (type 6)))
    )
  )
  (import "wasi:cli/stdout@0.3.0" (instance (;1;) (type 2)))
)
''');
    });

    test('exports', () {
      final abi = ProgramAbi();
      readAbi(abi, json.decode(_exampleAbi) as Map<String, Object?>);

      expect(abi.exports, hasLength(1));
    });

    test('primitive type aliases preserve interface ownership', () async {
      final abi = ProgramAbi();
      readAbi(abi, json.decode(_primitiveAliasAbi) as Map<String, Object?>);

      final component = ComponentBuilder();
      final linker = Linker(component);
      linker.importInstance(abi.interfaces['wasi:http/types@0.3.0']!);

      expect(await componentToWat(component), r'''
(component
  (type (;0;)
    (instance
      (type (;0;) u64)
      (export (;1;) "duration" (type (eq 0)))
    )
  )
  (import "wasi:clocks/types@0.3.0" (instance (;0;) (type 0)))
  (alias export 0 "duration" (type (;1;)))
  (type (;2;)
    (instance
      (alias outer 1 1 (type (;0;)))
      (export (;1;) "duration" (type (eq 0)))
      (type (;2;) string)
      (type (;3;) (variant (case "other" 2)))
      (export (;4;) "error-code" (type (eq 3)))
      (type (;5;) string)
      (export (;6;) "field-name" (type (eq 5)))
      (type (;7;) u16)
      (export (;8;) "status-code" (type (eq 7)))
      (type (;9;) (func (param "name" 6) (result 8)))
      (export (;0;) "header-status" (func (type 9)))
    )
  )
  (import "wasi:http/types@0.3.0" (instance (;1;) (type 2)))
)
''');

      expect(
        await componentToWit(component),
        allOf(
          contains('use wasi:clocks/types@0.3.0.{duration};'),
          contains('type field-name = string;'),
          contains('type status-code = u16;'),
        ),
      );
    });

    test('exported interface skips imported type aliases', () async {
      final abi = ProgramAbi();
      readAbi(abi, json.decode(_primitiveAliasAbi) as Map<String, Object?>);

      final component = ComponentBuilder();
      final linker = Linker(component);
      final httpTypes = abi.interfaces['wasi:http/types@0.3.0']!;
      final exportedInstance = abi.exports.single.instantiate(linker);
      component.export(
        Export(httpTypes.fullName, .componentInstance, exportedInstance),
      );

      expect(
        await componentToWit(component),
        allOf(
          contains('export wasi:http/types@0.3.0;'),
          contains('type field-name = string;'),
          contains('type status-code = u16;'),
        ),
      );
    });
  });
}

const _exampleAbi = r'''
{
  "imports": [
    {
      "import_name": "stream2.new",
      "definition": {
        "StreamNew": {
          "stream_type": 2
        }
      },
      "lower_options": {
        "uses_memory": false,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": false,
        "uses_callback": false
      }
    },
    {
      "import_name": "stream2.write",
      "definition": {
        "StreamWrite": {
          "stream_type": 2
        }
      },
      "lower_options": {
        "uses_memory": true,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": true,
        "uses_callback": false
      }
    },
    {
      "import_name": "stream2.drop-writable",
      "definition": {
        "StreamDropWritable": {
          "stream_type": 2
        }
      },
      "lower_options": {
        "uses_memory": false,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": false,
        "uses_callback": false
      }
    },
    {
      "import_name": "future4.new",
      "definition": {
        "FutureNew": {
          "future_type": 4
        }
      },
      "lower_options": {
        "uses_memory": false,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": false,
        "uses_callback": false
      }
    },
    {
      "import_name": "future4.write",
      "definition": {
        "FutureWrite": {
          "future_type": 4
        }
      },
      "lower_options": {
        "uses_memory": true,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": true,
        "uses_callback": false
      }
    },
    {
      "import_name": "future4.read",
      "definition": {
        "FutureRead": {
          "future_type": 4
        }
      },
      "lower_options": {
        "uses_memory": true,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": true,
        "uses_callback": false
      }
    },
    {
      "import_name": "future4.drop-readable",
      "definition": {
        "FutureDropReadable": {
          "future_type": 4
        }
      },
      "lower_options": {
        "uses_memory": false,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": false,
        "uses_callback": false
      }
    },
    {
      "import_name": "future4.drop-writable",
      "definition": {
        "FutureDropWritable": {
          "future_type": 4
        }
      },
      "lower_options": {
        "uses_memory": false,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": false,
        "uses_callback": false
      }
    },
    {
      "import_name": "_import8",
      "definition": {
        "Instance": {
          "interface": 1,
          "function_name": "write-via-stream"
        }
      },
      "lower_options": {
        "uses_memory": false,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": false,
        "uses_callback": false
      }
    },
    {
      "import_name": "_component_0taskReturn",
      "definition": {
        "TaskReturn": {
          "result_list": [
            5
          ]
        }
      },
      "lower_options": {
        "uses_memory": false,
        "uses_strings": false,
        "uses_realloc": false,
        "is_async": false,
        "uses_callback": false
      }
    }
  ],
  "exports": [
    {
      "implements": 2,
      "functions": {
        "run": {
          "exported_name": "component_0",
          "options": {
            "uses_memory": false,
            "uses_strings": false,
            "uses_realloc": false,
            "is_async": false,
            "uses_callback": true
          },
          "parameters": [],
          "result": 5
        }
      }
    }
  ],
  "world": {
    "worlds": [
      {
        "name": "root",
        "imports": {
          "interface-0": {
            "interface": {
              "id": 0
            }
          },
          "interface-1": {
            "interface": {
              "id": 1
            }
          }
        },
        "exports": {
          "interface-2": {
            "interface": {
              "id": 2
            }
          }
        },
        "package": 1
      }
    ],
    "interfaces": [
      {
        "name": "types",
        "types": {
          "error-code": 0
        },
        "functions": {},
        "package": 0
      },
      {
        "name": "stdout",
        "types": {
          "error-code": 1
        },
        "functions": {
          "write-via-stream": {
            "name": "write-via-stream",
            "kind": "freestanding",
            "params": [
              {
                "name": "data",
                "type": 2
              }
            ],
            "result": 4
          }
        },
        "package": 0
      },
      {
        "name": "run",
        "types": {},
        "functions": {
          "run": {
            "name": "run",
            "kind": "async-freestanding",
            "params": [],
            "result": 5
          }
        },
        "package": 0
      }
    ],
    "types": [
      {
        "name": "error-code",
        "kind": {
          "enum": {
            "cases": [
              {
                "name": "io",
                "docs": {
                  "contents": "Input/output error"
                }
              },
              {
                "name": "illegal-byte-sequence",
                "docs": {
                  "contents": "Invalid or incomplete multibyte or wide character"
                }
              },
              {
                "name": "pipe",
                "docs": {
                  "contents": "Broken pipe"
                }
              }
            ]
          }
        },
        "owner": {
          "interface": 0
        }
      },
      {
        "name": "error-code",
        "kind": {
          "type": 0
        },
        "owner": {
          "interface": 1
        }
      },
      {
        "name": null,
        "kind": {
          "stream": "u8"
        },
        "owner": null
      },
      {
        "name": null,
        "kind": {
          "result": {
            "ok": null,
            "err": 1
          }
        },
        "owner": null
      },
      {
        "name": null,
        "kind": {
          "future": 3
        },
        "owner": null
      },
      {
        "name": null,
        "kind": {
          "result": {
            "ok": null,
            "err": null
          }
        },
        "owner": null
      }
    ],
    "packages": [
      {
        "name": "wasi:cli@0.3.0",
        "interfaces": {
          "types": 0,
          "stdout": 1,
          "run": 2
        },
        "worlds": {}
      },
      {
        "name": "root:component",
        "interfaces": {},
        "worlds": {
          "root": 0
        }
      }
    ]
  }
}
''';

const _primitiveAliasAbi = r'''
{
  "imports": [],
  "exports": [
    {
      "implements": 1,
      "functions": {}
    }
  ],
  "world": {
    "worlds": [
      {
        "name": "root",
        "imports": {
          "interface-0": {
            "interface": {
              "id": 0
            }
          },
          "interface-1": {
            "interface": {
              "id": 1
            }
          }
        },
        "exports": {},
        "package": 2
      }
    ],
    "interfaces": [
      {
        "name": "types",
        "types": {
          "duration": 0
        },
        "functions": {},
        "package": 0
      },
      {
        "name": "types",
        "types": {
          "duration": 1,
          "error-code": 2,
          "field-name": 3,
          "status-code": 4
        },
        "functions": {
          "header-status": {
            "name": "header-status",
            "kind": "freestanding",
            "params": [
              {
                "name": "name",
                "type": 3
              }
            ],
            "result": 4
          }
        },
        "package": 1
      }
    ],
    "types": [
      {
        "name": "duration",
        "kind": {
          "type": "u64"
        },
        "owner": {
          "interface": 0
        }
      },
      {
        "name": "duration",
        "kind": {
          "type": 0
        },
        "owner": {
          "interface": 1
        }
      },
      {
        "name": "error-code",
        "kind": {
          "variant": {
            "cases": [
              {
                "name": "other",
                "type": "string"
              }
            ]
          }
        },
        "owner": {
          "interface": 1
        }
      },
      {
        "name": "field-name",
        "kind": {
          "type": "string"
        },
        "owner": {
          "interface": 1
        }
      },
      {
        "name": "status-code",
        "kind": {
          "type": "u16"
        },
        "owner": {
          "interface": 1
        }
      }
    ],
    "packages": [
      {
        "name": "wasi:clocks@0.3.0",
        "interfaces": {
          "types": 0
        },
        "worlds": {}
      },
      {
        "name": "wasi:http@0.3.0",
        "interfaces": {
          "types": 1
        },
        "worlds": {}
      },
      {
        "name": "root:component",
        "interfaces": {},
        "worlds": {
          "root": 0
        }
      }
    ]
  }
}
''';
