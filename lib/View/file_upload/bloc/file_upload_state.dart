part of 'file_upload_bloc.dart';

abstract class FileUploadState {}

class IdleState extends FileUploadState {}

class FileUploadRunningState extends FileUploadState {
  final List<UploadModel> _pendingItems;
  final List<UploadModel> _pausedItems;

  FileUploadRunningState(this._pendingItems, this._pausedItems);

  List<UploadModel> get getPendingUploads => this._pendingItems;

  List<UploadModel> get getPausedUploads => this._pausedItems;
}

/*
class FileUploadPausedState extends FileUploadState {
  final List<UploadModel> _pausedItems;

  FileUploadPausedState(this._pausedItems);

  @override
  List<Object> get props => [_pausedItems];

  List<UploadModel> get getPausedItems => this._pausedItems;
}
*/
