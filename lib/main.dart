import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'AppOpenAdManager.dart';
import 'pseudo_test.dart';
import 'survey.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize().then((InitializationStatus status) {
    AppOpenAdManager.loadAd(); // Load the ad when the app starts
    runApp(MyApp());
  });
  //IronSource.validateIntegration( );
  //MobileAds.instance.initialize();
  //runApp(const MyApp());
  /*runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BannerExample(),
  ));*/
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bách Khoa Sempai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: BannerExample(),
    );
  }
}

/// A simple app that loads a banner ad.
class BannerExample extends StatefulWidget {
  const BannerExample({super.key});

  @override
  BannerExampleState createState() => BannerExampleState();
}

class BannerExampleState extends State<BannerExample> {
  BannerAd? _bannerAd;
  //NativeAd? _nativeAd;
  static final isLoading = ValueNotifier<bool>(true);
  String _formId = '';
  static const String URL =
      'https://script.google.com/macros/s/AKfycbzXR1-3exaN8TNqAEkEtEJr26Uc0WzAPdSq74QHz-um5LViLL48LIbsdQUABY5XBaWarg/exec';
  Future<void> _fetchFormId() async {
    final response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _formId = jsonResponse['data'];
      });
      _controller.loadRequest(
          Uri.parse('https://docs.google.com/forms/d/e/$_formId/viewform'));
    } else {
      throw Exception('Failed to load form ID');
    }
  }

  final String _adUnitId = Platform.isAndroid
      ? //'ca-app-pub-2570532928127892/3080996897'
      Constant.getNativeAdID()
      //'ca-app-pub-3940256099942544/6300978111' //=> test tren Android
      : 'ca-app-pub-3940256099942544/2934735716'; //-> test tren iOS

  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // print the loading progress to the console
          // you can use this value to show a progress bar if you want
          debugPrint("Loading: $progress%");
        },
        onPageStarted: (String url) {
          BannerExampleState.isLoading.value = true;
        },
        onPageFinished: (String url) {
          BannerExampleState.isLoading.value = false;
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    );
  /*..loadRequest(Uri.parse("https://docs.google.com/forms/d/e/"
        + "1FAIpQLSeA9PztOhNMjxLmFyzpCAt-oW9ZxfueJM69E0YVEedl88hZwg"
        + "/viewform"));*/

  @override
  void initState() {
    super.initState();
    _loadAd();
    _fetchFormId();
  }

  @override
  Widget build(BuildContext context) {
    //final nativeAd = _nativeAd;
    return MaterialApp(
      title: 'Bách Khoa không khó',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Bách Khoa không khó'),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Xin chào bạn',
                      style: TextStyle(fontSize: 32, color: Color(0xffFFEB2A))),
                  decoration: BoxDecoration(
                    color: Color(0xffD8202A),
                  ),
                ),
                ListTile(
                  title: Text('Khảo sát', style: TextStyle(fontSize: 30)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Survey()));
                  },
                ),
                ListTile(
                  title: Text('Ôn thi', style: TextStyle(fontSize: 30)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PseudoTest()));
                  },
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              WebViewWidget(
                controller: _controller,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, isLoading, child) {
                  if (isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              if (_bannerAd != null)
                //if (nativeAd != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                    /*child: Container(
                    //child: Container(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      //height: _nativeAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                      //child: AdWidget(ad: nativeAd),
                    //),
                  ),*/
                  ),
                )
            ],
          )),
    );
  }

  /// Loads and shows a banner ad.
  ///
  /// Dimensions of the ad are determined by the AdSize class.
  void _loadAd() async {
    BannerAd(
      //_nativeAd = NativeAd(
      adUnitId: _adUnitId,
      // factoryId: 'dfdfdf',
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
          print("Failed rồi. Không hiện được ad đâu");
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {
          print("here");
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
    //_nativeAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    //_nativeAd?.dispose();
    super.dispose();
  }
}

class NewScreen extends StatelessWidget {
  final String title;

  NewScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Chức năng $title đang được phát triển, xin vui lòng quay lại sau một thời gian nữa',
        ),
      ),
    );
  }
}

class GoogleForm extends StatelessWidget {
  final String title;

  GoogleForm({required this.title});

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
        //+ "1FAIpQLScjIWjmqYouo7dnBLsDxtMTIOqQ-9Zqei-EG5liuPsNUT050Q"
        +
        "1FAIpQLSesp1GkPViPWeo1lvVBmEhO3dkPK1_h4UzuL3F1d9Afu67Sew" +
        "/viewform"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: WebViewWidget(
          controller: _controller,
        ));
  }
}
