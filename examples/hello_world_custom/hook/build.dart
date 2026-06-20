import 'dart:convert';

import 'package:hooks/hooks.dart';
import 'package:wasm_components/hooks.dart';

void main(List<String> args) => build(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    output.assets.webAssemblyComponents.add(
      WasmComponentAsset(
        encoded: json.decode(_encoded) as Map<String, Object?>,
      ),
    );
  }
});

const _encoded = '''
{"type_defs":[{"name":null,"kind":{"result":{"ok":null,"err":null}},"owner":null}],"interfaces":[{"full_name":"dart:components/print@0.0.1","exported_functions":{"print":{"name":"print","kind":"freestanding","params":[{"name":"line","type":"string"}],"docs":{"contents":"Prints a message to stdout."}}}},{"full_name":"wasi:cli/run@0.2.12","exported_functions":{"run":{"name":"run","kind":"freestanding","params":[],"result":0}}}],"imports":[{"interface_id":0,"function_name":"print","core_name":"_import0","options":{"use_memory":true,"uses_strings":true}}],"exports":[{"interface_id":1,"function_name":"run","core_export_name":"component_0","options":{"use_memory":false,"uses_strings":false}}]}
''';
