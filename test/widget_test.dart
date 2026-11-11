import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('menekan kartu menu memunculkan SnackBar', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Burhan'), findsOneWidget);

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pump();

    expect(find.text('Kamu telah menekan tombol Lihat Proyek!'), findsOneWidget);
  });
}
