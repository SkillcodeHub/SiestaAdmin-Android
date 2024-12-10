import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Model/More_Model/languageList_model.dart';

// class AppLanguageProvider with ChangeNotifier {
//   static final String _keyAppLanguage = 'app_language';
//   static final String _defaultValueAppLanguage = 'eng';
//   String _currentLanguage = _defaultValueAppLanguage;

//   AppLanguageProvider() {
//     getCurrentLanguageFuture.then((value) {
//       _currentLanguage = value;
//       notifyListeners();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   String get getCurrentAppLanguage => _currentLanguage;

//   Future<String> get getCurrentLanguageFuture async {
//     final prefs = await SharedPreferences.getInstance();
//     if (prefs.containsKey(_keyAppLanguage)) {
//       _currentLanguage = prefs.getString(_keyAppLanguage)!;
//     } else {
//       prefs.setString(_keyAppLanguage, _currentLanguage);
//     }
//     return _currentLanguage;
//   }
//   Stream<DatabaseEvent> get getLanguageListStream {
//     return FirebaseDatabase.instance
//         .ref('/siesta_admin/settings/language')
//         .onValue
//         ;
//   }
//   Future<DataSnapshot> get getLanguageListFuture {
//     return FirebaseDatabase.instance
//         .ref('/siesta_admin/settings/language')
//         .get();
//   }

//   Future<void> changeLanguage(String type) async {
//     FirebaseAnalytics.instance.logEvent(name: 'language_change');
//     try {
//       var prefs = await SharedPreferences.getInstance();
//       var status = await prefs.setString(_keyAppLanguage, type);
//       if (status != null && status) {
//         _currentLanguage = type;
//         notifyListeners();
//       }
//     } catch (e, stack) {
//       FirebaseCrashlytics.instance.setCustomKey('language_change', type);
//       FirebaseCrashlytics.instance.recordError(e, stack);
//     }
//   }
//     List<Language> getLanguageList({required DatabaseEvent listEvent}) {
//     var temp = listEvent.snapshot.value as List;
//     return temp.map((e) => Language.fromSnapshot(e)).toList();
//   }

// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/More_Model/languageList_model.dart';

class AppLanguageProvider with ChangeNotifier {
  static const String _keyAppLanguage = 'app_language';
  static const String _defaultLanguage = 'guj';

  String _currentLanguage = _defaultLanguage;

  // Predefined language list
  final List<Language> _languageList = [
    Language(
      languageCode: 'eng', 
      name: 'English', 
      isActive: 1
    ),
    Language(
      languageCode: 'guj', 
      name: 'Gujarati', 
      isActive: 1
    )
  ];

  AppLanguageProvider() {
    _loadCurrentLanguage();
  }

  // Load current language from SharedPreferences
  Future<void> _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_keyAppLanguage) ?? _defaultLanguage;
    notifyListeners();
  }

  // Getter for current app language
  String get getCurrentAppLanguage => _currentLanguage;

  // Get language list
  List<Language> get getLanguageList => _languageList;

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppLanguage, languageCode);
    
    _currentLanguage = languageCode;
    notifyListeners();
  }
}