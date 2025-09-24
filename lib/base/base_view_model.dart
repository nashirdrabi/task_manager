
import 'package:flutter/foundation.dart';

import '../di/service_locator.dart';
import 'base_repo.dart';

abstract class BaseViewModel<N, R extends BaseRepo> extends ChangeNotifier {
  // UserSharedPreferences _localStorage = UserSharedPreferences();
  // AuthTokenStorage _localStorage = AuthTokenStorageImpl();

  bool _showLoading = false;
  bool _showLoadingAnimation = false;
  R repository = serviceLocator<R>();

  bool get showLoading => _showLoading;
  bool get showLoadingAnimation => _showLoadingAnimation;

  late N _navigator;

  N getNavigator() => _navigator;

  void setNavigator(N navigator) {
    _navigator = navigator;
  }

  set showLoading(bool value) {
    _showLoading = value;
    notifyListeners();
  }

  set showLoadingAnimation(bool value) {
    _showLoadingAnimation = value;
    notifyListeners();
  }

  printException(e) {
    if (kDebugMode) {
      print(e);
    }
  }



  // setUserName(String userName) async {
  //   repository.setUserName(userName);
  // }


  // Future<String?> getUserId() async {
  //   return await repository.getUserId();
  // }
}
