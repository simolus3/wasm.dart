// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

import r'dart:typed_data' as i1;

/// This following block defines the `fields` resource which corresponds to
/// HTTP standard Fields. Fields are a common representation used for both
/// Headers and Trailers.
///
/// A `fields` may be mutable or immutable. A `fields` created using the
/// constructor, `from-list`, or `clone` will be mutable, but a `fields`
/// resource given by other means (including, but not limited to,
/// `request.headers`) might be be immutable. In an immutable fields, the
/// `set`, `append`, and `delete` operations will fail with
/// `header-error.immutable`.
///
/// A `fields` resource should store `field-name`s and `field-value`s in their
/// original casing used to construct or mutate the `fields` resource. The `fields`
/// resource should use that original casing when serializing the fields for
/// transport or when returning them from a method.
///
/// Implementations may impose limits on individual field values and on total
/// aggregate field section size. Operations that would exceed these limits
/// fail with `header-error.size-exceeded`
final class TypesFields {}

/// This type enumerates the different kinds of errors that may occur when
/// setting or appending to a `fields` resource.
sealed class TypesHeaderError {
  const TypesHeaderError._();
  const factory TypesHeaderError.invalidSyntax() =
      TypesHeaderErrorInvalidSyntax;
  const factory TypesHeaderError.forbidden() = TypesHeaderErrorForbidden;
  const factory TypesHeaderError.immutable() = TypesHeaderErrorImmutable;
  const factory TypesHeaderError.sizeExceeded() = TypesHeaderErrorSizeExceeded;
  const factory TypesHeaderError.other(i0.Option<String> payload) =
      TypesHeaderErrorOther;
}

final class TypesHeaderErrorInvalidSyntax extends TypesHeaderError {
  const TypesHeaderErrorInvalidSyntax() : super._();
}

final class TypesHeaderErrorForbidden extends TypesHeaderError {
  const TypesHeaderErrorForbidden() : super._();
}

final class TypesHeaderErrorImmutable extends TypesHeaderError {
  const TypesHeaderErrorImmutable() : super._();
}

final class TypesHeaderErrorSizeExceeded extends TypesHeaderError {
  const TypesHeaderErrorSizeExceeded() : super._();
}

final class TypesHeaderErrorOther extends TypesHeaderError {
  final i0.Option<String> payload;
  const TypesHeaderErrorOther(this.payload) : super._();
}

/// Represents an HTTP Request.
final class TypesRequest {}

/// These cases are inspired by the IANA HTTP Proxy Error Types:
///   <https://www.iana.org/assignments/http-proxy-status/http-proxy-status.xhtml#table-http-proxy-error-types>
sealed class TypesErrorCode {
  const TypesErrorCode._();
  const factory TypesErrorCode.dnsTimeout() = TypesErrorCodeDnsTimeout;
  const factory TypesErrorCode.dnsError(
    ({i0.Option<String> rcode, i0.Option<int> infoCode}) payload,
  ) = TypesErrorCodeDnsError;
  const factory TypesErrorCode.destinationNotFound() =
      TypesErrorCodeDestinationNotFound;
  const factory TypesErrorCode.destinationUnavailable() =
      TypesErrorCodeDestinationUnavailable;
  const factory TypesErrorCode.destinationIpProhibited() =
      TypesErrorCodeDestinationIpProhibited;
  const factory TypesErrorCode.destinationIpUnroutable() =
      TypesErrorCodeDestinationIpUnroutable;
  const factory TypesErrorCode.connectionRefused() =
      TypesErrorCodeConnectionRefused;
  const factory TypesErrorCode.connectionTerminated() =
      TypesErrorCodeConnectionTerminated;
  const factory TypesErrorCode.connectionTimeout() =
      TypesErrorCodeConnectionTimeout;
  const factory TypesErrorCode.connectionReadTimeout() =
      TypesErrorCodeConnectionReadTimeout;
  const factory TypesErrorCode.connectionWriteTimeout() =
      TypesErrorCodeConnectionWriteTimeout;
  const factory TypesErrorCode.connectionLimitReached() =
      TypesErrorCodeConnectionLimitReached;
  const factory TypesErrorCode.tlsProtocolError() =
      TypesErrorCodeTlsProtocolError;
  const factory TypesErrorCode.tlsCertificateError() =
      TypesErrorCodeTlsCertificateError;
  const factory TypesErrorCode.tlsAlertReceived(
    ({i0.Option<int> alertId, i0.Option<String> alertMessage}) payload,
  ) = TypesErrorCodeTlsAlertReceived;
  const factory TypesErrorCode.httpRequestDenied() =
      TypesErrorCodeHttpRequestDenied;
  const factory TypesErrorCode.httpRequestLengthRequired() =
      TypesErrorCodeHttpRequestLengthRequired;
  const factory TypesErrorCode.httpRequestBodySize(i0.Option<int> payload) =
      TypesErrorCodeHttpRequestBodySize;
  const factory TypesErrorCode.httpRequestMethodInvalid() =
      TypesErrorCodeHttpRequestMethodInvalid;
  const factory TypesErrorCode.httpRequestUriInvalid() =
      TypesErrorCodeHttpRequestUriInvalid;
  const factory TypesErrorCode.httpRequestUriTooLong() =
      TypesErrorCodeHttpRequestUriTooLong;
  const factory TypesErrorCode.httpRequestHeaderSectionSize(
    i0.Option<int> payload,
  ) = TypesErrorCodeHttpRequestHeaderSectionSize;
  const factory TypesErrorCode.httpRequestHeaderSize(
    i0.Option<({i0.Option<String> fieldName, i0.Option<int> fieldSize})>
    payload,
  ) = TypesErrorCodeHttpRequestHeaderSize;
  const factory TypesErrorCode.httpRequestTrailerSectionSize(
    i0.Option<int> payload,
  ) = TypesErrorCodeHttpRequestTrailerSectionSize;
  const factory TypesErrorCode.httpRequestTrailerSize(
    ({i0.Option<String> fieldName, i0.Option<int> fieldSize}) payload,
  ) = TypesErrorCodeHttpRequestTrailerSize;
  const factory TypesErrorCode.httpResponseIncomplete() =
      TypesErrorCodeHttpResponseIncomplete;
  const factory TypesErrorCode.httpResponseHeaderSectionSize(
    i0.Option<int> payload,
  ) = TypesErrorCodeHttpResponseHeaderSectionSize;
  const factory TypesErrorCode.httpResponseHeaderSize(
    ({i0.Option<String> fieldName, i0.Option<int> fieldSize}) payload,
  ) = TypesErrorCodeHttpResponseHeaderSize;
  const factory TypesErrorCode.httpResponseBodySize(i0.Option<int> payload) =
      TypesErrorCodeHttpResponseBodySize;
  const factory TypesErrorCode.httpResponseTrailerSectionSize(
    i0.Option<int> payload,
  ) = TypesErrorCodeHttpResponseTrailerSectionSize;
  const factory TypesErrorCode.httpResponseTrailerSize(
    ({i0.Option<String> fieldName, i0.Option<int> fieldSize}) payload,
  ) = TypesErrorCodeHttpResponseTrailerSize;
  const factory TypesErrorCode.httpResponseTransferCoding(
    i0.Option<String> payload,
  ) = TypesErrorCodeHttpResponseTransferCoding;
  const factory TypesErrorCode.httpResponseContentCoding(
    i0.Option<String> payload,
  ) = TypesErrorCodeHttpResponseContentCoding;
  const factory TypesErrorCode.httpResponseTimeout() =
      TypesErrorCodeHttpResponseTimeout;
  const factory TypesErrorCode.httpUpgradeFailed() =
      TypesErrorCodeHttpUpgradeFailed;
  const factory TypesErrorCode.httpProtocolError() =
      TypesErrorCodeHttpProtocolError;
  const factory TypesErrorCode.loopDetected() = TypesErrorCodeLoopDetected;
  const factory TypesErrorCode.configurationError() =
      TypesErrorCodeConfigurationError;
  const factory TypesErrorCode.internalError(i0.Option<String> payload) =
      TypesErrorCodeInternalError;
}

final class TypesErrorCodeDnsTimeout extends TypesErrorCode {
  const TypesErrorCodeDnsTimeout() : super._();
}

final class TypesErrorCodeDnsError extends TypesErrorCode {
  final ({i0.Option<String> rcode, i0.Option<int> infoCode}) payload;
  const TypesErrorCodeDnsError(this.payload) : super._();
}

final class TypesErrorCodeDestinationNotFound extends TypesErrorCode {
  const TypesErrorCodeDestinationNotFound() : super._();
}

final class TypesErrorCodeDestinationUnavailable extends TypesErrorCode {
  const TypesErrorCodeDestinationUnavailable() : super._();
}

final class TypesErrorCodeDestinationIpProhibited extends TypesErrorCode {
  const TypesErrorCodeDestinationIpProhibited() : super._();
}

final class TypesErrorCodeDestinationIpUnroutable extends TypesErrorCode {
  const TypesErrorCodeDestinationIpUnroutable() : super._();
}

final class TypesErrorCodeConnectionRefused extends TypesErrorCode {
  const TypesErrorCodeConnectionRefused() : super._();
}

final class TypesErrorCodeConnectionTerminated extends TypesErrorCode {
  const TypesErrorCodeConnectionTerminated() : super._();
}

final class TypesErrorCodeConnectionTimeout extends TypesErrorCode {
  const TypesErrorCodeConnectionTimeout() : super._();
}

final class TypesErrorCodeConnectionReadTimeout extends TypesErrorCode {
  const TypesErrorCodeConnectionReadTimeout() : super._();
}

final class TypesErrorCodeConnectionWriteTimeout extends TypesErrorCode {
  const TypesErrorCodeConnectionWriteTimeout() : super._();
}

final class TypesErrorCodeConnectionLimitReached extends TypesErrorCode {
  const TypesErrorCodeConnectionLimitReached() : super._();
}

final class TypesErrorCodeTlsProtocolError extends TypesErrorCode {
  const TypesErrorCodeTlsProtocolError() : super._();
}

final class TypesErrorCodeTlsCertificateError extends TypesErrorCode {
  const TypesErrorCodeTlsCertificateError() : super._();
}

final class TypesErrorCodeTlsAlertReceived extends TypesErrorCode {
  final ({i0.Option<int> alertId, i0.Option<String> alertMessage}) payload;
  const TypesErrorCodeTlsAlertReceived(this.payload) : super._();
}

final class TypesErrorCodeHttpRequestDenied extends TypesErrorCode {
  const TypesErrorCodeHttpRequestDenied() : super._();
}

final class TypesErrorCodeHttpRequestLengthRequired extends TypesErrorCode {
  const TypesErrorCodeHttpRequestLengthRequired() : super._();
}

final class TypesErrorCodeHttpRequestBodySize extends TypesErrorCode {
  final i0.Option<int> payload;
  const TypesErrorCodeHttpRequestBodySize(this.payload) : super._();
}

final class TypesErrorCodeHttpRequestMethodInvalid extends TypesErrorCode {
  const TypesErrorCodeHttpRequestMethodInvalid() : super._();
}

final class TypesErrorCodeHttpRequestUriInvalid extends TypesErrorCode {
  const TypesErrorCodeHttpRequestUriInvalid() : super._();
}

final class TypesErrorCodeHttpRequestUriTooLong extends TypesErrorCode {
  const TypesErrorCodeHttpRequestUriTooLong() : super._();
}

final class TypesErrorCodeHttpRequestHeaderSectionSize extends TypesErrorCode {
  final i0.Option<int> payload;
  const TypesErrorCodeHttpRequestHeaderSectionSize(this.payload) : super._();
}

final class TypesErrorCodeHttpRequestHeaderSize extends TypesErrorCode {
  final i0.Option<({i0.Option<String> fieldName, i0.Option<int> fieldSize})>
  payload;
  const TypesErrorCodeHttpRequestHeaderSize(this.payload) : super._();
}

final class TypesErrorCodeHttpRequestTrailerSectionSize extends TypesErrorCode {
  final i0.Option<int> payload;
  const TypesErrorCodeHttpRequestTrailerSectionSize(this.payload) : super._();
}

final class TypesErrorCodeHttpRequestTrailerSize extends TypesErrorCode {
  final ({i0.Option<String> fieldName, i0.Option<int> fieldSize}) payload;
  const TypesErrorCodeHttpRequestTrailerSize(this.payload) : super._();
}

final class TypesErrorCodeHttpResponseIncomplete extends TypesErrorCode {
  const TypesErrorCodeHttpResponseIncomplete() : super._();
}

final class TypesErrorCodeHttpResponseHeaderSectionSize extends TypesErrorCode {
  final i0.Option<int> payload;
  const TypesErrorCodeHttpResponseHeaderSectionSize(this.payload) : super._();
}

final class TypesErrorCodeHttpResponseHeaderSize extends TypesErrorCode {
  final ({i0.Option<String> fieldName, i0.Option<int> fieldSize}) payload;
  const TypesErrorCodeHttpResponseHeaderSize(this.payload) : super._();
}

final class TypesErrorCodeHttpResponseBodySize extends TypesErrorCode {
  final i0.Option<int> payload;
  const TypesErrorCodeHttpResponseBodySize(this.payload) : super._();
}

final class TypesErrorCodeHttpResponseTrailerSectionSize
    extends TypesErrorCode {
  final i0.Option<int> payload;
  const TypesErrorCodeHttpResponseTrailerSectionSize(this.payload) : super._();
}

final class TypesErrorCodeHttpResponseTrailerSize extends TypesErrorCode {
  final ({i0.Option<String> fieldName, i0.Option<int> fieldSize}) payload;
  const TypesErrorCodeHttpResponseTrailerSize(this.payload) : super._();
}

final class TypesErrorCodeHttpResponseTransferCoding extends TypesErrorCode {
  final i0.Option<String> payload;
  const TypesErrorCodeHttpResponseTransferCoding(this.payload) : super._();
}

final class TypesErrorCodeHttpResponseContentCoding extends TypesErrorCode {
  final i0.Option<String> payload;
  const TypesErrorCodeHttpResponseContentCoding(this.payload) : super._();
}

final class TypesErrorCodeHttpResponseTimeout extends TypesErrorCode {
  const TypesErrorCodeHttpResponseTimeout() : super._();
}

final class TypesErrorCodeHttpUpgradeFailed extends TypesErrorCode {
  const TypesErrorCodeHttpUpgradeFailed() : super._();
}

final class TypesErrorCodeHttpProtocolError extends TypesErrorCode {
  const TypesErrorCodeHttpProtocolError() : super._();
}

final class TypesErrorCodeLoopDetected extends TypesErrorCode {
  const TypesErrorCodeLoopDetected() : super._();
}

final class TypesErrorCodeConfigurationError extends TypesErrorCode {
  const TypesErrorCodeConfigurationError() : super._();
}

final class TypesErrorCodeInternalError extends TypesErrorCode {
  final i0.Option<String> payload;
  const TypesErrorCodeInternalError(this.payload) : super._();
}

/// Parameters for making an HTTP Request. Each of these parameters is
/// currently an optional timeout applicable to the transport layer of the
/// HTTP protocol.
///
/// These timeouts are separate from any the user may use to bound an
/// asynchronous call.
final class TypesRequestOptions {}

/// This type corresponds to HTTP standard Methods.
sealed class TypesMethod {
  const TypesMethod._();
  const factory TypesMethod.get() = TypesMethodGet;
  const factory TypesMethod.head() = TypesMethodHead;
  const factory TypesMethod.post() = TypesMethodPost;
  const factory TypesMethod.put() = TypesMethodPut;
  const factory TypesMethod.delete() = TypesMethodDelete;
  const factory TypesMethod.connect() = TypesMethodConnect;
  const factory TypesMethod.options() = TypesMethodOptions;
  const factory TypesMethod.trace() = TypesMethodTrace;
  const factory TypesMethod.patch() = TypesMethodPatch;
  const factory TypesMethod.other(String payload) = TypesMethodOther;
}

final class TypesMethodGet extends TypesMethod {
  const TypesMethodGet() : super._();
}

final class TypesMethodHead extends TypesMethod {
  const TypesMethodHead() : super._();
}

final class TypesMethodPost extends TypesMethod {
  const TypesMethodPost() : super._();
}

final class TypesMethodPut extends TypesMethod {
  const TypesMethodPut() : super._();
}

final class TypesMethodDelete extends TypesMethod {
  const TypesMethodDelete() : super._();
}

final class TypesMethodConnect extends TypesMethod {
  const TypesMethodConnect() : super._();
}

final class TypesMethodOptions extends TypesMethod {
  const TypesMethodOptions() : super._();
}

final class TypesMethodTrace extends TypesMethod {
  const TypesMethodTrace() : super._();
}

final class TypesMethodPatch extends TypesMethod {
  const TypesMethodPatch() : super._();
}

final class TypesMethodOther extends TypesMethod {
  final String payload;
  const TypesMethodOther(this.payload) : super._();
}

/// This type corresponds to HTTP standard Related Schemes.
sealed class TypesScheme {
  const TypesScheme._();
  const factory TypesScheme.http() = TypesSchemeHttp;
  const factory TypesScheme.https() = TypesSchemeHttps;
  const factory TypesScheme.other(String payload) = TypesSchemeOther;
}

final class TypesSchemeHttp extends TypesScheme {
  const TypesSchemeHttp() : super._();
}

final class TypesSchemeHttps extends TypesScheme {
  const TypesSchemeHttps() : super._();
}

final class TypesSchemeOther extends TypesScheme {
  final String payload;
  const TypesSchemeOther(this.payload) : super._();
}

/// This type enumerates the different kinds of errors that may occur when
/// setting fields of a `request-options` resource.
sealed class TypesRequestOptionsError {
  const TypesRequestOptionsError._();
  const factory TypesRequestOptionsError.notSupported() =
      TypesRequestOptionsErrorNotSupported;
  const factory TypesRequestOptionsError.immutable() =
      TypesRequestOptionsErrorImmutable;
  const factory TypesRequestOptionsError.other(i0.Option<String> payload) =
      TypesRequestOptionsErrorOther;
}

final class TypesRequestOptionsErrorNotSupported
    extends TypesRequestOptionsError {
  const TypesRequestOptionsErrorNotSupported() : super._();
}

final class TypesRequestOptionsErrorImmutable extends TypesRequestOptionsError {
  const TypesRequestOptionsErrorImmutable() : super._();
}

final class TypesRequestOptionsErrorOther extends TypesRequestOptionsError {
  final i0.Option<String> payload;
  const TypesRequestOptionsErrorOther(this.payload) : super._();
}

/// Represents an HTTP Response.
final class TypesResponse {}

/// This interface defines all of the types and methods for implementing HTTP
/// Requests and Responses, as well as their headers, trailers, and bodies.
abstract interface class Types {
  /// Construct an empty HTTP Fields.
  ///
  /// The resulting `fields` is mutable.
  i0.Owned<TypesFields> constructorFields();

  /// Construct an HTTP Fields.
  ///
  /// The resulting `fields` is mutable.
  ///
  /// The list represents each name-value pair in the Fields. Names
  /// which have multiple values are represented by multiple entries in this
  /// list with the same name.
  ///
  /// The tuple is a pair of the field name, represented as a string, and
  /// Value, represented as a list of bytes. In a valid Fields, all names
  /// and values are valid UTF-8 strings. However, values are not always
  /// well-formed, so they are represented as a raw list of bytes.
  ///
  /// An error result will be returned if any header or value was
  /// syntactically invalid, if a header was forbidden, or if the
  /// entries would exceed an implementation size limit.
  i0.Result<i0.Owned<TypesFields>, TypesHeaderError> staticFieldsFromList({
    required List<(String, List<int>)> entries,
  });

  /// Get all of the values corresponding to a name. If the name is not present
  /// in this `fields`, an empty list is returned. However, if the name is
  /// present but empty, this is represented by a list with one or more
  /// empty field-values present.
  List<List<int>> methodFieldsGet({
    required i0.Borrowed<TypesFields> self,
    required String name,
  });

  /// Returns `true` when the name is present in this `fields`. If the name is
  /// syntactically invalid, `false` is returned.
  bool methodFieldsHas({
    required i0.Borrowed<TypesFields> self,
    required String name,
  });

  /// Set all of the values for a name. Clears any existing values for that
  /// name, if they have been set.
  ///
  /// Fails with `header-error.immutable` if the `fields` are immutable.
  ///
  /// Fails with `header-error.size-exceeded` if the name or values would
  /// exceed an implementation-defined size limit.
  i0.Result<void, TypesHeaderError> methodFieldsSet({
    required i0.Borrowed<TypesFields> self,
    required String name,
    required List<List<int>> value,
  });

  /// Delete all values for a name. Does nothing if no values for the name
  /// exist.
  ///
  /// Fails with `header-error.immutable` if the `fields` are immutable.
  i0.Result<void, TypesHeaderError> methodFieldsDelete({
    required i0.Borrowed<TypesFields> self,
    required String name,
  });

  /// Delete all values for a name. Does nothing if no values for the name
  /// exist.
  ///
  /// Returns all values previously corresponding to the name, if any.
  ///
  /// Fails with `header-error.immutable` if the `fields` are immutable.
  i0.Result<List<List<int>>, TypesHeaderError> methodFieldsGetAndDelete({
    required i0.Borrowed<TypesFields> self,
    required String name,
  });

  /// Append a value for a name. Does not change or delete any existing
  /// values for that name.
  ///
  /// Fails with `header-error.immutable` if the `fields` are immutable.
  ///
  /// Fails with `header-error.size-exceeded` if the value would exceed
  /// an implementation-defined size limit.
  i0.Result<void, TypesHeaderError> methodFieldsAppend({
    required i0.Borrowed<TypesFields> self,
    required String name,
    required List<int> value,
  });

  /// Retrieve the full set of names and values in the Fields. Like the
  /// constructor, the list represents each name-value pair.
  ///
  /// The outer list represents each name-value pair in the Fields. Names
  /// which have multiple values are represented by multiple entries in this
  /// list with the same name.
  ///
  /// The names and values are always returned in the original casing and in
  /// the order in which they will be serialized for transport.
  List<(String, List<int>)> methodFieldsCopyAll({
    required i0.Borrowed<TypesFields> self,
  });

  /// Make a deep copy of the Fields. Equivalent in behavior to calling the
  /// `fields` constructor on the return value of `copy-all`. The resulting
  /// `fields` is mutable.
  i0.Owned<TypesFields> methodFieldsClone({
    required i0.Borrowed<TypesFields> self,
  });

  /// Construct a new `request` with a default `method` of `GET`, and
  /// `none` values for `path-with-query`, `scheme`, and `authority`.
  ///
  /// `headers` is the HTTP Headers for the Request.
  ///
  /// `contents` is the optional body content stream with `none`
  /// representing a zero-length content stream.
  /// Once it is closed, `trailers` future must resolve to a result.
  /// If `trailers` resolves to an error, underlying connection
  /// will be closed immediately.
  ///
  /// `options` is optional `request-options` resource to be used
  /// if the request is sent over a network connection.
  ///
  /// It is possible to construct, or manipulate with the accessor functions
  /// below, a `request` with an invalid combination of `scheme`
  /// and `authority`, or `headers` which are not permitted to be sent.
  /// It is the obligation of the `handler.handle` implementation
  /// to reject invalid constructions of `request`.
  ///
  /// The returned future resolves to result of transmission of this request.
  (i0.Owned<TypesRequest>, Future<i0.Result<void, TypesErrorCode>>)
  staticRequestNew({
    required i0.Owned<TypesFields> headers,
    required i0.Option<Stream<i1.Uint8List>> contents,
    required Future<i0.Result<i0.Option<i0.Owned<TypesFields>>, TypesErrorCode>>
    trailers,
    required i0.Option<i0.Owned<TypesRequestOptions>> options,
  });

  /// Get the Method for the Request.
  TypesMethod methodRequestGetMethod({required i0.Borrowed<TypesRequest> self});

  /// Set the Method for the Request. Fails if the string present in a
  /// `method.other` argument is not a syntactically valid method.
  i0.Result<void, void> methodRequestSetMethod({
    required i0.Borrowed<TypesRequest> self,
    required TypesMethod method,
  });

  /// Get the combination of the HTTP Path and Query for the Request.  When
  /// `none`, this represents an empty Path and empty Query.
  i0.Option<String> methodRequestGetPathWithQuery({
    required i0.Borrowed<TypesRequest> self,
  });

  /// Set the combination of the HTTP Path and Query for the Request.  When
  /// `none`, this represents an empty Path and empty Query. Fails is the
  /// string given is not a syntactically valid path and query uri component.
  i0.Result<void, void> methodRequestSetPathWithQuery({
    required i0.Borrowed<TypesRequest> self,
    required i0.Option<String> pathWithQuery,
  });

  /// Get the HTTP Related Scheme for the Request. When `none`, the
  /// implementation may choose an appropriate default scheme.
  i0.Option<TypesScheme> methodRequestGetScheme({
    required i0.Borrowed<TypesRequest> self,
  });

  /// Set the HTTP Related Scheme for the Request. When `none`, the
  /// implementation may choose an appropriate default scheme. Fails if the
  /// string given is not a syntactically valid uri scheme.
  i0.Result<void, void> methodRequestSetScheme({
    required i0.Borrowed<TypesRequest> self,
    required i0.Option<TypesScheme> scheme,
  });

  /// Get the authority of the Request's target URI. A value of `none` may be used
  /// with Related Schemes which do not require an authority. The HTTP and
  /// HTTPS schemes always require an authority.
  i0.Option<String> methodRequestGetAuthority({
    required i0.Borrowed<TypesRequest> self,
  });

  /// Set the authority of the Request's target URI. A value of `none` may be used
  /// with Related Schemes which do not require an authority. The HTTP and
  /// HTTPS schemes always require an authority. Fails if the string given is
  /// not a syntactically valid URI authority.
  i0.Result<void, void> methodRequestSetAuthority({
    required i0.Borrowed<TypesRequest> self,
    required i0.Option<String> authority,
  });

  /// Get the `request-options` to be associated with this request
  ///
  /// The returned `request-options` resource is immutable: `set-*` operations
  /// will fail if invoked.
  ///
  /// This `request-options` resource is a child: it must be dropped before
  /// the parent `request` is dropped, or its ownership is transferred to
  /// another component by e.g. `handler.handle`.
  i0.Option<i0.Owned<TypesRequestOptions>> methodRequestGetOptions({
    required i0.Borrowed<TypesRequest> self,
  });

  /// Get the headers associated with the Request.
  ///
  /// The returned `headers` resource is immutable: `set`, `append`, and
  /// `delete` operations will fail with `header-error.immutable`.
  i0.Owned<TypesFields> methodRequestGetHeaders({
    required i0.Borrowed<TypesRequest> self,
  });

  /// Get body of the Request.
  ///
  /// Stream returned by this method represents the contents of the body.
  /// Once the stream is reported as closed, callers should await the returned
  /// future to determine whether the body was received successfully.
  /// The future will only resolve after the stream is reported as closed.
  ///
  /// This function takes a `res` future as a parameter, which can be used to
  /// communicate an error in handling of the request.
  ///
  /// Note that function will move the `request`, but references to headers or
  /// request options acquired from it previously will remain valid.
  (
    Stream<i1.Uint8List>,
    Future<i0.Result<i0.Option<i0.Owned<TypesFields>>, TypesErrorCode>>,
  )
  staticRequestConsumeBody({
    required i0.Owned<TypesRequest> $this,
    required Future<i0.Result<void, TypesErrorCode>> res,
  });

  /// Construct a default `request-options` value.
  i0.Owned<TypesRequestOptions> constructorRequestOptions();

  /// The timeout for the initial connect to the HTTP Server.
  i0.Option<int> methodRequestOptionsGetConnectTimeout({
    required i0.Borrowed<TypesRequestOptions> self,
  });

  /// Set the timeout for the initial connect to the HTTP Server. An error
  /// return value indicates that this timeout is not supported or that this
  /// handle is immutable.
  i0.Result<void, TypesRequestOptionsError>
  methodRequestOptionsSetConnectTimeout({
    required i0.Borrowed<TypesRequestOptions> self,
    required i0.Option<int> duration,
  });

  /// The timeout for receiving the first byte of the Response body.
  i0.Option<int> methodRequestOptionsGetFirstByteTimeout({
    required i0.Borrowed<TypesRequestOptions> self,
  });

  /// Set the timeout for receiving the first byte of the Response body. An
  /// error return value indicates that this timeout is not supported or that
  /// this handle is immutable.
  i0.Result<void, TypesRequestOptionsError>
  methodRequestOptionsSetFirstByteTimeout({
    required i0.Borrowed<TypesRequestOptions> self,
    required i0.Option<int> duration,
  });

  /// The timeout for receiving subsequent chunks of bytes in the Response
  /// body stream.
  i0.Option<int> methodRequestOptionsGetBetweenBytesTimeout({
    required i0.Borrowed<TypesRequestOptions> self,
  });

  /// Set the timeout for receiving subsequent chunks of bytes in the Response
  /// body stream. An error return value indicates that this timeout is not
  /// supported or that this handle is immutable.
  i0.Result<void, TypesRequestOptionsError>
  methodRequestOptionsSetBetweenBytesTimeout({
    required i0.Borrowed<TypesRequestOptions> self,
    required i0.Option<int> duration,
  });

  /// Make a deep copy of the `request-options`.
  /// The resulting `request-options` is mutable.
  i0.Owned<TypesRequestOptions> methodRequestOptionsClone({
    required i0.Borrowed<TypesRequestOptions> self,
  });

  /// Construct a new `response`, with a default `status-code` of `200`.
  /// If a different `status-code` is needed, it must be set via the
  /// `set-status-code` method.
  ///
  /// `headers` is the HTTP Headers for the Response.
  ///
  /// `contents` is the optional body content stream with `none`
  /// representing a zero-length content stream.
  /// Once it is closed, `trailers` future must resolve to a result.
  /// If `trailers` resolves to an error, underlying connection
  /// will be closed immediately.
  ///
  /// The returned future resolves to result of transmission of this response.
  (i0.Owned<TypesResponse>, Future<i0.Result<void, TypesErrorCode>>)
  staticResponseNew({
    required i0.Owned<TypesFields> headers,
    required i0.Option<Stream<i1.Uint8List>> contents,
    required Future<i0.Result<i0.Option<i0.Owned<TypesFields>>, TypesErrorCode>>
    trailers,
  });

  /// Get the HTTP Status Code for the Response.
  int methodResponseGetStatusCode({required i0.Borrowed<TypesResponse> self});

  /// Set the HTTP Status Code for the Response. Fails if the status-code
  /// given is not a valid http status code.
  i0.Result<void, void> methodResponseSetStatusCode({
    required i0.Borrowed<TypesResponse> self,
    required int statusCode,
  });

  /// Get the headers associated with the Response.
  ///
  /// The returned `headers` resource is immutable: `set`, `append`, and
  /// `delete` operations will fail with `header-error.immutable`.
  i0.Owned<TypesFields> methodResponseGetHeaders({
    required i0.Borrowed<TypesResponse> self,
  });

  /// Get body of the Response.
  ///
  /// Stream returned by this method represents the contents of the body.
  /// Once the stream is reported as closed, callers should await the returned
  /// future to determine whether the body was received successfully.
  /// The future will only resolve after the stream is reported as closed.
  ///
  /// This function takes a `res` future as a parameter, which can be used to
  /// communicate an error in handling of the response.
  ///
  /// Note that function will move the `response`, but references to headers
  /// acquired from it previously will remain valid.
  (
    Stream<i1.Uint8List>,
    Future<i0.Result<i0.Option<i0.Owned<TypesFields>>, TypesErrorCode>>,
  )
  staticResponseConsumeBody({
    required i0.Owned<TypesResponse> $this,
    required Future<i0.Result<void, TypesErrorCode>> res,
  });
}

/// This interface defines a handler of HTTP Requests.
///
/// In a `wasi:http/service` this interface is exported to respond to an
/// incoming HTTP Request with a Response.
///
/// In `wasi:http/middleware` this interface is both exported and imported as
/// the "downstream" and "upstream" directions of the middleware chain.
abstract interface class Handler {
  /// This function may be called with either an incoming request read from the
  /// network or a request synthesized or forwarded by another component.
  Future<i0.Result<i0.Owned<TypesResponse>, TypesErrorCode>> handle({
    required i0.Owned<TypesRequest> request,
  });
}

/// This interface defines an HTTP client for sending "outgoing" requests.
///
/// Most components are expected to import this interface to provide the
/// capability to send HTTP requests to arbitrary destinations on a network.
///
/// The type signature of `client.send` is the same as `handler.handle`. This
/// duplication is currently necessary because some Component Model tooling
/// (including WIT itself) is unable to represent a component importing two
/// instances of the same interface. A `client.send` import may be linked
/// directly to a `handler.handle` export to bypass the network.
abstract interface class Client {
  /// This function may be used to either send an outgoing request over the
  /// network or to forward it to another component.
  Future<i0.Result<i0.Owned<TypesResponse>, TypesErrorCode>> send({
    required i0.Owned<TypesRequest> request,
  });
}
