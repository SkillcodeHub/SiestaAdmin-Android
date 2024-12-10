import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/camera_android.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/list_item.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class CameraPage extends StatelessWidget {
  // static const String routeName = '/camera_page';

  CameraPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<CameraPageAndroidState> _keyAndroidChildState =
      GlobalKey<CameraPageAndroidState>();
  // final GlobalKey<CameraPageIOSState> _keyIosChildState =
  //     GlobalKey<CameraPageIOSState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          AppString.get(context).add(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              openAppSettings();
            },
          ),
          OutlinedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  appSecondaryColor), // Set background color here
            ),
            icon: Icon(Icons.done_all, color: Colors.white),
            onPressed: () {
              if (Platform.isAndroid) {
                _keyAndroidChildState.currentState!.donePressed();
              } else {
                // _keyIosChildState.currentState.donePressed();
              }
            },
            label: Text(
              AppString.get(context).submit(),
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: CameraPageSelector(
        scaffoldKey: _scaffoldKey,
        childAndroidState: _keyAndroidChildState,
        // childIosState: _keyIosChildState,
      ),
    );
  }
}

class CameraPageSelector extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final GlobalKey<CameraPageAndroidState>? childAndroidState;
  // final GlobalKey<CameraPageIOSState> childIosState;

  CameraPageSelector({
    Key? key,
    this.scaffoldKey,
    this.childAndroidState,
    // this.childIosState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return CameraPageAndroid(
        scaffoldKey!,
        key: childAndroidState,
      );
    } else {
      return CameraPageAndroid(
        scaffoldKey!,
        key: childAndroidState,
      );
      // return CameraPageIOS(
      //   scaffoldKey,
      //   key: childIosState,
      // );
    }
  }
}

class BottomSheetImages extends StatefulWidget {
  final ListItem<File> item;

  BottomSheetImages(this.item, {Key? key}) : super(key: key);

  @override
  BottomSheetImagesState createState() {
    return BottomSheetImagesState();
  }
}

class BottomSheetImagesState extends State<BottomSheetImages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => toggleSelection(widget.item.isSelected),
      child: Container(
        height: 200,
        margin: EdgeInsets.all(5),
        child: Card(
          elevation: 4,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.file(
                widget.item.data,
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.bottomRight,
                color: Colors.white.withOpacity(0.3),
                child: Checkbox(
                  value: widget.item.isSelected,
                  onChanged: (value) => setSelection,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  toggleSelection(bool selected) {
    setState(() {
      widget.item.isSelected = !selected;
    });
  }

  setSelection(bool selected) {
    setState(() {
      widget.item.isSelected = selected;
    });
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
