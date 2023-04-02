import 'package:flutter_test/flutter_test.dart';
import 'package:netio/netio.dart';

void main() {
  group('Netio', () {
    test('get should return a successful response', () async {
      final response =
          await Netio.get<String>('https://jsonplaceholder.typicode.com/todos/1', onReceiveProgress: (received, total) {
        print('${(received / total * 100).toStringAsFixed(0)}%');
      });

      expect(response.statusCode, equals(200));

      expect(response.data, isA<String>());
    });
  });
}
