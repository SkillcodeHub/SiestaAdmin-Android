import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siestaamsapp/Model/Custom_Model/dashboard_type.dart';

class AuthModal extends Equatable {
  final bool? isLoggedIn;
  final String? accessToken;
  final DashboardType? dashboardType;
  final List<String>? authRoles;
  final List<String>? canAdd;
  final List<String>? canRead;
  final List<String>? canUpdate;

  AuthModal({
    required this.isLoggedIn,
    required this.accessToken,
    this.dashboardType,
    this.authRoles,
    this.canUpdate,
    this.canRead,
    this.canAdd,
  });

  @override
  List<Object> get props => [
        this.isLoggedIn!,
        this.accessToken!,
        this.authRoles!,
        this.dashboardType!,
        this.canUpdate!,
        this.canRead!,
        this.canAdd!,
      ];
}

class AuthStateProvider with ChangeNotifier {
  static final String keyAccessToken = 'accessToken';
  static final String keyUserDashboard = 'userDashboard';
  static final String keyUserAuthRoles = 'userAuthRoles';

  FlutterSecureStorage flutterSecureStorage;
  BehaviorSubject<AuthModal> _authStateRx = BehaviorSubject();

  AuthStateProvider({
    required this.flutterSecureStorage,
  }) {
    _getLoginState().then((value) {
      _authStateRx.add(value);
    }, onError: (error) {
      print(error);
      _authStateRx.add(AuthModal(isLoggedIn: false, accessToken: null));
    });
  }

  ValueStream<AuthModal> get checkLoginStateRx => _authStateRx.stream;

  AuthModal get checkLoginState => _authStateRx.value;

  Future<void> loginWithToken(String token) {
    return flutterSecureStorage
        .write(key: keyAccessToken, value: token)
        .whenComplete(() {
      _authStateRx.sink.add(AuthModal(isLoggedIn: true, accessToken: token));
    });
  }

  Future<void> updateLoginAuthData({
    String? token,
    String? dashboardTypeCode,
    List<String>? authRoles,
    String? dashboardTypeName,
    List<String>? canAdd,
    List<String>? canRead,
    List<String>? canUpdate,
  }) async {
    await flutterSecureStorage.write(
      key: keyAccessToken,
      value: token,
    );
    await flutterSecureStorage.write(
      key: keyUserDashboard,
      value: dashboardTypeCode,
    );
    await flutterSecureStorage.write(
      key: keyUserAuthRoles,
      value: authRoles == null ? null : authRoles.join(","),
    );
    _authStateRx.sink.add(
      AuthModal(
        isLoggedIn: token != null && token.trim().length > 0,
        accessToken: token.toString(),
        dashboardType: DashboardType(
          code: dashboardTypeCode,
          name: dashboardTypeName,
        ),
        authRoles: authRoles,
        canAdd: canAdd,
        canRead: canRead,
        canUpdate: canUpdate,
      ),
    );
  }

  Future<void> logoutUser() async {
    await flutterSecureStorage.delete(key: keyAccessToken);
    await flutterSecureStorage.delete(key: keyUserAuthRoles);
    await flutterSecureStorage.delete(key: keyUserDashboard);
    _authStateRx.add(
      AuthModal(
        isLoggedIn: false,
        accessToken: null,
        authRoles: null,
        dashboardType: null,
        canUpdate: null,
        canRead: null,
        canAdd: null,
      ),
    );
  }

  Future<AuthModal> _getLoginState() async {
    final result = await flutterSecureStorage.readAll();
    String token = result[keyAccessToken].toString();

    bool isLoggedIn = token != null && token.trim().length > 0;
    return AuthModal(isLoggedIn: isLoggedIn, accessToken: token);
  }

  bool get isUserAuthorized =>
      _authStateRx.value.authRoles != null &&
      _authStateRx.value.authRoles!.length > 0;

  DashboardType? get getUserDashboard => _authStateRx.value.dashboardType;

  @override
  void dispose() {
    _authStateRx.close();
    super.dispose();
  }
}
class ExpandableListSettingProvider with ChangeNotifier {
  bool _isExpandedByDefault = false;
  final String _keyListExpandedByDefault = 'list_expanded_by_default';

  ExpandableListSettingProvider() {
    isExpListExpandedByDefaultFuture().then((value) {
      _isExpandedByDefault = value;
      notifyListeners();
    });
  }

  Future<bool> isExpListExpandedByDefaultFuture() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_keyListExpandedByDefault)) {
      _isExpandedByDefault = prefs.getBool(_keyListExpandedByDefault)!;
    } else {
      await prefs.setBool(_keyListExpandedByDefault, _isExpandedByDefault);
    }
    return _isExpandedByDefault;
  }

  bool get isListExpandedByDefault {
    return this._isExpandedByDefault;
  }

  Future<void> changeExpandedByDefault(bool? value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyListExpandedByDefault, value!);
    this._isExpandedByDefault = value;
    notifyListeners();
  }
}

