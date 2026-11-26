import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'fake_api.dart';

// Unit test ApiClient dengan MockClient: memeriksa URL, header, body, dan
// penanganan status non-2xx tanpa server Django sungguhan.

void main() {
  test(
    'getExperiences memanggil GET publik dan mengurai semua field',
    () async {
      final requests = <http.Request>[];
      final experiences = await fakeApi(requests: requests).getExperiences();

      expect(requests.single.method, 'GET');
      expect(requests.single.url.toString(), 'http://test/api/v1/experience/');
      expect(requests.single.headers.containsKey('Authorization'), isFalse);

      final experience = experiences.single;
      expect(experience.id, 'exp-1');
      expect(experience.categoryLabel, 'Volunteer');
      expect(experience.thumbnail, isNull);
      expect(experience.endedAt, DateTime.utc(2026, 6, 30));
      expect(experience.isOngoing, isFalse);
      expect(experience.starCount, 3);
    },
  );

  test(
    'createExperience mengirim token dan hanya field yang boleh ditulis',
    () async {
      final requests = <http.Request>[];
      final created = await fakeApi(requests: requests).createExperience(
        Experience(
          id: 'jangan-dikirim',
          title: 'Asdos PBP',
          description: 'Membantu tutorial',
          category: 'part-time',
          endedAt: DateTime.utc(2026, 11, 1),
          starCount: 99,
        ),
        token: 'abc123',
      );

      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.headers['Authorization'], 'Token abc123');
      // id dan field star diisi server, jadi tidak ikut dikirim (includeToJson: false).
      expect(jsonDecode(request.body), {
        'title': 'Asdos PBP',
        'description': 'Membantu tutorial',
        'category': 'part-time',
        'thumbnail': null,
        'ended_at': '2026-11-01T00:00:00.000Z',
      });
      expect(created.id, 'new-exp');
    },
  );

  test('status non-2xx dilempar sebagai ApiException, bukan null', () async {
    final api = fakeApi(writeStatus: 403);
    await expectLater(
      api.createExperience(
        const Experience(title: 't', description: 'd'),
        token: 'abc123',
      ),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 403),
      ),
    );
    await expectLater(
      fakeApi(listStatus: 500).getExperiences(),
      throwsA(isA<ApiException>()),
    );
  });

  test(
    'deleteExperience memanggil DELETE ke URL detail dengan token',
    () async {
      final requests = <http.Request>[];
      await fakeApi(requests: requests)
          .deleteExperience('exp-1', token: 'abc123');

      expect(requests.single.method, 'DELETE');
      expect(requests.single.url.path, '/api/v1/experience/exp-1/');
      expect(requests.single.headers['Authorization'], 'Token abc123');
    },
  );

  test('field opsional yang hilang memakai nilai default', () {
    final experience = Experience.fromJson({
      'title': 'Magang',
      'description': 'Backend',
    });
    expect(experience.category, 'full-time');
    expect(experience.categoryLabel, '');
    expect(experience.endedAt, isNull);
    expect(experience.isOngoing, isTrue);
  });

  test('obtainToken dan logout memakai endpoint auth', () async {
    final requests = <http.Request>[];
    final api = fakeApi(requests: requests);
    expect(await api.obtainToken('owner', 'secret'), 'abc123');
    await api.logout(token: 'abc123');
    expect(requests.last.url.path, '/api/v1/auth/logout/');

    final failing = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((_) async => http.Response('bad', 400)),
    );
    await expectLater(
      failing.obtainToken('owner', 'x'),
      throwsA(isA<ApiException>()),
    );
  });
}
