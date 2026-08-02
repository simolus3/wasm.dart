// ignore_for_file: type=warning
import r'dart:typed_data' as i0;

import r'package:wasm_components/wasm_components.dart' as i1;

sealed class TypesErrorCode {
  const TypesErrorCode._();
  const factory TypesErrorCode.access() = TypesErrorCodeAccess;
  const factory TypesErrorCode.already() = TypesErrorCodeAlready;
  const factory TypesErrorCode.badDescriptor() = TypesErrorCodeBadDescriptor;
  const factory TypesErrorCode.busy() = TypesErrorCodeBusy;
  const factory TypesErrorCode.deadlock() = TypesErrorCodeDeadlock;
  const factory TypesErrorCode.quota() = TypesErrorCodeQuota;
  const factory TypesErrorCode.exist() = TypesErrorCodeExist;
  const factory TypesErrorCode.fileTooLarge() = TypesErrorCodeFileTooLarge;
  const factory TypesErrorCode.illegalByteSequence() =
      TypesErrorCodeIllegalByteSequence;
  const factory TypesErrorCode.inProgress() = TypesErrorCodeInProgress;
  const factory TypesErrorCode.interrupted() = TypesErrorCodeInterrupted;
  const factory TypesErrorCode.invalid() = TypesErrorCodeInvalid;
  const factory TypesErrorCode.io() = TypesErrorCodeIo;
  const factory TypesErrorCode.isDirectory() = TypesErrorCodeIsDirectory;
  const factory TypesErrorCode.loop() = TypesErrorCodeLoop;
  const factory TypesErrorCode.tooManyLinks() = TypesErrorCodeTooManyLinks;
  const factory TypesErrorCode.messageSize() = TypesErrorCodeMessageSize;
  const factory TypesErrorCode.nameTooLong() = TypesErrorCodeNameTooLong;
  const factory TypesErrorCode.noDevice() = TypesErrorCodeNoDevice;
  const factory TypesErrorCode.noEntry() = TypesErrorCodeNoEntry;
  const factory TypesErrorCode.noLock() = TypesErrorCodeNoLock;
  const factory TypesErrorCode.insufficientMemory() =
      TypesErrorCodeInsufficientMemory;
  const factory TypesErrorCode.insufficientSpace() =
      TypesErrorCodeInsufficientSpace;
  const factory TypesErrorCode.notDirectory() = TypesErrorCodeNotDirectory;
  const factory TypesErrorCode.notEmpty() = TypesErrorCodeNotEmpty;
  const factory TypesErrorCode.notRecoverable() = TypesErrorCodeNotRecoverable;
  const factory TypesErrorCode.unsupported() = TypesErrorCodeUnsupported;
  const factory TypesErrorCode.noTty() = TypesErrorCodeNoTty;
  const factory TypesErrorCode.noSuchDevice() = TypesErrorCodeNoSuchDevice;
  const factory TypesErrorCode.overflow() = TypesErrorCodeOverflow;
  const factory TypesErrorCode.notPermitted() = TypesErrorCodeNotPermitted;
  const factory TypesErrorCode.pipe() = TypesErrorCodePipe;
  const factory TypesErrorCode.readOnly() = TypesErrorCodeReadOnly;
  const factory TypesErrorCode.invalidSeek() = TypesErrorCodeInvalidSeek;
  const factory TypesErrorCode.textFileBusy() = TypesErrorCodeTextFileBusy;
  const factory TypesErrorCode.crossDevice() = TypesErrorCodeCrossDevice;
  const factory TypesErrorCode.other(i1.Option<String> payload) =
      TypesErrorCodeOther;
}

final class TypesErrorCodeAccess extends TypesErrorCode {
  const TypesErrorCodeAccess() : super._();
}

final class TypesErrorCodeAlready extends TypesErrorCode {
  const TypesErrorCodeAlready() : super._();
}

final class TypesErrorCodeBadDescriptor extends TypesErrorCode {
  const TypesErrorCodeBadDescriptor() : super._();
}

final class TypesErrorCodeBusy extends TypesErrorCode {
  const TypesErrorCodeBusy() : super._();
}

final class TypesErrorCodeDeadlock extends TypesErrorCode {
  const TypesErrorCodeDeadlock() : super._();
}

final class TypesErrorCodeQuota extends TypesErrorCode {
  const TypesErrorCodeQuota() : super._();
}

final class TypesErrorCodeExist extends TypesErrorCode {
  const TypesErrorCodeExist() : super._();
}

final class TypesErrorCodeFileTooLarge extends TypesErrorCode {
  const TypesErrorCodeFileTooLarge() : super._();
}

final class TypesErrorCodeIllegalByteSequence extends TypesErrorCode {
  const TypesErrorCodeIllegalByteSequence() : super._();
}

final class TypesErrorCodeInProgress extends TypesErrorCode {
  const TypesErrorCodeInProgress() : super._();
}

final class TypesErrorCodeInterrupted extends TypesErrorCode {
  const TypesErrorCodeInterrupted() : super._();
}

final class TypesErrorCodeInvalid extends TypesErrorCode {
  const TypesErrorCodeInvalid() : super._();
}

final class TypesErrorCodeIo extends TypesErrorCode {
  const TypesErrorCodeIo() : super._();
}

final class TypesErrorCodeIsDirectory extends TypesErrorCode {
  const TypesErrorCodeIsDirectory() : super._();
}

final class TypesErrorCodeLoop extends TypesErrorCode {
  const TypesErrorCodeLoop() : super._();
}

final class TypesErrorCodeTooManyLinks extends TypesErrorCode {
  const TypesErrorCodeTooManyLinks() : super._();
}

final class TypesErrorCodeMessageSize extends TypesErrorCode {
  const TypesErrorCodeMessageSize() : super._();
}

final class TypesErrorCodeNameTooLong extends TypesErrorCode {
  const TypesErrorCodeNameTooLong() : super._();
}

final class TypesErrorCodeNoDevice extends TypesErrorCode {
  const TypesErrorCodeNoDevice() : super._();
}

final class TypesErrorCodeNoEntry extends TypesErrorCode {
  const TypesErrorCodeNoEntry() : super._();
}

final class TypesErrorCodeNoLock extends TypesErrorCode {
  const TypesErrorCodeNoLock() : super._();
}

final class TypesErrorCodeInsufficientMemory extends TypesErrorCode {
  const TypesErrorCodeInsufficientMemory() : super._();
}

final class TypesErrorCodeInsufficientSpace extends TypesErrorCode {
  const TypesErrorCodeInsufficientSpace() : super._();
}

final class TypesErrorCodeNotDirectory extends TypesErrorCode {
  const TypesErrorCodeNotDirectory() : super._();
}

final class TypesErrorCodeNotEmpty extends TypesErrorCode {
  const TypesErrorCodeNotEmpty() : super._();
}

final class TypesErrorCodeNotRecoverable extends TypesErrorCode {
  const TypesErrorCodeNotRecoverable() : super._();
}

final class TypesErrorCodeUnsupported extends TypesErrorCode {
  const TypesErrorCodeUnsupported() : super._();
}

final class TypesErrorCodeNoTty extends TypesErrorCode {
  const TypesErrorCodeNoTty() : super._();
}

final class TypesErrorCodeNoSuchDevice extends TypesErrorCode {
  const TypesErrorCodeNoSuchDevice() : super._();
}

final class TypesErrorCodeOverflow extends TypesErrorCode {
  const TypesErrorCodeOverflow() : super._();
}

final class TypesErrorCodeNotPermitted extends TypesErrorCode {
  const TypesErrorCodeNotPermitted() : super._();
}

final class TypesErrorCodePipe extends TypesErrorCode {
  const TypesErrorCodePipe() : super._();
}

final class TypesErrorCodeReadOnly extends TypesErrorCode {
  const TypesErrorCodeReadOnly() : super._();
}

final class TypesErrorCodeInvalidSeek extends TypesErrorCode {
  const TypesErrorCodeInvalidSeek() : super._();
}

final class TypesErrorCodeTextFileBusy extends TypesErrorCode {
  const TypesErrorCodeTextFileBusy() : super._();
}

final class TypesErrorCodeCrossDevice extends TypesErrorCode {
  const TypesErrorCodeCrossDevice() : super._();
}

final class TypesErrorCodeOther extends TypesErrorCode {
  final i1.Option<String> payload;
  const TypesErrorCodeOther(this.payload) : super._();
}

final class TypesDescriptor {}

enum TypesAdvice { normal, sequential, random, willNeed, dontNeed, noReuse }

extension type TypesDescriptorFlags(int representation) implements int {
  bool get read => representation & 0x1 == 0x1;
  TypesDescriptorFlags withRead(bool value) {
    return TypesDescriptorFlags(
      value ? representation | 0x1 : representation & ~0x1,
    );
  }

  bool get write => representation & 0x2 == 0x2;
  TypesDescriptorFlags withWrite(bool value) {
    return TypesDescriptorFlags(
      value ? representation | 0x2 : representation & ~0x2,
    );
  }

  bool get fileIntegritySync => representation & 0x4 == 0x4;
  TypesDescriptorFlags withFileIntegritySync(bool value) {
    return TypesDescriptorFlags(
      value ? representation | 0x4 : representation & ~0x4,
    );
  }

  bool get dataIntegritySync => representation & 0x8 == 0x8;
  TypesDescriptorFlags withDataIntegritySync(bool value) {
    return TypesDescriptorFlags(
      value ? representation | 0x8 : representation & ~0x8,
    );
  }

  bool get requestedWriteSync => representation & 0x10 == 0x10;
  TypesDescriptorFlags withRequestedWriteSync(bool value) {
    return TypesDescriptorFlags(
      value ? representation | 0x10 : representation & ~0x10,
    );
  }

  bool get mutateDirectory => representation & 0x20 == 0x20;
  TypesDescriptorFlags withMutateDirectory(bool value) {
    return TypesDescriptorFlags(
      value ? representation | 0x20 : representation & ~0x20,
    );
  }
}

sealed class TypesDescriptorType {
  const TypesDescriptorType._();
  const factory TypesDescriptorType.blockDevice() =
      TypesDescriptorTypeBlockDevice;
  const factory TypesDescriptorType.characterDevice() =
      TypesDescriptorTypeCharacterDevice;
  const factory TypesDescriptorType.directory() = TypesDescriptorTypeDirectory;
  const factory TypesDescriptorType.fifo() = TypesDescriptorTypeFifo;
  const factory TypesDescriptorType.symbolicLink() =
      TypesDescriptorTypeSymbolicLink;
  const factory TypesDescriptorType.regularFile() =
      TypesDescriptorTypeRegularFile;
  const factory TypesDescriptorType.socket() = TypesDescriptorTypeSocket;
  const factory TypesDescriptorType.other(i1.Option<String> payload) =
      TypesDescriptorTypeOther;
}

final class TypesDescriptorTypeBlockDevice extends TypesDescriptorType {
  const TypesDescriptorTypeBlockDevice() : super._();
}

final class TypesDescriptorTypeCharacterDevice extends TypesDescriptorType {
  const TypesDescriptorTypeCharacterDevice() : super._();
}

final class TypesDescriptorTypeDirectory extends TypesDescriptorType {
  const TypesDescriptorTypeDirectory() : super._();
}

final class TypesDescriptorTypeFifo extends TypesDescriptorType {
  const TypesDescriptorTypeFifo() : super._();
}

final class TypesDescriptorTypeSymbolicLink extends TypesDescriptorType {
  const TypesDescriptorTypeSymbolicLink() : super._();
}

final class TypesDescriptorTypeRegularFile extends TypesDescriptorType {
  const TypesDescriptorTypeRegularFile() : super._();
}

final class TypesDescriptorTypeSocket extends TypesDescriptorType {
  const TypesDescriptorTypeSocket() : super._();
}

final class TypesDescriptorTypeOther extends TypesDescriptorType {
  final i1.Option<String> payload;
  const TypesDescriptorTypeOther(this.payload) : super._();
}

sealed class TypesNewTimestamp {
  const TypesNewTimestamp._();
  const factory TypesNewTimestamp.noChange() = TypesNewTimestampNoChange;
  const factory TypesNewTimestamp.now() = TypesNewTimestampNow;
  const factory TypesNewTimestamp.timestamp(
    ({int seconds, int nanoseconds}) payload,
  ) = TypesNewTimestampTimestamp;
}

final class TypesNewTimestampNoChange extends TypesNewTimestamp {
  const TypesNewTimestampNoChange() : super._();
}

final class TypesNewTimestampNow extends TypesNewTimestamp {
  const TypesNewTimestampNow() : super._();
}

final class TypesNewTimestampTimestamp extends TypesNewTimestamp {
  final ({int seconds, int nanoseconds}) payload;
  const TypesNewTimestampTimestamp(this.payload) : super._();
}

extension type TypesPathFlags(int representation) implements int {
  bool get symlinkFollow => representation & 0x1 == 0x1;
  TypesPathFlags withSymlinkFollow(bool value) {
    return TypesPathFlags(value ? representation | 0x1 : representation & ~0x1);
  }
}

extension type TypesOpenFlags(int representation) implements int {
  bool get create => representation & 0x1 == 0x1;
  TypesOpenFlags withCreate(bool value) {
    return TypesOpenFlags(value ? representation | 0x1 : representation & ~0x1);
  }

  bool get directory => representation & 0x2 == 0x2;
  TypesOpenFlags withDirectory(bool value) {
    return TypesOpenFlags(value ? representation | 0x2 : representation & ~0x2);
  }

  bool get exclusive => representation & 0x4 == 0x4;
  TypesOpenFlags withExclusive(bool value) {
    return TypesOpenFlags(value ? representation | 0x4 : representation & ~0x4);
  }

  bool get truncate => representation & 0x8 == 0x8;
  TypesOpenFlags withTruncate(bool value) {
    return TypesOpenFlags(value ? representation | 0x8 : representation & ~0x8);
  }
}

abstract interface class Types {
  (Stream<i0.Uint8List>, Future<i1.Result<void, TypesErrorCode>>)
  methodDescriptorReadViaStream({
    required i1.Borrowed<TypesDescriptor> self,
    required int offset,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorWriteViaStream({
    required i1.Borrowed<TypesDescriptor> self,
    required Stream<i0.Uint8List> data,
    required int offset,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorAppendViaStream({
    required i1.Borrowed<TypesDescriptor> self,
    required Stream<i0.Uint8List> data,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorAdvise({
    required i1.Borrowed<TypesDescriptor> self,
    required int offset,
    required int length,
    required TypesAdvice advice,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorSyncData({
    required i1.Borrowed<TypesDescriptor> self,
  });
  Future<i1.Result<TypesDescriptorFlags, TypesErrorCode>>
  methodDescriptorGetFlags({required i1.Borrowed<TypesDescriptor> self});
  Future<i1.Result<TypesDescriptorType, TypesErrorCode>>
  methodDescriptorGetType({required i1.Borrowed<TypesDescriptor> self});
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorSetSize({
    required i1.Borrowed<TypesDescriptor> self,
    required int size,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorSetTimes({
    required i1.Borrowed<TypesDescriptor> self,
    required TypesNewTimestamp dataAccessTimestamp,
    required TypesNewTimestamp dataModificationTimestamp,
  });
  (
    Stream<List<({TypesDescriptorType type, String name})>>,
    Future<i1.Result<void, TypesErrorCode>>,
  )
  methodDescriptorReadDirectory({required i1.Borrowed<TypesDescriptor> self});
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorSync({
    required i1.Borrowed<TypesDescriptor> self,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorCreateDirectoryAt({
    required i1.Borrowed<TypesDescriptor> self,
    required String path,
  });
  Future<
    i1.Result<
      ({
        TypesDescriptorType type,
        int linkCount,
        int size,
        i1.Option<({int seconds, int nanoseconds})> dataAccessTimestamp,
        i1.Option<({int seconds, int nanoseconds})> dataModificationTimestamp,
        i1.Option<({int seconds, int nanoseconds})> statusChangeTimestamp,
      }),
      TypesErrorCode
    >
  >
  methodDescriptorStat({required i1.Borrowed<TypesDescriptor> self});
  Future<
    i1.Result<
      ({
        TypesDescriptorType type,
        int linkCount,
        int size,
        i1.Option<({int seconds, int nanoseconds})> dataAccessTimestamp,
        i1.Option<({int seconds, int nanoseconds})> dataModificationTimestamp,
        i1.Option<({int seconds, int nanoseconds})> statusChangeTimestamp,
      }),
      TypesErrorCode
    >
  >
  methodDescriptorStatAt({
    required i1.Borrowed<TypesDescriptor> self,
    required TypesPathFlags pathFlags,
    required String path,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorSetTimesAt({
    required i1.Borrowed<TypesDescriptor> self,
    required TypesPathFlags pathFlags,
    required String path,
    required TypesNewTimestamp dataAccessTimestamp,
    required TypesNewTimestamp dataModificationTimestamp,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorLinkAt({
    required i1.Borrowed<TypesDescriptor> self,
    required TypesPathFlags oldPathFlags,
    required String oldPath,
    required i1.Borrowed<TypesDescriptor> newDescriptor,
    required String newPath,
  });
  Future<i1.Result<i1.Owned<TypesDescriptor>, TypesErrorCode>>
  methodDescriptorOpenAt({
    required i1.Borrowed<TypesDescriptor> self,
    required TypesPathFlags pathFlags,
    required String path,
    required TypesOpenFlags openFlags,
    required TypesDescriptorFlags flags,
  });
  Future<i1.Result<String, TypesErrorCode>> methodDescriptorReadlinkAt({
    required i1.Borrowed<TypesDescriptor> self,
    required String path,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorRemoveDirectoryAt({
    required i1.Borrowed<TypesDescriptor> self,
    required String path,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorRenameAt({
    required i1.Borrowed<TypesDescriptor> self,
    required String oldPath,
    required i1.Borrowed<TypesDescriptor> newDescriptor,
    required String newPath,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorSymlinkAt({
    required i1.Borrowed<TypesDescriptor> self,
    required String oldPath,
    required String newPath,
  });
  Future<i1.Result<void, TypesErrorCode>> methodDescriptorUnlinkFileAt({
    required i1.Borrowed<TypesDescriptor> self,
    required String path,
  });
  Future<bool> methodDescriptorIsSameObject({
    required i1.Borrowed<TypesDescriptor> self,
    required i1.Borrowed<TypesDescriptor> other,
  });
  Future<i1.Result<({int lower, int upper}), TypesErrorCode>>
  methodDescriptorMetadataHash({required i1.Borrowed<TypesDescriptor> self});
  Future<i1.Result<({int lower, int upper}), TypesErrorCode>>
  methodDescriptorMetadataHashAt({
    required i1.Borrowed<TypesDescriptor> self,
    required TypesPathFlags pathFlags,
    required String path,
  });
}

abstract interface class Preopens {
  List<(i1.Owned<TypesDescriptor>, String)> getDirectories();
}
