class GetActivitySchedulersListModel {
  bool? status;
  String? message;
  List<ActivitySchedulers>? data;
  Null? meta;

  GetActivitySchedulersListModel(
      {this.status, this.message, this.data, this.meta});

  GetActivitySchedulersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ActivitySchedulers>[];
      json['data'].forEach((v) {
        data!.add(new ActivitySchedulers.fromJson(v));
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

class ActivitySchedulers {
  int? schedulerId;
  int? activityId;
  String? activityName;
  String? activityNameTranslation;
  String? activityDescriptionTranslation;
  String? scheduledDate;
  String? lastRunDate;
  int? scheduleIntervalValue;
  String? scheduleIntervalUnit;
  int? frequencyQty;
  String? frequencyUnit;
  Null? startDate;
  Null? endDate;
  String? everyDaySpan;
  String? everyDaySpanText;
  List<int>? everyDaySpanValue;
  int? propertyId;
  String? propertyName;
  String? propertyNumber;
  Null? propertyArea;
  String? propertyNameTranslation;
  String? propertyDescriptionTranslation;
  int? organizationId;
  String? createdDateUTC;
  int? isAutoSchedulable;
  String? autoSchedulableText;
  int? active;
  int? propertyDevStageId;
  String? propertyDevStageName;

  ActivitySchedulers({
    this.schedulerId,
    this.activityId,
    this.activityName,
    this.activityNameTranslation,
    this.activityDescriptionTranslation,
    this.scheduledDate,
    this.lastRunDate,
    this.scheduleIntervalValue,
    this.scheduleIntervalUnit,
    this.frequencyQty,
    this.frequencyUnit,
    this.startDate,
    this.endDate,
    this.everyDaySpan,
    this.everyDaySpanText,
    this.everyDaySpanValue,
    this.propertyId,
    this.propertyName,
    this.propertyNumber,
    this.propertyArea,
    this.propertyNameTranslation,
    this.propertyDescriptionTranslation,
    this.organizationId,
    this.createdDateUTC,
    this.isAutoSchedulable,
    this.autoSchedulableText,
    this.active,
    this.propertyDevStageId,
    this.propertyDevStageName,
  });

  ActivitySchedulers.fromJson(Map<String, dynamic> json) {
    schedulerId = json['schedulerId'];
    activityId = json['activityId'];
    activityName = json['activityName'];
    activityNameTranslation = json['activityNameTranslation'];
    activityDescriptionTranslation = json['activityDescriptionTranslation'];
    scheduledDate = json['scheduledDate'];
    lastRunDate = json['lastRunDate'];
    scheduleIntervalValue = json['scheduleIntervalValue'];
    scheduleIntervalUnit = json['scheduleIntervalUnit'];
    frequencyQty = json['frequencyQty'];
    frequencyUnit = json['frequencyUnit'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    everyDaySpan = json['everyDaySpan'];
    everyDaySpanText = json['everyDaySpanText'];
    everyDaySpanValue = json["everyDaySpanValue"] != null
        ? List<int>.from(
            (json["everyDaySpanValue"] as List).map((x) => x as int))
        : null;
    propertyId = json['propertyId'];
    propertyName = json['propertyName'];
    propertyNumber = json['propertyNumber'];
    propertyArea = json['propertyArea'];
    propertyNameTranslation = json['propertyNameTranslation'];
    propertyDescriptionTranslation = json['propertyDescriptionTranslation'];
    organizationId = json['organizationId'];
    createdDateUTC = json['createdDateUTC'];
    isAutoSchedulable = json['isAutoSchedulable'];
    autoSchedulableText = json['autoSchedulableText'];
    active = json['active'];
    propertyDevStageId = json['propertyDevStageId'];
    propertyDevStageName = json['propertyDevStageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedulerId'] = this.schedulerId;
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
    data['activityNameTranslation'] = this.activityNameTranslation;
    data['activityDescriptionTranslation'] =
        this.activityDescriptionTranslation;
    data['scheduledDate'] = this.scheduledDate;
    data['lastRunDate'] = this.lastRunDate;
    data['scheduleIntervalValue'] = this.scheduleIntervalValue;
    data['scheduleIntervalUnit'] = this.scheduleIntervalUnit;
    data['frequencyQty'] = this.frequencyQty;
    data['frequencyUnit'] = this.frequencyUnit;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['everyDaySpan'] = this.everyDaySpan;
    data['everyDaySpanText'] = this.everyDaySpanText;
    data['everyDaySpanValue'] = this.everyDaySpanValue;
    data['propertyId'] = this.propertyId;
    data['propertyName'] = this.propertyName;
    data['propertyNumber'] = this.propertyNumber;
    data['propertyArea'] = this.propertyArea;
    data['propertyNameTranslation'] = this.propertyNameTranslation;
    data['propertyDescriptionTranslation'] =
        this.propertyDescriptionTranslation;
    data['organizationId'] = this.organizationId;
    data['createdDateUTC'] = this.createdDateUTC;
    data['isAutoSchedulable'] = this.isAutoSchedulable;
    data['autoSchedulableText'] = this.autoSchedulableText;
    data['active'] = this.active;
    data['propertyDevStageId'] = this.propertyDevStageId;
    data['propertyDevStageName'] = this.propertyDevStageName;
    return data;
  }
}
