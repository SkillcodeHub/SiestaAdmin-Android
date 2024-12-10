class ScheduledActivitiesByIdModel {
  bool? status;
  String? message;
  ScheduledActivitiesById? data;

  ScheduledActivitiesByIdModel({this.status, this.message, this.data});

  ScheduledActivitiesByIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ScheduledActivitiesById.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ScheduledActivitiesById {
  int? schedulerId;
  int? activityId;
  String? activityName;
  String? activityNameTranslation;
  String? activityDescriptionTranslation;
  String? executionType;
  String? executionStatus;
  String? executionStatusTranslation;
  int? isImageRequired;
  dynamic scheduledDate;
  dynamic assignedById;
  dynamic assignedToId;
  dynamic assignedByName;
  dynamic assignedToName;
  dynamic startedOn;
  dynamic completedOn;
  dynamic delayDeadline;
  int? propertyId;
  dynamic propertyNameTranslation;
  dynamic propertyDescriptionTranslation;
  String? propertyName;
  String? propertyNumber;
  dynamic propertyArea;
  dynamic propertyDevStageId;
  dynamic propertyDevStageName;
  dynamic ownerId;
  int? organizationId;
  String? createdDateUTC;
  String? lastUpdatedUTC;
  dynamic comments;
  String? groupCode;
  String? groupName;
  int? groupPriority;
  List<StageActions>? stageActions;
  List<StageHistory>? stageHistory;

  ScheduledActivitiesById(
      {this.schedulerId,
      this.activityId,
      this.activityName,
      this.activityNameTranslation,
      this.activityDescriptionTranslation,
      this.executionType,
      this.executionStatus,
      this.executionStatusTranslation,
      this.isImageRequired,
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
      this.propertyName,
      this.propertyNumber,
      this.propertyArea,
      this.propertyDevStageId,
      this.propertyDevStageName,
      this.ownerId,
      this.organizationId,
      this.createdDateUTC,
      this.lastUpdatedUTC,
      this.comments,
      this.groupCode,
      this.groupName,
      this.groupPriority,
      this.stageActions,
      this.stageHistory});

  ScheduledActivitiesById.fromJson(Map<String, dynamic> json) {
    schedulerId = json['schedulerId'];
    activityId = json['activityId'];
    activityName = json['activityName'];
    activityNameTranslation = json['activityNameTranslation'];
    activityDescriptionTranslation = json['activityDescriptionTranslation'];
    executionType = json['executionType'];
    executionStatus = json['executionStatus'];
    executionStatusTranslation = json['executionStatusTranslation'];
    isImageRequired = json['isImageRequired'];
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
    propertyName = json['propertyName'];
    propertyNumber = json['propertyNumber'];
    propertyArea = json['propertyArea'];
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
    if (json['stageActions'] != null) {
      stageActions = <StageActions>[];
      json['stageActions'].forEach((v) {
        stageActions!.add(new StageActions.fromJson(v));
      });
    }
    if (json['stageHistory'] != null) {
      stageHistory = <StageHistory>[];
      json['stageHistory'].forEach((v) {
        stageHistory!.add(new StageHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedulerId'] = this.schedulerId;
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
    data['activityNameTranslation'] = this.activityNameTranslation;
    data['activityDescriptionTranslation'] =
        this.activityDescriptionTranslation;
    data['executionType'] = this.executionType;
    data['executionStatus'] = this.executionStatus;
    data['executionStatusTranslation'] = this.executionStatusTranslation;
    data['isImageRequired'] = this.isImageRequired;
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
    data['propertyName'] = this.propertyName;
    data['propertyNumber'] = this.propertyNumber;
    data['propertyArea'] = this.propertyArea;
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
    if (this.stageActions != null) {
      data['stageActions'] = this.stageActions!.map((v) => v.toJson()).toList();
    }
    if (this.stageHistory != null) {
      data['stageHistory'] = this.stageHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StageActions {
  String? id;
  String? name;
  int? isCommentRequired;

  StageActions({this.id, this.name, this.isCommentRequired});

  StageActions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isCommentRequired = json['isCommentRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isCommentRequired'] = this.isCommentRequired;
    return data;
  }
}

class StageHistory {
  int? schedulerId;
  String? stageId;
  String? stageTranslation;
  List<String>? images;
  String? createdBy;
  int? organizationId;
  String? createdDateUtc;
  dynamic comments;

  StageHistory(
      {this.schedulerId,
      this.stageId,
      this.stageTranslation,
      this.images,
      this.createdBy,
      this.organizationId,
      this.createdDateUtc,
      this.comments});

  StageHistory.fromJson(Map<String, dynamic> json) {
    schedulerId = json['schedulerId'];
    stageId = json['stageId'];
    stageTranslation = json['stageTranslation'];
    images = json['images'].cast<String>();
    createdBy = json['createdBy'];
    organizationId = json['organizationId'];
    createdDateUtc = json['createdDateUtc'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedulerId'] = this.schedulerId;
    data['stageId'] = this.stageId;
    data['stageTranslation'] = this.stageTranslation;
    data['images'] = this.images;
    data['createdBy'] = this.createdBy;
    data['organizationId'] = this.organizationId;
    data['createdDateUtc'] = this.createdDateUtc;
    data['comments'] = this.comments;
    return data;
  }
}
