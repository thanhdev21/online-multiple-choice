class Constant{
  static final String _TEST_NATIVE_AD_ID = 'ca-app-pub-3940256099942544/2247696110';
  static final String _NATIVE_AD_ID = 'ca-app-pub-2570532928127892/3080996897';

  static final String _TEST_APP_OPEN_ID = 'ca-app-pub-3940256099942544/9257395921';
  static final String _APP_OPEN_ID = 'ca-app-pub-2570532928127892/2523196337';
  static final bool _IS_TEST = true;
  static String getNativeAdID(){
    return _IS_TEST ? _TEST_NATIVE_AD_ID : _NATIVE_AD_ID;
  }

  static String getAdOpenID(){
    return _IS_TEST ? _TEST_APP_OPEN_ID : _APP_OPEN_ID;
  }
}