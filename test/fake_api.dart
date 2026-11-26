import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Contoh respons `GET /api/v1/experience/` dari Django.
const sampleExperience = {
  'id': 'exp-1',
  'title': 'Staff Pengmas BEM',
  'description': 'Mengajar anak-anak',
  'category': 'volunteer',
  'category_label': 'Volunteer',
  'thumbnail': null,
  'started_at': '2026-01-10T08:00:00Z',
  'ended_at': '2026-06-30T00:00:00Z',
  'is_ongoing': false,
  'star_count': 3,
  'is_starred': false,
  'starred_by_names': 'ani, budi, citra',
};

/// ApiClient palsu untuk test: tidak ada request sungguhan ke Django.
///
/// - Login berhasil untuk `owner` / `secret` (token `abc123`).
/// - `GET` proyek berisi satu proyek; `GET` experience berisi [experiences].
/// - `POST` membalas 201 dengan data yang dikirim, kecuali [writeStatus]
///   diisi (misalnya 401 atau 403) untuk menguji penanganan error.
/// - [listStatus] mengatur status `GET` experience (misalnya 500).
///
/// Setiap request dicatat di [requests] supaya test bisa memeriksa header
/// dan body-nya.
ApiClient fakeApi({
  List<http.Request>? requests,
  List<Map<String, dynamic>> experiences = const [sampleExperience],
  int? writeStatus,
  int listStatus = 200,
}) {
  return ApiClient(
    baseUrl: 'http://test',
    client: MockClient((request) async {
      requests?.add(request);
      final path = request.url.path;
      final isWrite = request.method == 'POST' || request.method == 'DELETE';

      if (path == '/api/v1/auth/token/') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        if (body['username'] == 'owner' && body['password'] == 'secret') {
          return http.Response('{"token": "abc123"}', 200);
        }
        return http.Response('{"non_field_errors": ["bad"]}', 400);
      }
      if (path == '/api/v1/auth/logout/') return http.Response('', 204);
      if (isWrite && writeStatus != null) {
        return http.Response('{"detail": "error"}', writeStatus);
      }

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

      if (path == '/api/v1/experience/' && request.method == 'POST') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            ...body,
            'id': 'new-exp',
            'category_label': 'Volunteer',
            'started_at': '2026-11-26T00:00:00Z',
            'is_ongoing': body['ended_at'] == null,
            'star_count': 0,
            'is_starred': false,
            'starred_by_names': '',
          }),
          201,
        );
      }
      if (path == '/api/v1/experience/') {
        if (listStatus != 200) return http.Response('server error', listStatus);
        return http.Response(jsonEncode(experiences), 200);
      }
      if (path.startsWith('/api/v1/experience/') &&
          request.method == 'DELETE') {
        return http.Response('', 204);
      }
      return http.Response('not found', 404);
    }),
  );
}

/// Membungkus [home] dengan provider yang sama seperti `MyApp`. Isi [token]
/// untuk memulai dalam keadaan sudah login.
Widget withProviders(ApiClient api, Widget home, {String? token}) {
  return MultiProvider(
    providers: [
      Provider.value(value: api),
      ChangeNotifierProvider(
        create: (_) => AuthState(api, initialToken: token),
      ),
    ],
    child: MaterialApp(home: home),
  );
}
