import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/file_upload/bloc/upload_model.dart';

export 'package:flutter_uploader/flutter_uploader.dart';

part 'file_upload_event.dart';
part 'file_upload_state.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  FlutterUploader uploader;
  List<UploadModel> _uploadingItemsList = [];
  Map<String, UploadModel> _uploadMap = new Map();
  Map<String, dynamic> _errorItemsMap = new Map();
  List<UploadModel> _pausedItemsList = [];
  late StreamSubscription _progressSub;
  late StreamSubscription _resultSub;
  final _secureStorage = new FlutterSecureStorage();
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token1;

  FileUploadBloc({required this.uploader}) : super(IdleState()) {
    _progressSub = uploader.progress
        .listen(progressListener, onError: (error) => progressErrorListener);
    _resultSub = uploader.result
        .listen(resultListener, onError: (error) => resultErrorListener);
    init(); // Call the initialization method after construction
  }
  // Initialization method
  Future<void> init() async {
    await userPreference.getUserData().then((value) {
      UserData = value!;
      token1 = UserData['data']['accessToken'].toString();
    });
  }

  @override
  Future<void> close() {
    uploader.clearUploads().then((value) {
      _uploadingItemsList.clear();
      _errorItemsMap.clear();
      _uploadMap.clear();
    }, onError: (e) {
      print(e);
    });
    _resultSub.cancel();
    _progressSub.cancel();
    return super.close();
  }

  @override
  Stream<FileUploadState> mapEventToState(
    FileUploadEvent event,
  ) async* {
    switch (event.runtimeType) {
      case CancelAllUploadsEvent:
        {
          await uploader.clearUploads();
          yield IdleState();
          break;
        }
      case AddToUploadEvent:
        {
          AddToUploadEvent tempEvent = event as AddToUploadEvent;
          await _addToUpload(tempEvent.uploadModel);
          yield FileUploadRunningState(_uploadingItemsList, _pausedItemsList);
          break;
        }
      case RemoveFromUploadEvent:
        {
          RemoveFromUploadEvent tempEvent = event as RemoveFromUploadEvent;
          await _removeFromUpload(tempEvent.uploadModel);
          if ((_uploadingItemsList.length + _pausedItemsList.length) > 0) {
            yield FileUploadRunningState(_uploadingItemsList, _pausedItemsList);
          } else {
            yield IdleState();
          }
          break;
        }
      case RefreshStatusEvent:
        {
          if (state is IdleState) {
            yield IdleState();
          } else if (state is FileUploadRunningState) {
            yield FileUploadRunningState(_uploadingItemsList, _pausedItemsList);
          }
          break;
        }
      case RemoveCompletedUploadsEvent:
        {
          var toRemove = [];
          _uploadingItemsList.forEach((element) {
            if (element.isSuccessFullyUploaded) {
              toRemove.add(element);
            }
          });

          _uploadingItemsList
              .removeWhere((element) => toRemove.contains(element));
          if ((_uploadingItemsList.length + _pausedItemsList.length) > 0) {
            yield FileUploadRunningState(_uploadingItemsList, _pausedItemsList);
          } else {
            yield IdleState();
          }
          break;
        }
      /*case ResumeAllUploadsEvent:
        {
          if(state is IdleState){
            yield IdleState();
          }else {
            _uploadingItemsList.addAll(_pausedItemsList);
            _pausedItemsList.clear();
            yield FileUploadRunningState(_uploadingItemsList, _pausedItemsList);
          }
          break;
        }
      case PauseAllUploadsEvent:
        {
          if (state is IdleState) {
            yield IdleState();
          } else {
            _pausedItemsList.addAll(_uploadingItemsList);
            _uploadingItemsList.clear();
            yield FileUploadPausedState(_pausedItemsList);
          }
          break;
        }
      case PauseUploadEvent:
        {
          PauseUploadEvent tempEvent = event;
          _pauseUploading(tempEvent.file);
          if (state is IdleState) {
            yield IdleState();
          } else {
            if(_uploadingItemsList.length>0){
              yield FileUploadRunningState(_uploadingItemsList, _pausedItemsList);
            }else{
              yield FileUploadPausedState(_pausedItemsList);
            }
          }
          break;
        }
      case ResumeUploadEvent:
        {
          ResumeUploadEvent tempEvent = event;
          _resumeUploading(tempEvent.file);
          if (state is IdleState) {
            yield IdleState();
          } else {
            yield FileUploadRunningState(_uploadingItemsList, _pausedItemsList);
          }
          break;
        }*/
    }
  }

/*  void _pauseUploading(UploadModel file) {}

  void _resumeUploading(UploadModel file) {}*/

  /*Future<void> _addToUpload(List<UploadModel> files) async {
    for (num i = 0, j = files.length; i < j; i++) {
      final UploadModel model = files[i];
      model.isUploading = true;
      await _uploader
          .enqueue(
        url: model.uploadURL,
        files: [FileItem(savedDir: model.filePath, filename: model.fileName)],
        method: UploadMethod.POST,
        showNotification: true,
      )
          .then(
        (value) {
          model.uploadId = value;
          _uploadMap[model.uploadId] = model;
          _uploadingItemsList.add(model);
        },
      ).catchError(
        (e) {
          print('Add to upload error');
          print(e);
          _errorItemsMap[model.uploadId] = e;
        },
      );
    }
  }*/

  Future<void> _addToUpload(UploadModel uploadModel) async {
    // userPreference.getUserData().then((value) {
    //   UserData = value!;
    //   token1 = UserData['data']['accessToken'].toString();
    //   // cmsToken = UserData['data']['cmsToken'].toString();
    //   // print('CMS Token : $cmsToken');
    // });

    // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiIiwibW9iaWxlIjo2MzUzMzM1OTY3LCJzdXBlckFkbWluIjpmYWxzZSwiaWF0IjoxNzEzOTU3MTI4LCJleHAiOjE3MTM5ODMzOTksImlzcyI6Imh0dHBzOi8vd3d3LnNpZXN0YWxlaXN1cmVob21lcy5jb20ifQ.2yFLE90aeBX2kkZm65sKJy8mPQP6YBqQtodT1JZSPCI';
    List<FileItem> uploads = [];
    uploadModel.isUploading = true;
    uploadModel.files.forEach((element) {
      String filename = element.uri.toString().substring(
          element.uri.toString().lastIndexOf('/') + 1,
          element.uri.toString().length);

      print('path: ${element.path}, filename: $filename, uri: ${element.uri}');

      uploads.add(FileItem(
        path: element.path,
        field: 'images',
      ));
    });
    print(
        '###########################################################################');
    String? token = token1.toString();
    print(token);
    print(uploads);
    print(UploadModel.getUploadModuleCode(uploadModel.module));
    print(uploadModel.moduleId.toString());
    print(uploadModel.moduleStatus.toString());
    print(
        '###########################################################################');
    await uploader
        .enqueue(
      MultipartFormDataUpload(
        url: uploadModel.uploadURL,
        headers: {'Authorization': token.toString()},
        files: uploads,
        method: UploadMethod.POST,
        data: {
          'module': UploadModel.getUploadModuleCode(uploadModel.module),
          'moduleId': uploadModel.moduleId.toString(),
          'moduleStatus': uploadModel.moduleStatus as String
        },
      ),
    )
        .then(
      (value) {
        print("pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp");
        print(value);
        print("pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp");

        uploadModel.uploadId = value;
        _uploadMap[uploadModel.uploadId.toString()] = uploadModel;
        _uploadingItemsList.add(uploadModel);
      },
    ).catchError(
      (e) {
        print('Add to upload error');
        print(e);
        _errorItemsMap[uploadModel.uploadId.toString()] = e;
      },
    );
  }

  Future<void> _removeFromUpload(UploadModel model) async {
    String taskId = model.uploadId.toString();
    await _removeFromUploadById(taskId, model);
  }

  Future<void> _removeFromUploadById(String? taskId, UploadModel model) async {
    if (taskId != null) {
      await uploader.cancel(taskId: taskId).then((value) {
        try {
          _uploadMap.remove(model.uploadId);
        } catch (e) {
          print(e);
        }
        try {
          _uploadingItemsList.remove(model);
        } catch (e) {
          print(e);
        }
        try {
          _errorItemsMap.remove(model.uploadId);
        } catch (e) {
          print(e);
        }
      }).catchError((e) {
        print('Remove from Upload error');
        print(e);
      });
    } else {
      try {
        _uploadMap.remove(model.uploadId);
      } catch (e) {
        print(e);
      }
      try {
        _uploadingItemsList.remove(model);
      } catch (e) {
        print(e);
      }
      try {
        _errorItemsMap.remove(model.uploadId);
      } catch (e) {
        print(e);
      }
    }
  }

  Stream<UploadTaskProgress> get monitorProgress =>
      uploader.progress.asBroadcastStream();

  Stream<UploadTaskResponse> get monitorResponse =>
      uploader.result.asBroadcastStream();

  void progressListener(UploadTaskProgress? event) {
    if (_uploadMap == null || event == null || event.taskId == null) {
      return;
    }
    _uploadMap[event.taskId]?.progress = event.progress!;
    add(RefreshStatusEvent());
    print(
        'progress => taskId: ${event.taskId}, desc: ${event.status.description}');
  }

  void resultListener(UploadTaskResponse event) {
    print(
        'result => taskId: ${event.taskId}, desc: ${event.status?.description}, statusCode: ${event.status}');
    UploadModel? model = _uploadMap[event.taskId];
    if (model != null) {
      if (event.status == UploadTaskStatus.complete) {
//          _removeFromUploadById(event.taskId, model);
        model.isSuccessFullyUploaded = true;
        model.isUploading = false;
      } else if (event.status == UploadTaskStatus.enqueued) {
        model.isUploading = true;
        model.isSuccessFullyUploaded = false;
      } else if (event.status == UploadTaskStatus.running) {
        model.isUploading = true;
        model.isSuccessFullyUploaded = false;
      } else if (event.status == UploadTaskStatus.failed) {
        model.isSuccessFullyUploaded = false;
        model.isUploading = false;
      } else if (event.status == UploadTaskStatus.canceled) {
        model.isUploading = false;
        model.isSuccessFullyUploaded = false;
      } else if (event.status == UploadTaskStatus.paused) {
        model.isUploading = false;
        model.isSuccessFullyUploaded = false;
      } else {
        model.isUploading = false;
        model.isSuccessFullyUploaded = false;
      }
      add(RefreshStatusEvent());
    }
  }

  void resultErrorListener(error) {
    print('result error');
    print(error);
  }

  void progressErrorListener(error) {
    print('progress error');
    print(error);
  }
}
