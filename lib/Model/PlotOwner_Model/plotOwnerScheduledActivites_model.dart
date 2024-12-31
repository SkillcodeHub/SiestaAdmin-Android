class PlotOwnerScheduledActivitiesModel {
  bool? status;
  String? message;
  List<PlotOwnerScheduledActivities>? data;
  dynamic meta;

  PlotOwnerScheduledActivitiesModel({this.status, this.message, this.data, this.meta});

  PlotOwnerScheduledActivitiesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PlotOwnerScheduledActivities>[];
      json['data'].forEach((v) {
        data!.add(new PlotOwnerScheduledActivities.fromJson(v));
      });
    }
    meta = json['meta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['meta'] = this.meta;
    return data;
  }
}

class PlotOwnerScheduledActivities {
  int? schedulerId;
  dynamic slipNo;
  int? parentSchedulerId;
  int? activityId;
  String? executionType;
  String? executionStatus;
  String? executionStatusTranslation;
  int? isImageRequired;
  String? activityName;
  String? activityNameTranslation;
  String? activityDescriptionTranslation;
  String? scheduledDate;
  dynamic assignedById;
  dynamic assignedToId;
  dynamic assignedByName;
  dynamic assignedToName;
  String? startedOn;
  String? completedOn;
  dynamic delayDeadline;
  int? propertyId;
  String? propertyNameTranslation;
  String? propertyDescriptionTranslation;
  String? propertyNumber;
  String? propertyArea;
  String? propertyName;
  dynamic propertyDevStageId;
  dynamic propertyDevStageName;
  int? ownerId;
  int? organizationId;
  String? createdDateUTC;
  String? lastUpdatedUTC;
  dynamic comments;
  String? groupCode;
  String? groupName;
  int? groupPriority;

  PlotOwnerScheduledActivities(
      {this.schedulerId,
      this.slipNo,
      this.parentSchedulerId,
      this.activityId,
      this.executionType,
      this.executionStatus,
      this.executionStatusTranslation,
      this.isImageRequired,
      this.activityName,
      this.activityNameTranslation,
      this.activityDescriptionTranslation,
      this.scheduledDate,
      this.assignedById,
      this.assignedToId,
      this.assignedByName,
      this.assignedToName,
      this.startedOn,
      this.completedOn,
      this.delayDeadline,
      this.propertyId,
      this.propertyNameTranslation,
      this.propertyDescriptionTranslation,
      this.propertyNumber,
      this.propertyArea,
      this.propertyName,
      this.propertyDevStageId,
      this.propertyDevStageName,
      this.ownerId,
      this.organizationId,
      this.createdDateUTC,
      this.lastUpdatedUTC,
      this.comments,
      this.groupCode,
      this.groupName,
      this.groupPriority});

  PlotOwnerScheduledActivities.fromJson(Map<String, dynamic> json) {
    schedulerId = json['schedulerId'];
    slipNo = json['slipNo'];
    parentSchedulerId = json['parentSchedulerId'];
    activityId = json['activityId'];
    executionType = json['executionType'];
    executionStatus = json['executionStatus'];
    executionStatusTranslation = json['executionStatusTranslation'];
    isImageRequired = json['isImageRequired'];
    activityName = json['activityName'];
    activityNameTranslation = json['activityNameTranslation'];
    activityDescriptionTranslation = json['activityDescriptionTranslation'];
    scheduledDate = json['scheduledDate'];
    assignedById = json['assignedById'];
    assignedToId = json['assignedToId'];
    assignedByName = json['assignedByName'];
    assignedToName = json['assignedToName'];
    startedOn = json['startedOn'];
    completedOn = json['completedOn'];
    delayDeadline = json['delayDeadline'];
    propertyId = json['propertyId'];
    propertyNameTranslation = json['propertyNameTranslation'];
    propertyDescriptionTranslation = json['propertyDescriptionTranslation'];
    propertyNumber = json['propertyNumber'];
    propertyArea = json['propertyArea'];
    propertyName = json['propertyName'];
    propertyDevStageId = json['propertyDevStageId'];
    propertyDevStageName = json['propertyDevStageName'];
    ownerId = json['ownerId'];
    organizationId = json['organizationId'];
    createdDateUTC = json['createdDateUTC'];
    lastUpdatedUTC = json['lastUpdatedUTC'];
    comments = json['comments'];
    groupCode = json['groupCode'];
    groupName = json['groupName'];
    groupPriority = json['groupPriority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedulerId'] = this.schedulerId;
    data['slipNo'] = this.slipNo;
    data['parentSchedulerId'] = this.parentSchedulerId;
    data['activityId'] = this.activityId;
    data['executionType'] = this.executionType;
    data['executionStatus'] = this.executionStatus;
    data['executionStatusTranslation'] = this.executionStatusTranslation;
    data['isImageRequired'] = this.isImageRequired;
    data['activityName'] = this.activityName;
    data['activityNameTranslation'] = this.activityNameTranslation;
    data['activityDescriptionTranslation'] =
        this.activityDescriptionTranslation;
    data['scheduledDate'] = this.scheduledDate;
    data['assignedById'] = this.assignedById;
    data['assignedToId'] = this.assignedToId;
    data['assignedByName'] = this.assignedByName;
    data['assignedToName'] = this.assignedToName;
    data['startedOn'] = this.startedOn;
    data['completedOn'] = this.completedOn;
    data['delayDeadline'] = this.delayDeadline;
    data['propertyId'] = this.propertyId;
    data['propertyNameTranslation'] = this.propertyNameTranslation;
    data['propertyDescriptionTranslation'] =
        this.propertyDescriptionTranslation;
    data['propertyNumber'] = this.propertyNumber;
    data['propertyArea'] = this.propertyArea;
    data['propertyName'] = this.propertyName;
    data['propertyDevStageId'] = this.propertyDevStageId;
    data['propertyDevStageName'] = this.propertyDevStageName;
    data['ownerId'] = this.ownerId;
    data['organizationId'] = this.organizationId;
    data['createdDateUTC'] = this.createdDateUTC;
    data['lastUpdatedUTC'] = this.lastUpdatedUTC;
    data['comments'] = this.comments;
    data['groupCode'] = this.groupCode;
    data['groupName'] = this.groupName;
    data['groupPriority'] = this.groupPriority;
    return data;
  }
}
