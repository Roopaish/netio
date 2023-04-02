import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'response.dart';

typedef ProgressCallback = void Function(int received, int total);

class Netio {
  static Future<Response<T>> get<T>(
    String path, {
    HttpHeaders? headers,
    Object? data,
    ProgressCallback? onReceiveProgress,
  }) async {
    var url = Uri.parse(path);
    var httpClient = HttpClient();

    var request = await httpClient.getUrl(url);
    var response = await request.close();

    var responseBody = await response.transform(utf8.decoder).join();

    return Response<T>(
      statusCode: response.statusCode,
      data: responseBody as T,
      headers: response.headers,
    );
  }

  static Future<Response<T>> post<T>(
    String path, {
    HttpHeaders? headers,
    Object? data,
    ProgressCallback? onReceiveProgress,
  }) async {
    var url = Uri.parse(path);
    var httpClient = HttpClient();
    var request = await httpClient.postUrl(url);
    StreamSubscription? subscription;

    if (headers != null) {
      headers.forEach((key, value) => request.headers.set(key, value));
    }

    if (data != null) {
      request.write(json.encode(data));
    }

    var response = await request.close();

    if (onReceiveProgress != null) {
      var total = response.contentLength;
      var received = 0;
      subscription = response.listen((data) {
        received += data.length;
        onReceiveProgress(received, total);
      });
    }

    var responseBody = await response.transform(utf8.decoder).join();

    subscription?.cancel();

    return Response<T>(
      statusCode: response.statusCode,
      data: responseBody as T,
      headers: response.headers,
    );
  }
}
