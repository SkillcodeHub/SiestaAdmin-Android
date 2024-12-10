import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/AddTask_Repository/addScheduledTaskManually_repository.dart';
import 'package:siestaamsapp/Utils/Calender/date_utils.dart';
import 'package:sizer/sizer.dart';

class AddScheduledTaskManuallyViewModel with ChangeNotifier {
  final _myRepo = AddScheduledTaskManuallyRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _addScheduledTaskManuallyLoading = false;
  bool get addNewActivityLoading => _addScheduledTaskManuallyLoading;

  setAddScheduledTaskManuallyLoading(bool value) {
    _addScheduledTaskManuallyLoading = value;
    notifyListeners();
  }

  Future<void> addScheduledTaskManuallyApi(
      String token, dynamic data, BuildContext context) async {
    print(data);
    setLoading(true);
    await _myRepo.addScheduledTaskManuallyapi(token, data).then((value) {
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
                'Activity Added',
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
      } else if (value['status'] == false) {
        Utils.flushBarErrorMessage1(
            value['message'], Duration(seconds: 4), context);
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
