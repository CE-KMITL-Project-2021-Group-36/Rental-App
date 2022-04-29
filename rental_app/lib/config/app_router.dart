import 'package:flutter/material.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:rental_app/widgets/widget.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    debugPrint('This is route: ${settings.name}');

    switch (settings.name) {
      case '/':
        return CustomNavBar.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route();
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
      case OwnerAccountScreen.routeName:
        return OwnerAccountScreen.route();
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
      case WalletInputPasscode.routeName:
        return WalletInputPasscode.route();
      case WalletTopUp.routeName:
        return WalletTopUp.route();
      case WalletRequestWithdrawal.routeName:
        return WalletRequestWithdrawal.route();
      case ContractManagementScreen.routeName:
        return ContractManagementScreen.route(
            userType: settings.arguments as String);
      case EditProfileScreen.routeName:
        return EditProfileScreen.route();
      case EditAddressScreen.routeName:
        return EditAddressScreen.route();
      case AddAddressScreen.routeName:
        return AddAddressScreen.route(documentId: settings.arguments as String);
      case ResetPasswordScreen.routeName:
        return ResetPasswordScreen.route();
      case EditPhoneNumberScreen.routeName:
        return EditPhoneNumberScreen.route(phone: settings.arguments as String);
      case AddShopScreen.routeName:
        return AddShopScreen.route();
      case ShopScreen.routeName:
        return ShopScreen.route(ownerId: settings.arguments as String);
      case EditShopScreen.routeName:
        return EditShopScreen.route();
            case ProductManagementScreen.routeName:
        return ProductManagementScreen.route();
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
