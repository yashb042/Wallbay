import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class InterstitialNew {
  static InterstitialAd _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  //
  // static _showInterstitialAdInternal() async {
  //   _interstitialAd.show();
  //   _interstitialAd = null;
  // }

  static void loadInterstitialAdInternal() async {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-1929569264679676/3602773554',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print(ad.responseInfo);
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              loadInterstitialAdInternal();
            }
          },
        ));
  }
  //
  // static void loadInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     _loadInterstitialAdInternal();
  //   }
  // }

  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadInterstitialAdInternal();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadInterstitialAdInternal();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  //
  // static void showInterstitialAd() {
  //   if (_interstitialAd != null) {
  //     _showInterstitialAdInternal();
  //   }
  //   _loadInterstitialAdInternal();
  // }
}
