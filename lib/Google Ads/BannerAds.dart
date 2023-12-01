import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../main.dart';

class BannerAdWidget extends StatefulWidget {
  final BannerAd myBanner;
  const BannerAdWidget({super.key, required this.myBanner});

  @override
  BannerAdWidgetState createState() => BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.myBanner.size.width.toDouble(),
      height: widget.myBanner.size.height.toDouble(),
      child: AdWidget(ad: widget.myBanner),
    );
  }

  @override
  void dispose() {
    widget.myBanner.dispose();
    super.dispose();
  }
}
