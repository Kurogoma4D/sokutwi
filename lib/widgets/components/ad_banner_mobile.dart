import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sokutwi/constants/environment_config.dart';

const _isProd = String.fromEnvironment('flavor') == 'prod';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late final AdManagerBannerAd _banner;

  @override
  void initState() {
    super.initState();
    _banner = AdManagerBannerAd(
      adUnitId: _isProd ? Env.admobBannerId : Env.admobTestBannerId,
      sizes: [AdSize.banner],
      listener: AdManagerBannerAdListener(),
      request: const AdManagerAdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _banner.sizes.first.width.toDouble(),
      height: _banner.sizes.first.height.toDouble(),
      child: AdWidget(ad: _banner),
    );
  }

  @override
  void dispose() {
    _banner.dispose();
    super.dispose();
  }
}
