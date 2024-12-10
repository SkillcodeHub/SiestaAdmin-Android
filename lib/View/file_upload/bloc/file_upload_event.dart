part of 'file_upload_bloc.dart';

abstract class FileUploadEvent extends Equatable {
  const FileUploadEvent();
}

class RefreshStatusEvent extends FileUploadEvent {
  @override
  List<Object> get props => [];
}

class AddToUploadEvent extends FileUploadEvent {
  final UploadModel uploadModel;

  AddToUploadEvent(this.uploadModel);

  @override
  List<Object> get props => [uploadModel];
}

class RemoveFromUploadEvent extends FileUploadEvent {
  final UploadModel uploadModel;

  RemoveFromUploadEvent(this.uploadModel);

  @override
  List<Object> get props => [uploadModel];
}

class CancelAllUploadsEvent extends FileUploadEvent {
  @override
  List<Object> get props => [];
}

class RemoveCompletedUploadsEvent extends FileUploadEvent {
  @override
  List<Object> get props => [];
}

/*
class PauseAllUploadsEvent extends FileUploadEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class ResumeAllUploadsEvent extends FileUploadEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PauseUploadEvent extends FileUploadEvent {
  final UploadModel file;

  PauseUploadEvent(this.file);

  @override
  List<Object> get props => [file];
}

class ResumeUploadEvent extends FileUploadEvent {
  final UploadModel file;

  ResumeUploadEvent(this.file);

  @override
  List<Object> get props => [file];
}
*/
