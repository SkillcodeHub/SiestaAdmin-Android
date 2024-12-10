import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:siestaamsapp/constants/global.dart';

class UploadModel extends Equatable {
  DateTime time = DateTime.now();
  List<File> files;
  String uploadURL = '$urlCurrent/files/';
  UploadModule module;
  dynamic moduleId, moduleStatus;
  String? subTitle;
  bool isUploading, isSuccessFullyUploaded;
  String? uploadId;
  num progress;
  dynamic uploadError;

  UploadModel({
    required this.module,
    required this.files,
    this.moduleId,
    this.moduleStatus,
    this.uploadError,
    this.subTitle,
    this.progress = 0,
    this.isUploading = false,
    this.isSuccessFullyUploaded = false,
  });

  @override
  List<Object> get props => [
        files,
        uploadURL,
        isUploading,
        isSuccessFullyUploaded,
        uploadError,
        progress,
        module,
        moduleId,
        moduleStatus,
      ];

  static String getUploadModuleName(UploadModule module) {
    switch (module) {
      case UploadModule.SCHEDULED_ACTIVITY:
        {
          return 'Scheduled Activity';
        }
      case UploadModule.ACTIVITY_SCHEDULER:
        {
          return 'Activity Scheduler';
        }
      case UploadModule.ACTIVITY:
        {
          return 'Activity';
        }
      case UploadModule.ASSET:
        {
          return 'Asset';
        }
      case UploadModule.USER:
        {
          return 'User';
        }
      default:
        {
          return '';
        }
    }
  }

  static String getUploadModuleCode(UploadModule module) {
    switch (module) {
      case UploadModule.SCHEDULED_ACTIVITY:
        {
          return 'scheduled_activity';
        }
      case UploadModule.ACTIVITY_SCHEDULER:
        {
          return 'activity_scheduler';
        }
      case UploadModule.ACTIVITY:
        {
          return 'activity';
        }
      case UploadModule.ASSET:
        {
          return 'asset';
        }
      case UploadModule.USER:
        {
          return 'user';
        }
      default:
        {
          return '';
        }
    }
  }
}

enum UploadModule {
  SCHEDULED_ACTIVITY,
  ACTIVITY_SCHEDULER,
  ACTIVITY,
  USER,
  ASSET
}
