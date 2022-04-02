import 'package:flutter/material.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:rental_app/screens/wallet.dart';
import 'package:rental_app/screens/wallet_init_passcode_screen.dart';
import 'package:rental_app/widgets/widget.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('This is route: ${settings.name}');

    switch (settings.name) {
      case '/':
        return CustomNavBar.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route();
      case ChatDetailScreen.routeName:
        return ChatDetailScreen.route();
      case NotificationScreen.routeName:
        return NotificationScreen.route();
      case ProductScreen.routeName:
        return ProductScreen.route(product: settings.arguments as Product);
      case SearchScreen.routeName:
        return SearchScreen.route();
      case CatalogScreen.routeName:
        return CatalogScreen.route(category: settings.arguments as Category);
      case AddProductScreen.routeName:
        return AddProductScreen.route();
      case UserStoreScreen.routeName:
        return UserStoreScreen.route();
      case EditProductScreen.routeName:
        return EditProductScreen.route(product: settings.arguments as Product);
      case KYC.routeName:
        return KYC.route();
      case ReviewScreen.routeName:
        return ReviewScreen.route(product: settings.arguments as Product);
      case AddReviewScreen.routeName:
        return AddReviewScreen.route(product: settings.arguments as Product);
      case Wallet.routeName:
        return Wallet.route();
      case WalletInitPasscode.routeName:
        return WalletInitPasscode.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
      ),
    );
  }
}
