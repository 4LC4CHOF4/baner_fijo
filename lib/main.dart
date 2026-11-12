import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const String _androidTestBannerId = 'ca-app-pub-3940256099942544/6300978111';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const BannerFijoApp());
}

class BannerFijoApp extends StatelessWidget {
  const BannerFijoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF159E98);

    return MaterialApp(
      title: 'Banner fijo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: teal),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF17212B),
          centerTitle: false,
        ),
      ),
      home: const BannerDemoPage(),
    );
  }
}

class BannerDemoPage extends StatelessWidget {
  const BannerDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner de tamaño fijo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F5F3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.ads_click, size: 34, color: Color(0xFF117F79)),
                SizedBox(height: 18),
                Text(
                  'Un espacio publicitario\ncon medidas definidas.',
                  style: TextStyle(
                    fontSize: 25,
                    height: 1.18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17212B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Este ejemplo muestra un banner estándar fijo, anclado al pie de la pantalla.',
                  style: TextStyle(fontSize: 15, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _InfoCard(
            icon: Icons.straighten,
            title: 'Tamaño fijo',
            value: '320 × 50 dp',
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            icon: Icons.phone_android,
            title: 'Plataforma',
            value: 'Android · Google AdMob',
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            icon: Icons.science_outlined,
            title: 'Modo de demostración',
            value: 'ID de anuncio de prueba de Google',
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E9EF)),
            ),
            child: const Text(
              'El banner conserva su espacio de 320 × 50 dp mientras carga. '
              'El anuncio que se muestra es de prueba y no genera ingresos.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _FixedBannerSlot(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E9EF)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF117F79)),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF667085))),
                const SizedBox(height: 3),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FixedBannerSlot extends StatefulWidget {
  const _FixedBannerSlot();

  @override
  State<_FixedBannerSlot> createState() => _FixedBannerSlotState();
}

class _FixedBannerSlotState extends State<_FixedBannerSlot> {
  BannerAd? _bannerAd;
  BannerAd? _loadingBanner;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    final banner = BannerAd(
      adUnitId: _androidTestBannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _loadingBanner = null;
            _hasError = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _loadingBanner = null;
            _hasError = true;
          });
          debugPrint('No se pudo cargar el banner de prueba: $error');
        },
      ),
    );

    _loadingBanner = banner;
    unawaited(banner.load());
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _loadingBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bannerSize = AdSize.banner;

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E9EF))),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: SizedBox(
            width: bannerSize.width.toDouble(),
            height: bannerSize.height.toDouble(),
            child: _bannerAd != null
                ? AdWidget(ad: _bannerAd!)
                : DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        _hasError
                            ? 'Anuncio de prueba no disponible'
                            : 'Cargando banner 320 × 50',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
