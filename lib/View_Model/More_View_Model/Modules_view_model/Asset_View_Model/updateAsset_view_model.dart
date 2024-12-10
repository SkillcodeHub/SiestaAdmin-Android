import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:siestaamsapp/Repository/More_Repository/Assets_repository/updateAsset_repository.dart';
import 'package:sizer/sizer.dart';

class UpdateAssetViewModel with ChangeNotifier {
  final _myRepo = UpdateAssetRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _updateAssetDataLoading = false;
  bool get updateAssetLoading => _updateAssetDataLoading;

  setUpdateAssetDataLoading(bool value) {
    _updateAssetDataLoading = value;
    notifyListeners();
  }

  Future<void> updateAssetApi(
      String id, String token, dynamic data, BuildContext context) async {
    print(data);
    setLoading(true);
    await _myRepo.updateAssetapi(id, token, data).then((value) {
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
                'Asset/Property Updated',
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
                Container(
                  height: 30.h,
                  child: Lottie.asset('images/errorLogo.json',
                      reverse: false, repeat: false, fit: BoxFit.cover),
                ),
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
