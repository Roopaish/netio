import 'dart:io';

class Response<T> {
  int? statusCode;
  T? data;
  HttpHeaders? headers;

  Response({
    this.statusCode,
    this.data,
    this.headers,
  });
}
