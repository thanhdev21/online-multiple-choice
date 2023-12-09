import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constant.dart';

class PseudoTest extends StatefulWidget {
  const PseudoTest({super.key});

  @override
  PseudoTestState createState() => PseudoTestState();
}

class PseudoTestState extends State<PseudoTest> {
  BannerAd? _bannerAd;
  //NativeAd? _nativeAd;

  final String _adUnitId = Platform.isAndroid
      ? //'ca-app-pub-2570532928127892/3080996897'
        Constant.getNativeAdID()
      //'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // print the loading progress to the console
          // you can use this value to show a progress bar if you want
          debugPrint("Loading: $progress%");
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse("https://docs.google.com/forms/d/e/"
        + "1FAIpQLScjIWjmqYouo7dnBLsDxtMTIOqQ-9Zqei-EG5liuPsNUT050Q"
        + "/viewform"));

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bách Khoa không khó',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Ôn thi'),
          ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'Chức năng đang được phát triển, xin vui lòng quay lại sau một thời gian nữa',
              style: TextStyle(
                fontSize: 40
                // Your text style here
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
          ),
    );
  }

  /// Loads and shows a banner ad.
  ///
  /// Dimensions of the ad are determined by the AdSize class.
  void _loadAd() async {
    BannerAd(
    //NativeAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
      //NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            //_nativeAd = ad as NativeAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    //_nativeAd?.dispose();
    super.dispose();
  }
}