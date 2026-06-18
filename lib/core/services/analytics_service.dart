import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Track when a user logs in
  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);
  }

  /// Track when a user signs up
  Future<void> logSignUp({required String method}) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  /// Track screen/page views manually if needed
  Future<void> logScreenView({required String screenName, String? screenClass}) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  /// Track when a user views a product
  Future<void> logViewProduct({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
  }) async {
    await _analytics.logViewItem(
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
          price: price,
        ),
      ],
      value: price,
      currency: 'USD',
    );
  }

  /// Track when a product is added to the cart
  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
    int quantity = 1,
  }) async {
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
          price: price,
          quantity: quantity,
        ),
      ],
      value: price * quantity,
      currency: 'USD',
    );
  }

  /// Track when a product is added to wishlist
  Future<void> logAddToWishlist({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
  }) async {
    await _analytics.logAddToWishlist(
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
          price: price,
        ),
      ],
      value: price,
      currency: 'USD',
    );
  }

  /// Track search queries
  Future<void> logSearch({required String query}) async {
    await _analytics.logSearch(searchTerm: query);
  }

  /// Track beginning of checkout
  Future<void> logBeginCheckout({
    required double value,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logBeginCheckout(
      value: value,
      currency: 'USD',
      items: items,
    );
  }

  /// Track completed purchase
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logPurchase(
      transactionId: transactionId,
      value: value,
      currency: 'USD',
      items: items,
    );
  }

  /// Set user ID to track specific users uniquely
  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// Track custom events
  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
