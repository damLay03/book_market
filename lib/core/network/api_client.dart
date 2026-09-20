import 'package:book_market/core/error/app_exception.dart';
import 'package:dio/dio.dart';

typedef JsonDecoder<T> = T Function(Object? data);

class ApiClient {
  const new(this._dio);

  final Dio _dio;

  Future<T> get<T>(
    String path, {
    required JsonDecoder<T> decode,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _request(
    path,
    method: 'GET',
    decode: decode,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
  );

  Future<T> post<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? data,
    CancelToken? cancelToken,
  }) => _request(
    path,
    method: 'POST',
    decode: decode,
    data: data,
    cancelToken: cancelToken,
  );

  Future<T> put<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? data,
    CancelToken? cancelToken,
  }) => _request(
    path,
    method: 'PUT',
    decode: decode,
    data: data,
    cancelToken: cancelToken,
  );

  Future<T> patch<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? data,
    CancelToken? cancelToken,
  }) => _request(
    path,
    method: 'PATCH',
    decode: decode,
    data: data,
    cancelToken: cancelToken,
  );

  Future<T> delete<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? data,
    CancelToken? cancelToken,
  }) => _request(
    path,
    method: 'DELETE',
    decode: decode,
    data: data,
    cancelToken: cancelToken,
  );

  Future<T> _request<T>(
    String path, {
    required String method,
    required JsonDecoder<T> decode,
    Map<String, dynamic>? queryParameters,
    Object? data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.request<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(method: method),
      );
      return decode(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw DataParsingException(
        'The server returned invalid data.',
        cause: error,
      );
    } on AppException {
      rethrow;
    } on Object catch (error) {
      throw UnknownException('Unexpected API error.', cause: error);
    }
  }

  AppException _mapDioException(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      return const RequestCancelledException();
    }

    final statusCode = error.response?.statusCode;
    final message = _readMessage(error.response?.data) ?? error.message;
    return switch (statusCode) {
      400 || 422 => ValidationException(
        message ?? 'The submitted data is invalid.',
        cause: error,
      ),
      401 => const UnauthorizedException(),
      403 => const ForbiddenException(),
      404 => const NotFoundException(),
      final int code when code >= 500 => ServerException(
        message ?? 'The server is temporarily unavailable.',
        cause: error,
        statusCode: statusCode,
      ),
      _ => NetworkException(
        message ?? 'Unable to connect to the server.',
        cause: error,
        statusCode: statusCode,
      ),
    };
  }

  String? _readMessage(Object? data) {
    if (data case {'message': final String message}) return message;
    return null;
  }
}
