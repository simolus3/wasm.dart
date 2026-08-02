// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

import r'dart:typed_data' as i1;

final class TypesTcpSocket {}

sealed class TypesErrorCode {
  const TypesErrorCode._();
  const factory TypesErrorCode.accessDenied() = TypesErrorCodeAccessDenied;
  const factory TypesErrorCode.notSupported() = TypesErrorCodeNotSupported;
  const factory TypesErrorCode.invalidArgument() =
      TypesErrorCodeInvalidArgument;
  const factory TypesErrorCode.outOfMemory() = TypesErrorCodeOutOfMemory;
  const factory TypesErrorCode.timeout() = TypesErrorCodeTimeout;
  const factory TypesErrorCode.invalidState() = TypesErrorCodeInvalidState;
  const factory TypesErrorCode.addressNotBindable() =
      TypesErrorCodeAddressNotBindable;
  const factory TypesErrorCode.addressInUse() = TypesErrorCodeAddressInUse;
  const factory TypesErrorCode.remoteUnreachable() =
      TypesErrorCodeRemoteUnreachable;
  const factory TypesErrorCode.connectionRefused() =
      TypesErrorCodeConnectionRefused;
  const factory TypesErrorCode.connectionBroken() =
      TypesErrorCodeConnectionBroken;
  const factory TypesErrorCode.connectionReset() =
      TypesErrorCodeConnectionReset;
  const factory TypesErrorCode.connectionAborted() =
      TypesErrorCodeConnectionAborted;
  const factory TypesErrorCode.datagramTooLarge() =
      TypesErrorCodeDatagramTooLarge;
  const factory TypesErrorCode.other(i0.Option<String> payload) =
      TypesErrorCodeOther;
}

final class TypesErrorCodeAccessDenied extends TypesErrorCode {
  const TypesErrorCodeAccessDenied() : super._();
}

final class TypesErrorCodeNotSupported extends TypesErrorCode {
  const TypesErrorCodeNotSupported() : super._();
}

final class TypesErrorCodeInvalidArgument extends TypesErrorCode {
  const TypesErrorCodeInvalidArgument() : super._();
}

final class TypesErrorCodeOutOfMemory extends TypesErrorCode {
  const TypesErrorCodeOutOfMemory() : super._();
}

final class TypesErrorCodeTimeout extends TypesErrorCode {
  const TypesErrorCodeTimeout() : super._();
}

final class TypesErrorCodeInvalidState extends TypesErrorCode {
  const TypesErrorCodeInvalidState() : super._();
}

final class TypesErrorCodeAddressNotBindable extends TypesErrorCode {
  const TypesErrorCodeAddressNotBindable() : super._();
}

final class TypesErrorCodeAddressInUse extends TypesErrorCode {
  const TypesErrorCodeAddressInUse() : super._();
}

final class TypesErrorCodeRemoteUnreachable extends TypesErrorCode {
  const TypesErrorCodeRemoteUnreachable() : super._();
}

final class TypesErrorCodeConnectionRefused extends TypesErrorCode {
  const TypesErrorCodeConnectionRefused() : super._();
}

final class TypesErrorCodeConnectionBroken extends TypesErrorCode {
  const TypesErrorCodeConnectionBroken() : super._();
}

final class TypesErrorCodeConnectionReset extends TypesErrorCode {
  const TypesErrorCodeConnectionReset() : super._();
}

final class TypesErrorCodeConnectionAborted extends TypesErrorCode {
  const TypesErrorCodeConnectionAborted() : super._();
}

final class TypesErrorCodeDatagramTooLarge extends TypesErrorCode {
  const TypesErrorCodeDatagramTooLarge() : super._();
}

final class TypesErrorCodeOther extends TypesErrorCode {
  final i0.Option<String> payload;
  const TypesErrorCodeOther(this.payload) : super._();
}

enum TypesIpAddressFamily { ipv4, ipv6 }

sealed class TypesIpSocketAddress {
  const TypesIpSocketAddress._();
  const factory TypesIpSocketAddress.ipv4(
    ({int port, (int, int, int, int) address}) payload,
  ) = TypesIpSocketAddressIpv4;
  const factory TypesIpSocketAddress.ipv6(
    ({
      int port,
      int flowInfo,
      (int, int, int, int, int, int, int, int) address,
      int scopeId,
    })
    payload,
  ) = TypesIpSocketAddressIpv6;
}

final class TypesIpSocketAddressIpv4 extends TypesIpSocketAddress {
  final ({int port, (int, int, int, int) address}) payload;
  const TypesIpSocketAddressIpv4(this.payload) : super._();
}

final class TypesIpSocketAddressIpv6 extends TypesIpSocketAddress {
  final ({
    int port,
    int flowInfo,
    (int, int, int, int, int, int, int, int) address,
    int scopeId,
  })
  payload;
  const TypesIpSocketAddressIpv6(this.payload) : super._();
}

final class TypesUdpSocket {}

abstract interface class Types {
  i0.Result<i0.Owned<TypesTcpSocket>, TypesErrorCode> staticTcpSocketCreate({
    required TypesIpAddressFamily addressFamily,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketBind({
    required i0.Borrowed<TypesTcpSocket> self,
    required TypesIpSocketAddress localAddress,
  });
  Future<i0.Result<void, TypesErrorCode>> methodTcpSocketConnect({
    required i0.Borrowed<TypesTcpSocket> self,
    required TypesIpSocketAddress remoteAddress,
  });
  i0.Result<Stream<List<i0.Owned<TypesTcpSocket>>>, TypesErrorCode>
  methodTcpSocketListen({required i0.Borrowed<TypesTcpSocket> self});
  Future<i0.Result<void, TypesErrorCode>> methodTcpSocketSend({
    required i0.Borrowed<TypesTcpSocket> self,
    required Stream<i1.Uint8List> data,
  });
  (Stream<i1.Uint8List>, Future<i0.Result<void, TypesErrorCode>>)
  methodTcpSocketReceive({required i0.Borrowed<TypesTcpSocket> self});
  i0.Result<TypesIpSocketAddress, TypesErrorCode>
  methodTcpSocketGetLocalAddress({required i0.Borrowed<TypesTcpSocket> self});
  i0.Result<TypesIpSocketAddress, TypesErrorCode>
  methodTcpSocketGetRemoteAddress({required i0.Borrowed<TypesTcpSocket> self});
  bool methodTcpSocketGetIsListening({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  TypesIpAddressFamily methodTcpSocketGetAddressFamily({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketSetListenBacklogSize({
    required i0.Borrowed<TypesTcpSocket> self,
    required int value,
  });
  i0.Result<bool, TypesErrorCode> methodTcpSocketGetKeepAliveEnabled({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketSetKeepAliveEnabled({
    required i0.Borrowed<TypesTcpSocket> self,
    required bool value,
  });
  i0.Result<int, TypesErrorCode> methodTcpSocketGetKeepAliveIdleTime({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketSetKeepAliveIdleTime({
    required i0.Borrowed<TypesTcpSocket> self,
    required int value,
  });
  i0.Result<int, TypesErrorCode> methodTcpSocketGetKeepAliveInterval({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketSetKeepAliveInterval({
    required i0.Borrowed<TypesTcpSocket> self,
    required int value,
  });
  i0.Result<int, TypesErrorCode> methodTcpSocketGetKeepAliveCount({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketSetKeepAliveCount({
    required i0.Borrowed<TypesTcpSocket> self,
    required int value,
  });
  i0.Result<int, TypesErrorCode> methodTcpSocketGetHopLimit({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketSetHopLimit({
    required i0.Borrowed<TypesTcpSocket> self,
    required int value,
  });
  i0.Result<int, TypesErrorCode> methodTcpSocketGetReceiveBufferSize({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketSetReceiveBufferSize({
    required i0.Borrowed<TypesTcpSocket> self,
    required int value,
  });
  i0.Result<int, TypesErrorCode> methodTcpSocketGetSendBufferSize({
    required i0.Borrowed<TypesTcpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodTcpSocketSetSendBufferSize({
    required i0.Borrowed<TypesTcpSocket> self,
    required int value,
  });
  i0.Result<i0.Owned<TypesUdpSocket>, TypesErrorCode> staticUdpSocketCreate({
    required TypesIpAddressFamily addressFamily,
  });
  i0.Result<void, TypesErrorCode> methodUdpSocketBind({
    required i0.Borrowed<TypesUdpSocket> self,
    required TypesIpSocketAddress localAddress,
  });
  i0.Result<void, TypesErrorCode> methodUdpSocketConnect({
    required i0.Borrowed<TypesUdpSocket> self,
    required TypesIpSocketAddress remoteAddress,
  });
  i0.Result<void, TypesErrorCode> methodUdpSocketDisconnect({
    required i0.Borrowed<TypesUdpSocket> self,
  });
  Future<i0.Result<void, TypesErrorCode>> methodUdpSocketSend({
    required i0.Borrowed<TypesUdpSocket> self,
    required List<int> data,
    required i0.Option<TypesIpSocketAddress> remoteAddress,
  });
  Future<i0.Result<(List<int>, TypesIpSocketAddress), TypesErrorCode>>
  methodUdpSocketReceive({required i0.Borrowed<TypesUdpSocket> self});
  i0.Result<TypesIpSocketAddress, TypesErrorCode>
  methodUdpSocketGetLocalAddress({required i0.Borrowed<TypesUdpSocket> self});
  i0.Result<TypesIpSocketAddress, TypesErrorCode>
  methodUdpSocketGetRemoteAddress({required i0.Borrowed<TypesUdpSocket> self});
  TypesIpAddressFamily methodUdpSocketGetAddressFamily({
    required i0.Borrowed<TypesUdpSocket> self,
  });
  i0.Result<int, TypesErrorCode> methodUdpSocketGetUnicastHopLimit({
    required i0.Borrowed<TypesUdpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodUdpSocketSetUnicastHopLimit({
    required i0.Borrowed<TypesUdpSocket> self,
    required int value,
  });
  i0.Result<int, TypesErrorCode> methodUdpSocketGetReceiveBufferSize({
    required i0.Borrowed<TypesUdpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodUdpSocketSetReceiveBufferSize({
    required i0.Borrowed<TypesUdpSocket> self,
    required int value,
  });
  i0.Result<int, TypesErrorCode> methodUdpSocketGetSendBufferSize({
    required i0.Borrowed<TypesUdpSocket> self,
  });
  i0.Result<void, TypesErrorCode> methodUdpSocketSetSendBufferSize({
    required i0.Borrowed<TypesUdpSocket> self,
    required int value,
  });
}

sealed class TypesIpAddress {
  const TypesIpAddress._();
  const factory TypesIpAddress.ipv4((int, int, int, int) payload) =
      TypesIpAddressIpv4;
  const factory TypesIpAddress.ipv6(
    (int, int, int, int, int, int, int, int) payload,
  ) = TypesIpAddressIpv6;
}

final class TypesIpAddressIpv4 extends TypesIpAddress {
  final (int, int, int, int) payload;
  const TypesIpAddressIpv4(this.payload) : super._();
}

final class TypesIpAddressIpv6 extends TypesIpAddress {
  final (int, int, int, int, int, int, int, int) payload;
  const TypesIpAddressIpv6(this.payload) : super._();
}

sealed class IpNameLookupErrorCode {
  const IpNameLookupErrorCode._();
  const factory IpNameLookupErrorCode.accessDenied() =
      IpNameLookupErrorCodeAccessDenied;
  const factory IpNameLookupErrorCode.invalidArgument() =
      IpNameLookupErrorCodeInvalidArgument;
  const factory IpNameLookupErrorCode.nameUnresolvable() =
      IpNameLookupErrorCodeNameUnresolvable;
  const factory IpNameLookupErrorCode.temporaryResolverFailure() =
      IpNameLookupErrorCodeTemporaryResolverFailure;
  const factory IpNameLookupErrorCode.permanentResolverFailure() =
      IpNameLookupErrorCodePermanentResolverFailure;
  const factory IpNameLookupErrorCode.other(i0.Option<String> payload) =
      IpNameLookupErrorCodeOther;
}

final class IpNameLookupErrorCodeAccessDenied extends IpNameLookupErrorCode {
  const IpNameLookupErrorCodeAccessDenied() : super._();
}

final class IpNameLookupErrorCodeInvalidArgument extends IpNameLookupErrorCode {
  const IpNameLookupErrorCodeInvalidArgument() : super._();
}

final class IpNameLookupErrorCodeNameUnresolvable
    extends IpNameLookupErrorCode {
  const IpNameLookupErrorCodeNameUnresolvable() : super._();
}

final class IpNameLookupErrorCodeTemporaryResolverFailure
    extends IpNameLookupErrorCode {
  const IpNameLookupErrorCodeTemporaryResolverFailure() : super._();
}

final class IpNameLookupErrorCodePermanentResolverFailure
    extends IpNameLookupErrorCode {
  const IpNameLookupErrorCodePermanentResolverFailure() : super._();
}

final class IpNameLookupErrorCodeOther extends IpNameLookupErrorCode {
  final i0.Option<String> payload;
  const IpNameLookupErrorCodeOther(this.payload) : super._();
}

abstract interface class IpNameLookup {
  Future<i0.Result<List<TypesIpAddress>, IpNameLookupErrorCode>>
  resolveAddresses({required String name});
}
