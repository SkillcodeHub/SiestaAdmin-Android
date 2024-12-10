import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:siestaamsapp/Repository/More_Repository/Activity_repository/addUpdateActivityTranslation_repository.dart';
import 'package:sizer/sizer.dart';

class AddUpdateActivityTranslationViewModel with ChangeNotifier {
  final _myRepo = AddUpdateActivityTranslationRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _addUpdateActivityTranslationLoading = false;
  bool get addUpdateActivityTranslationLoading =>
      _addUpdateActivityTranslationLoading;

  setAddUpdateActivityTranslationLoading(bool value) {
    _addUpdateActivityTranslationLoading = value;
    notifyListeners();
  }

  Future<void> addUpdateActivityTranslationApi(
      String id, String token, dynamic data, BuildContext context) async {
    setLoading(true);

    await _myRepo
        .addUpdateActivityTranslationapi(id, token, data)
        .then((value) {
      if (value['status'] == true) {
        Navigator.pop(context);
        setLoading(false);

        if (kDebugMode) {
          print(value.toString());
        }
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                children: [
                  Center(
                    child: Text(
                      'Success',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: Text(
                'Activity Translation Updated',
                style: TextStyle(fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                SizedBox(
                  width: 80.w,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
      ;
    }).onError((error, stackTrace) {
      setLoading(false);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Center(
                  child: Text(
                    'Aleart!',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Text(
              error.toString(),
              style: TextStyle(fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              SizedBox(
                width: 80.w,
                child: ElevatedButton(
                  child: Text(
                    'OK',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );

      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
