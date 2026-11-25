import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// ApiClient palsu untuk widget test: tidak ada request sungguhan ke Django.
///
/// Login berhasil untuk `owner` / `secret`, daftar proyek berisi satu proyek,
/// dan POST proyek membalas 201 dengan data yang dikirim. Setiap request
/// dicatat di [requests] supaya test bisa memeriksa header dan body-nya.
ApiClient fakeApi({List<http.Request>? requests}) {
  return ApiClient(
    baseUrl: 'http://test',
    client: MockClient((request) async {
      requests?.add(request);
      final path = request.url.path;
      if (path == '/api/v1/auth/token/') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        if (body['username'] == 'owner' && body['password'] == 'secret') {
          return http.Response('{"token": "abc123"}', 200);
        }
        return http.Response('{"non_field_errors": ["bad"]}', 400);
      }
      if (path == '/api/v1/auth/logout/') return http.Response('', 204);
      if (path == '/api/v1/projects/' && request.method == 'POST') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({...body, 'id': 'new-id'}), 201);
      }
      if (path == '/api/v1/projects/') {
        return http.Response(
          jsonEncode([
            {
              'id': '1',
              'title': 'Sortify',
              'description': 'Waste sorting app',
              'thumbnail': 'sortify-card.png',
              'star_count': 2,
              'is_starred': false,
              'starred_by_names': 'a, b',
            },
          ]),
          200,
        );
      }
      return http.Response('not found', 404);
    }),
  );
}
