import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Repository/More_Repository/Activity_repository/updateActivity_repository.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/getActivityDetail_view_model.dart';
import 'package:sizer/sizer.dart';

class UpdateActivityViewModel with ChangeNotifier {
  final _myRepo = UpdateActivityRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _dataLoading = false;
  bool get dataLoading => _dataLoading;

  setdataLoading(bool value) {
    _dataLoading = value;
    notifyListeners();
  }

  Future<void> updateActivityApi(
      String id, String token, dynamic data, BuildContext context) async {
    print(data);
    setLoading(true);
    final updateActivityViewModel =
        Provider.of<UpdateActivityViewModel>(context, listen: false);
    final getActivityDetailsViewmodel =
        Provider.of<GetActivityDetailsViewmodel>(context, listen: false);

    await _myRepo.updateActivityapi(id, token, data).then((value) {
      if (value['status'] == true) {
        updateActivityViewModel.setdataLoading(false);
        getActivityDetailsViewmodel.setIsImageRequired(false);
        setLoading(false);
        Navigator.of(context).pop();

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
                'New Activity Added',
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
      updateActivityViewModel.setdataLoading(false);
      getActivityDetailsViewmodel.setIsImageRequired(false);

      setLoading(false);
      String? message;

      String jsonString = error.toString();

      // Find the start and end index of the JSON string
      int startIndex = jsonString.indexOf('{');
      int endIndex = jsonString.lastIndexOf('}');

      // Extract the JSON substring
      String jsonSubstring = jsonString.substring(startIndex, endIndex + 1);

      // Parse the JSON substring
      Map<String, dynamic> jsonResponse = json.decode(jsonSubstring);

      // Access the "message" field
      message = jsonResponse['message'];

      // Print the message
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
              message.toString(),
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

class ImageState extends ChangeNotifier {
  bool _isImageRequired = false;

  bool get isImageRequired => _isImageRequired;

  void setImageRequired(bool value) {
    _isImageRequired = value;
    notifyListeners(); // Notify listeners that the state has changed
  }
}
