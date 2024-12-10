import 'package:equatable/equatable.dart';

class TaskStageReportOverview extends Equatable {
  final num totalCount;
  final String executionStageCode, executionStageName, groupName;
  final dynamic translation;

  TaskStageReportOverview({
    required this.totalCount,
    required this.executionStageCode,
    required this.executionStageName,
    required this.groupName,
    required this.translation,
  });

  @override
  List<Object> get props => [
        this.totalCount,
        this.executionStageCode,
        this.executionStageName,
        this.groupName,
        this.translation,
      ];

  TaskStageReportOverview copyWith({
    num? totalCount,
    String? executionStageCode,
    String? executionStageName,
    String? groupName,
    dynamic translation,
  }) =>
      TaskStageReportOverview(
        totalCount: totalCount ?? this.totalCount,
        executionStageCode: executionStageCode ?? this.executionStageCode,
        executionStageName: executionStageName ?? this.executionStageName,
        groupName: groupName ?? this.groupName,
        translation: translation ?? this.translation,
      );

  factory TaskStageReportOverview.fromJson(Map<String, dynamic> json) =>
      TaskStageReportOverview(
        totalCount: json["totalCount"],
        executionStageCode: json["executionStageCode"],
        executionStageName: json["executionStageName"],
        groupName: json["groupName"],
        translation: json["translation"],
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "executionStageCode": executionStageCode,
        "executionStageName": executionStageName,
        "groupName": groupName,
        "translation": translation,
      };
}
