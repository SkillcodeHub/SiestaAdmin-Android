import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Utils;
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/camera_page.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/list_item.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class CameraPageAndroid extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

//  final CameraProvider provider;

  CameraPageAndroid(this._scaffoldKey, {Key? key}) : super(key: key);

  @override
  CameraPageAndroidState createState() {
    return CameraPageAndroidState();
  }
}

class CameraPageAndroidState extends State<CameraPageAndroid>
    with WidgetsBindingObserver {
  CameraController? controller;
  String? imagePath;
  num currentCamera = 0;
  double zoomMin = 1, zoomMax = 1, zoomCurrent = 1;
  List<ListItem<File>>? _selectedList;
  List<CameraDescription>? _cameras;
  Utils.PageStatus pageStatus = Utils.PageStatus.IDLE;
  String? pageError;
  bool
      // permissionStorage = true,
      permissionCamera = false;

  @override
  void initState() {
    super.initState();
    _cameras = [];
    _selectedList = [];
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      retryPermission(forceRequest: true);
      if (controller == null || !controller!.value.isInitialized) {
        resetCamera();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state: $state");
    if (state == AppLifecycleState.inactive) {
      try {
        if (controller != null) {
          controller?.dispose();
        }
      } catch (e) {
        print(e);
      }
    } else if (state == AppLifecycleState.resumed) {
      retryPermission(forceRequest: false);
    }
  }

  void retryPermission({bool forceRequest = false}) {
    print('retry permission - forceRequest: $forceRequest');
    setState(() {
      pageStatus = Utils.PageStatus.PROGRESS;
    });
    Utils.permissionMultiModal(forceRequest: forceRequest, permissions: [
      // Permission.storage,
      Permission.camera
    ]).then((value) {
      if (value[Permission.camera]!.isGranted

          //  &&
          //     value[Permission.storage]!.isGranted
          ) {
        print('permission: storage & camera-> true');
        setState(() {
          // permissionStorage = true;
          permissionCamera = true;
          pageStatus = Utils.PageStatus.SUCCESS;
        });
        availableCameras().then((value) {
          setState(() {
            _cameras!.clear();
            _cameras!.addAll(value);
            resetCamera();
          });
        }).catchError((error) {});
      } else {
        print('permission-> camera:${value[Permission.camera]}');
        // storage:${

        //   value[Permission.storage]},

        setState(() {
          // permissionStorage = value[Permission.storage]!.isGranted;
          permissionCamera = value[Permission.camera]!.isGranted;
          pageStatus = Utils.PageStatus.ERROR;
          pageError = null;
        });
      }
    }).catchError((e) {
      setState(() {
        pageStatus = Utils.PageStatus.ERROR;
        pageError = Utils.getErrorMessage(context, e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (pageStatus) {
      case Utils.PageStatus.SUCCESS:
        {
          return widgetContentView(context);
        }
      case Utils.PageStatus.ERROR:
        {
          Widget w;
          if (pageError == null) {
            w = widgetPermission(context);
          } else {
            w = Utils.getErrorView(
              context,
              error: Utils.getErrorMessage(context, pageError),
              callback: () {
                retryPermission(forceRequest: true);
              },
            );
          }
          return w;
        }
      case Utils.PageStatus.PROGRESS:
        {
          return Utils.getProgressView(context);
        }
      case Utils.PageStatus.IDLE:
      default:
        {
          return Utils.getErrorView(context, callback: () {
            retryPermission(forceRequest: true);
          });
        }
    }
  }

  Widget widgetPermission(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!permissionCamera)
            Text(AppString.get(context).cameraPermissionNotAvailable()),
          if (!permissionCamera) SizedBox(height: 16),
          // if (!permissionStorage)
          //   Text(AppString.get(context).storagePermissionNotAvailable()),
          // if (!permissionStorage) SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              retryPermission(
                forceRequest: true,
              );
            },
            icon: Icon(Icons.refresh),
            label: Text(AppString.get(context).retry()),
          )
        ],
      ),
    );
  }

  Widget widgetContentView(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: _cameraPreviewWidget(),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: controller != null && controller!.value.isRecordingVideo
                    ? Colors.redAccent
                    : Colors.grey,
                width: 3.0,
              ),
            ),
          ),
        ),
        widgetZoomControl(context),
        _captureControlRowWidget(),
      ],
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return CameraPreview(controller!);
    }
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return imagePath == null
        ? Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey,
                ],
                stops: [0, 0.7],
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey,
                ],
                stops: [0, 0.7],
              ),
            ),
            child: SizedBox(
              width: 64.0,
              height: 48,
              child: InkWell(
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    if (_selectedList!.length > 1)
                      Positioned.fill(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '+${_selectedList!.length - 1}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                  ],
                ),
                onTap: () {
                  Scaffold.of(context).showBottomSheet(
                    (context) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: _selectedList?.length,
                        itemBuilder: (context, index) {
                          return BottomSheetImages(_selectedList![index]);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return _cameras!.isEmpty
        ? Container(
            child: Center(
              child: Text('No Camera Found'),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(child: _cameraTogglesRowWidget(), flex: 1),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  color: Colors.blue,
                  onPressed: controller != null &&
                          controller!.value.isInitialized &&
                          !controller!.value.isRecordingVideo
                      ? onTakePictureButtonPressed
                      : null,
                ),
              ),
              Expanded(flex: 1, child: _thumbnailWidget()),
            ],
          );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    num listOfCams = _cameras!.length;
    CameraDescription cameraDescription =
        _cameras![currentCamera.toInt() % listOfCams.toInt()];

    return SizedBox(
      width: 90.0,
      child: IconButton(
        icon: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
        onPressed: () {
          setState(() {
            currentCamera++;
            resetCamera();
          });
        },
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(widget._scaffoldKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void resetCamera() {
    num listOfCams = _cameras!.length;
    if (listOfCams > 0) {
      CameraDescription cameraDescription =
          _cameras![currentCamera.toInt() % listOfCams.toInt()];
      onNewCameraSelected(cameraDescription);
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    // var perm1 = await Utils.permissionModelStorage();
    // if (perm1 == null || !perm1) {
    //   showInSnackBar('Storage permission required');
    //   return;
    // }
    // enabledStorage = perm1;
    //
    // var perm2 = await Utils.permissionModelCamera();
    // if (perm2 == null || !perm2) {
    //   showInSnackBar('Camera permission required');
    //   return;
    // }
    // enabledCamera = perm2;

    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller?.addListener(() async {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        showInSnackBar('Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller?.initialize();
      zoomMax = await controller!.getMaxZoomLevel();
      zoomMin = await controller!.getMinZoomLevel();
      controller!.setZoomLevel(zoomCurrent);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String? filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
//        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    String? filePath = '';
    try {
      final result = await controller!.takePicture();
      filePath = result.path;
    } on CameraException catch (e) {
      filePath = null;
      _showCameraException(e);
      return null;
    }
    print(filePath);
    _selectedList!.add(ListItem(File(filePath), isSelected: true));
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description.toString());
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void donePressed() {
    Navigator.of(context).pop(_selectedList);

    print("222222222222222222222222222222222$_selectedList");
  }

  Widget widgetZoomControl(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(Icons.zoom_out_outlined),
          Flexible(
            child: Slider.adaptive(
              value: zoomCurrent,
              onChanged: (value) {
                setState(() {
                  zoomCurrent = value;
                  controller!.setZoomLevel(zoomCurrent);
                });
              },
              min: zoomMin,
              max: zoomMax,
            ),
            flex: 1,
          ),
          Icon(Icons.zoom_in_outlined),
        ],
      ),
    );
  }
}
