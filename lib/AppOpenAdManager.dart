import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constant.dart';


class AppOpenAdManager {
  static AppOpenAd? _appOpenAd;
  static DateTime? _loadTime;

  static Future<void> loadAd() async {
    if (_isShowingAd() || _isAdAvailable()) {
      return;
    }

    /*_appOpenAd = AppOpenAd(
      adUnitId: Constant.getAdOpenID(),
      request: AdRequest(),
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('Ad loaded: ${ad.adUnitId}');
          _loadTime = DateTime.now();
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: ${ad.adUnitId}, $error');
          ad.dispose();
          _appOpenAd = null;
        },
      ),
    );*/
    await AppOpenAd.load(
    //_appOpenAd = AppOpenAd(
      adUnitId: Constant.getAdOpenID(),
      request: AdRequest(),
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('Ad loaded: ${ad.adUnitId}');
          _loadTime = DateTime.now();
          _appOpenAd = ad as AppOpenAd;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Ad failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
    //await _appOpenAd!.load();
  }

  static bool _isShowingAd() {
    if (_loadTime != null) {
      return DateTime.now().difference(_loadTime!) < Duration(minutes: 3);
    } else {
      // Xử lý trường hợp _loadTime là null
      // Ví dụ: trả về false, hoặc đặt _loadTime thành một giá trị mặc định
      return false;
    }
  }

  static bool _isAdAvailable() {
    return _appOpenAd != null;
  }

  static void showAdIfAvailable() {
    if (!_isAdAvailable()) {
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        print('Ad dismissed: ${ad.adUnitId}');
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Ad failed to show: ${ad.adUnitId}, $error');
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );

    _appOpenAd!.show();
    _appOpenAd = null;
  }
}