// ignore: import_internal_library
import 'dart:_wasm';

import 'libc.dart';
import 'string.dart';
import 'utils.dart';

final class WasmRegExp {
  final WasmI32 handle;
  final int groupCount;
  final List<WasmStringImplementation> namedGroupNames;
  final List<int> namedGroupCaptureIndices;

  WasmRegExp(
    this.handle,
    this.groupCount,
    this.namedGroupNames,
    this.namedGroupCaptureIndices,
  );

  static WasmRegExp fromExtern(WasmExternRef? ref) {
    return ref!.internalize().toObject() as WasmRegExp;
  }
}

final class WasmRegExpMatch {
  final WasmStringImplementation input;
  final List<int> groupStarts;
  final List<int> groupEnds;
  final List<WasmStringImplementation> namedGroupNames;
  final List<int> namedGroupCaptureIndices;

  WasmRegExpMatch(
    this.input,
    this.groupStarts,
    this.groupEnds,
    this.namedGroupNames,
    this.namedGroupCaptureIndices,
  );

  static WasmRegExpMatch fromExtern(WasmExternRef? ref) {
    return ref!.internalize().toObject() as WasmRegExpMatch;
  }
}

WasmExternRef embedderRegexpCreateOrFailWithString(
  WasmExternRef? stringRef,
  WasmI32 multiLine,
  WasmI32 caseSensitive,
  WasmI32 unicode,
  WasmI32 dotAll,
) {
  final pattern = WasmStringImplementation.fromExtern(stringRef);
  final length = pattern.length;
  final patternPtr = length > 0
      ? mallocAligned(const WasmI32(2), (length * 2).toWasmI32())
      : const WasmI32(2);
  final addr = patternPtr.toIntUnsigned();
  for (int i = 0; i < length; i++) {
    memory.storeInt16(
      addr + i * 2,
      WasmI32.fromInt(pattern.codeUnitAtUnchecked(i)),
    );
  }

  final handle = dartRegexpCompile(
    patternPtr,
    length.toWasmI32(),
    multiLine,
    caseSensitive,
    unicode,
    dotAll,
  );

  if (length > 0) {
    dartFree(patternPtr, (length * 2).toWasmI32(), const WasmI32(2));
  }

  if (dartRegexpIsError(handle).toIntSigned() != 0) {
    final errPtr = dartRegexpGetErrorPtr(handle);
    final errLen = dartRegexpGetErrorLen(handle).toIntUnsigned();

    final errBytes = WasmArray<WasmI16>(errLen);
    final errAddr = errPtr.toIntUnsigned();
    for (int i = 0; i < errLen; i++) {
      errBytes.write(i, memory.loadUint16(errAddr + i * 2).toIntUnsigned());
    }
    final errMsg = Utf16String.fromCharCodes(
      errBytes,
      const WasmI32(0),
      errLen.toWasmI32(),
    );

    dartRegexpFree(handle);
    return WasmAnyRef.fromObject(errMsg).externalize();
  }

  final groupCount = dartRegexpGetGroupCount(handle).toIntUnsigned();
  final namedCount = dartRegexpGetNamedGroupCount(handle).toIntUnsigned();
  final List<WasmStringImplementation> namedNames = [];
  final List<int> namedCaptureIndices = [];

  if (namedCount > 0) {
    final capIdxPtr = mallocAligned(const WasmI32(4), const WasmI32(4));

    for (int i = 0; i < namedCount; i++) {
      final nameLen = dartRegexpGetNamedGroupInfo(
        handle,
        i.toWasmI32(),
        capIdxPtr,
        const WasmI32(0),
      ).toIntUnsigned();

      final capIdx = memory
          .loadUint32(capIdxPtr.toIntUnsigned())
          .toIntUnsigned();

      final namePtr = mallocAligned(
        const WasmI32(2),
        (nameLen * 2).toWasmI32(),
      );
      dartRegexpGetNamedGroupInfo(handle, i.toWasmI32(), capIdxPtr, namePtr);

      final nameBytes = WasmArray<WasmI16>(nameLen);
      final nameAddr = namePtr.toIntUnsigned();
      for (int j = 0; j < nameLen; j++) {
        nameBytes.write(j, memory.loadUint16(nameAddr + j * 2).toIntUnsigned());
      }
      final name = Utf16String.fromCharCodes(
        nameBytes,
        const WasmI32(0),
        nameLen.toWasmI32(),
      );

      namedNames.add(name);
      namedCaptureIndices.add(capIdx);

      dartFree(namePtr, (nameLen * 2).toWasmI32(), const WasmI32(2));
    }

    dartFree(capIdxPtr, const WasmI32(4), const WasmI32(4));
  }

  final wasmRegExp = WasmRegExp(
    handle,
    groupCount,
    namedNames,
    namedCaptureIndices,
  );
  return WasmAnyRef.fromObject(wasmRegExp).externalize();
}

WasmI32 embedderRegexpIsRegexp(WasmExternRef? ref) {
  if (ref.isNull) return const WasmI32(0);
  final obj = ref!.internalize().toObject();
  if (obj is WasmRegExp) return const WasmI32(1);
  return const WasmI32(0);
}

WasmExternRef embedderRegexpEscape(WasmExternRef? stringRef) {
  final string = WasmStringImplementation.fromExtern(stringRef);
  final len = string.length;

  final WasmArray<WasmI16> chars = WasmArray(len * 2);
  int destIdx = 0;
  for (int i = 0; i < len; i++) {
    final char = string.codeUnitAtUnchecked(i);
    if (char == 92 || // \
        char == 42 || // *
        char == 43 || // +
        char == 63 || // ?
        char == 94 || // ^
        char == 36 || // $
        char == 40 || // (
        char == 41 || // )
        char == 91 || // [
        char == 93 || // ]
        char == 123 || // {
        char == 125 || // }
        char == 124 || // |
        char ==
            46 // .
            ) {
      chars.write(destIdx++, 92);
    }
    chars.write(destIdx++, char);
  }

  final result = Utf16String.fromCharCodes(
    chars,
    const WasmI32(0),
    destIdx.toWasmI32(),
  );
  return WasmAnyRef.fromObject(result).externalize();
}

WasmExternRef? embedderRegexpMatch(
  WasmExternRef? regexpRef,
  WasmExternRef? stringRef,
  WasmI32 start,
  WasmI32 asPrefix,
) {
  if (regexpRef.isNull || stringRef.isNull) return WasmExternRef.nullRef;

  final regexp = WasmRegExp.fromExtern(regexpRef);
  final string = WasmStringImplementation.fromExtern(stringRef);

  final length = string.length;
  final stringPtr = length > 0
      ? mallocAligned(const WasmI32(2), (length * 2).toWasmI32())
      : const WasmI32(2);
  final addr = stringPtr.toIntUnsigned();
  for (int i = 0; i < length; i++) {
    memory.storeInt16(
      addr + i * 2,
      WasmI32.fromInt(string.codeUnitAtUnchecked(i)),
    );
  }

  final numGroups = regexp.groupCount + 1;
  final arraySize = numGroups * 2;
  final outPtr = mallocAligned(const WasmI32(4), (arraySize * 4).toWasmI32());

  final matchSuccess = dartRegexpMatch(
    regexp.handle,
    stringPtr,
    length.toWasmI32(),
    start,
    asPrefix,
    outPtr,
  );

  if (length > 0) {
    dartFree(stringPtr, (length * 2).toWasmI32(), const WasmI32(2));
  }

  if (matchSuccess.toIntSigned() == 0) {
    dartFree(outPtr, (arraySize * 4).toWasmI32(), const WasmI32(4));
    return WasmExternRef.nullRef;
  }

  final List<int> groupStarts = [];
  final List<int> groupEnds = [];
  final outAddr = outPtr.toIntUnsigned();
  for (int i = 0; i < numGroups; i++) {
    groupStarts.add(memory.loadInt32(outAddr + i * 8).toIntSigned());
    groupEnds.add(memory.loadInt32(outAddr + i * 8 + 4).toIntSigned());
  }

  dartFree(outPtr, (arraySize * 4).toWasmI32(), const WasmI32(4));

  final match = WasmRegExpMatch(
    string,
    groupStarts,
    groupEnds,
    regexp.namedGroupNames,
    regexp.namedGroupCaptureIndices,
  );
  return WasmAnyRef.fromObject(match).externalize();
}

WasmI32 embedderRegexpMatchGetStart(WasmExternRef? matchRef) {
  final match = WasmRegExpMatch.fromExtern(matchRef);
  return WasmI32.fromInt(match.groupStarts[0]);
}

WasmI32 embedderRegexpMatchGetEnd(WasmExternRef? matchRef) {
  final match = WasmRegExpMatch.fromExtern(matchRef);
  return WasmI32.fromInt(match.groupEnds[0]);
}

WasmI32 embedderRegexpMatchGetGroupCount(WasmExternRef? matchRef) {
  final match = WasmRegExpMatch.fromExtern(matchRef);
  return WasmI32.fromInt(match.groupStarts.length - 1);
}

WasmExternRef? embedderRegexpMatchGetGroup(
  WasmExternRef? matchRef,
  WasmI32 index,
) {
  final match = WasmRegExpMatch.fromExtern(matchRef);
  final idx = index.toIntSigned();
  if (idx < 0 || idx >= match.groupStarts.length) return WasmExternRef.nullRef;
  final start = match.groupStarts[idx];
  final end = match.groupEnds[idx];
  if (start == -1 || end == -1) return WasmExternRef.nullRef;
  final sub = match.input.substring(start.toWasmI32(), end.toWasmI32());
  return WasmAnyRef.fromObject(sub).externalize();
}

WasmI32 embedderRegexpMatchGetNamedGroups(WasmExternRef? matchRef) {
  final match = WasmRegExpMatch.fromExtern(matchRef);
  return WasmI32.fromInt(match.namedGroupNames.length);
}

WasmExternRef embedderRegexpMatchGetGroupName(
  WasmExternRef? matchRef,
  WasmI32 index,
) {
  final match = WasmRegExpMatch.fromExtern(matchRef);
  final name = match.namedGroupNames[index.toIntUnsigned()];
  return WasmAnyRef.fromObject(name).externalize();
}

WasmExternRef? embedderRegexpMatchGetGroupByName(
  WasmExternRef? matchRef,
  WasmI32 nameIndex,
) {
  final match = WasmRegExpMatch.fromExtern(matchRef);
  final idx = nameIndex.toIntSigned();
  if (idx < 0 || idx >= match.namedGroupCaptureIndices.length) {
    return WasmExternRef.nullRef;
  }
  final capIdx = match.namedGroupCaptureIndices[idx];
  final start = match.groupStarts[capIdx];
  final end = match.groupEnds[capIdx];
  if (start == -1 || end == -1) return WasmExternRef.nullRef;
  final sub = match.input.substring(start.toWasmI32(), end.toWasmI32());
  return WasmAnyRef.fromObject(sub).externalize();
}

WasmExternRef? embedderStringReplaceAllString(
  WasmExternRef? stringRef,
  WasmExternRef? needleRef,
  WasmExternRef? replacementRef,
) {
  final string = WasmStringImplementation.fromExtern(stringRef);
  final needle = WasmStringImplementation.fromExtern(needleRef);
  final replacement = WasmStringImplementation.fromExtern(replacementRef);

  final len = string.length;
  final nLen = needle.length;

  if (nLen == 0) {
    var result = replacement;
    for (int i = 0; i < len; i++) {
      final char = string.substring(i.toWasmI32(), (i + 1).toWasmI32());
      result = result.concat(char);
      result = result.concat(replacement);
    }
    return WasmAnyRef.fromObject(result).externalize();
  }

  var result = Latin1String.empty as WasmStringImplementation;
  int start = 0;
  while (true) {
    final idx = string.indexOfString(needle, start);
    if (idx == -1) {
      final rest = string.substring(start.toWasmI32(), len.toWasmI32());
      result = result.concat(rest);
      break;
    }
    final prefix = string.substring(start.toWasmI32(), idx.toWasmI32());
    result = result.concat(prefix);
    result = result.concat(replacement);
    start = idx + nLen;
  }
  return WasmAnyRef.fromObject(result).externalize();
}

WasmExternRef? embedderStringReplaceAllRegExp(
  WasmExternRef? stringRef,
  WasmExternRef? regexpRef,
  WasmExternRef? replacementRef,
) {
  final string = WasmStringImplementation.fromExtern(stringRef);
  final replacement = WasmStringImplementation.fromExtern(replacementRef);

  final len = string.length;
  var result = Latin1String.empty as WasmStringImplementation;

  int start = 0;
  while (start <= len) {
    final matchRef = embedderRegexpMatch(
      regexpRef,
      stringRef,
      start.toWasmI32(),
      const WasmI32(0),
    );
    if (matchRef.isNull) {
      final rest = string.substring(start.toWasmI32(), len.toWasmI32());
      result = result.concat(rest);
      break;
    }

    final match = WasmRegExpMatch.fromExtern(matchRef);
    final matchStart = match.groupStarts[0];
    final matchEnd = match.groupEnds[0];

    final prefix = string.substring(start.toWasmI32(), matchStart.toWasmI32());
    result = result.concat(prefix);
    result = result.concat(replacement);

    if (matchEnd == matchStart) {
      if (matchStart < len) {
        final nextChar = string.substring(
          matchStart.toWasmI32(),
          (matchStart + 1).toWasmI32(),
        );
        result = result.concat(nextChar);
      }
      start = matchStart + 1;
    } else {
      start = matchEnd;
    }
  }

  return WasmAnyRef.fromObject(result).externalize();
}
