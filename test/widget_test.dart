import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart'
    show instanceManager;

import 'package:baner_fijo/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('muestra la pantalla y el espacio del banner', (
    WidgetTester tester,
  ) async {
    final methodChannel = instanceManager.channel;
    final calls = <MethodCall>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async {
          calls.add(call);
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, null);
    });

    await tester.pumpWidget(const BannerFijoApp());
    await tester.pump();

    expect(find.text('Banner de tamaño fijo'), findsOneWidget);
    expect(find.text('Cargando banner 320 × 50'), findsOneWidget);
    expect(calls.map((call) => call.method), contains('loadBannerAd'));
  });
}
