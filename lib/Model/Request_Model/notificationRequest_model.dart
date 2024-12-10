import 'package:equatable/equatable.dart';

class NotificationRequests extends Equatable {
  final double? id;
  final int? createdById;
  final int? createdByMobile;
  final String? createdByName;
  final String? notfReqType;
  final int? requestStatus;
  final String? createdDate;
  final String? modifiedDate;
  final int? organizationId;
  final String? dashboardType;
  final dynamic notificationData;

  NotificationRequests({
    this.id,
    this.createdById,
    this.createdByName,
    this.notfReqType,
    this.requestStatus,
    this.createdDate,
    this.modifiedDate,
    this.organizationId,
    this.dashboardType,
    this.notificationData,
    this.createdByMobile,
  });

  @override
  List<Object> get props => [
        id!,
        createdById!,
        createdByName!,
        notfReqType!,
        requestStatus!,
        createdDate!,
        modifiedDate!,
        organizationId!,
        dashboardType!,
        notificationData,
        createdByMobile!,
      ];

  NotificationRequests copyWith({
    double? id,
    int? createdById,
    String? createdByName,
    int? createdByMobile,
    String? type,
    int? status,
    String? createdDate,
    String? modifiedDate,
    int? organizationId,
    String? dashboardType,
    dynamic notificationData,
  }) =>
      NotificationRequests(
        id: id ?? this.id,
        createdById: createdById,
        createdByName: createdByName,
        createdByMobile: createdByMobile,
        notfReqType: type,
        requestStatus: status,
        createdDate: createdDate,
        modifiedDate: modifiedDate,
        organizationId: organizationId,
        dashboardType: dashboardType,
        notificationData: notificationData ?? this.notificationData,
      );

  factory NotificationRequests.fromJson(Map<String, dynamic> json) =>
      NotificationRequests(
        id: json["id"] == null ? null : json["id"].toDouble(),
        createdById: json["createdById"] == null ? null : json["createdById"],
        createdByName:
            json["createdByName"] == null ? null : json["createdByName"],
        createdByMobile:
            json["createdByMobile"] == null ? null : json["createdByMobile"],
        notfReqType: json["notfReqType"] == null ? null : json["notfReqType"],
        requestStatus:
            json["requestStatus"] == null ? null : json["requestStatus"],
        createdDate: json["createdDate"] == null ? null : json["createdDate"],
        modifiedDate:
            json["modifiedDate"] == null ? null : json["modifiedDate"],
        organizationId:
            json["organizationId"] == null ? null : json["organizationId"],
        dashboardType:
            json["dashboardType"] == null ? null : json["dashboardType"],
        notificationData:
            json["notificationData"] == null ? null : json["notificationData"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "createdById": createdById == null ? null : createdById,
        "createdByName": createdByName == null ? null : createdByName,
        "createdByMobile": createdByMobile == null ? null : createdByMobile,
        "notfReqType": notfReqType == null ? null : notfReqType,
        "requestStatus": requestStatus == null ? null : requestStatus,
        "createdDate": createdDate == null ? null : createdDate,
        "modifiedDate": modifiedDate == null ? null : modifiedDate,
        "organizationId": organizationId == null ? null : organizationId,
        "dashboardType": dashboardType == null ? null : dashboardType,
        "notificationData":
            notificationData == null ? null : notificationData.toJson(),
      };
}
