import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/Activity_Scheduler_Repository/addNewActivitySchedulers_repository.dart';
import 'package:sizer/sizer.dart';

class AddNewActivitySchedulersViewModel with ChangeNotifier {
  final _myRepo = AddNewActivitySchedulersRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _addNewActivitySchedulersLoading = false;
  bool get addNewActivitySchedulersLoading => _addNewActivitySchedulersLoading;

  setAddNewActivitySchedulersLoading(bool value) {
    _addNewActivitySchedulersLoading = value;
    notifyListeners();
  }

  Future<void> addNewActivitySchedulersApi(
      String token, List<Activities> data, BuildContext context) async {
    setLoading(true);
    data.forEach((element) {
      if (element.everyDaySpan == null) {
        DateTime schDate =
            DateTime.parse(element.scheduledDate.toString()).toLocal();
        var date =
            '${schDate.toLocal().year}-${schDate.toLocal().month.toString().padLeft(2, '0')}-${schDate.toLocal().day.toString().padLeft(2, '0')}';
        element.scheduledDate = date;
      }
    });
    await _myRepo.addNewActivitySchedulersapi(token, data).then((value) {
      if (value['status'] == true) {
        Navigator.pop(context, true);
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
                'New ActivityScheduler Added',
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
