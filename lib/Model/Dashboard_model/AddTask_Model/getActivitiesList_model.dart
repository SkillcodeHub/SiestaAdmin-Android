class GetActivitiesListModel {
  bool? status;
  String? message;
  List<Activities>? data;
  Null? meta;

  GetActivitiesListModel({this.status, this.message, this.data, this.meta});

  GetActivitiesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Activities>[];
      json['data'].forEach((v) {
        data!.add(new Activities.fromJson(v));
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

class Activities {
  int? activityId;
  String? activityName;
  String? activityDescription;
  String? activityNameTranslation;
  String? activityDescriptionTranslation;
  int? maxSkipTimeoutDays;
  int? isImageRequired;
  Translation? translation;
  Null? activityImageId;
  Null? activityThumbnailId;
  int? organizationId;
  String? createdDateUTC;
  Null? comments;
  int? active;

  // Additional attributes from GetActivitySchedulersListModel
  int? schedulerId;
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
  int? isAutoSchedulable;
  String? autoSchedulableText;

  Activities({
    this.activityId,
    this.activityName,
    this.activityDescription,
    this.activityNameTranslation,
    this.activityDescriptionTranslation,
    this.maxSkipTimeoutDays,
    this.isImageRequired,
    this.translation,
    this.activityImageId,
    this.activityThumbnailId,
    this.organizationId,
    this.createdDateUTC,
    this.comments,
    this.active,
    // Additional attributes from GetActivitySchedulersListModel
    this.schedulerId,
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
    this.isAutoSchedulable,
    this.autoSchedulableText,
  });

  Activities.fromJson(Map<String, dynamic> json) {
    activityId = json['activityId'];
    activityName = json['activityName'];
    activityDescription = json['activityDescription'];
    activityNameTranslation = json['activityNameTranslation'];
    activityDescriptionTranslation = json['activityDescriptionTranslation'];
    maxSkipTimeoutDays = json['maxSkipTimeoutDays'];
    isImageRequired = json['isImageRequired'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
    activityImageId = json['activityImageId'];
    activityThumbnailId = json['activityThumbnailId'];
    organizationId = json['organizationId'];
    createdDateUTC = json['createdDateUTC'];
    comments = json['comments'];
    active = json['active'];
    // Additional attributes from GetActivitySchedulersListModel
    schedulerId = json['schedulerId'];
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
    isAutoSchedulable = json['isAutoSchedulable'];
    autoSchedulableText = json['autoSchedulableText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
    data['activityDescription'] = this.activityDescription;
    data['activityNameTranslation'] = this.activityNameTranslation;
    data['activityDescriptionTranslation'] =
        this.activityDescriptionTranslation;
    data['maxSkipTimeoutDays'] = this.maxSkipTimeoutDays;
    data['isImageRequired'] = this.isImageRequired;
    if (this.translation != null) {
      data['translation'] = this.translation!.toJson();
    }
    data['activityImageId'] = this.activityImageId;
    data['activityThumbnailId'] = this.activityThumbnailId;
    data['organizationId'] = this.organizationId;
    data['createdDateUTC'] = this.createdDateUTC;
    data['comments'] = this.comments;
    data['active'] = this.active;
    // Additional attributes from GetActivitySchedulersListModel
    data['schedulerId'] = this.schedulerId;
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
    data['isAutoSchedulable'] = this.isAutoSchedulable;
    data['autoSchedulableText'] = this.autoSchedulableText;
    return data;
  }
}

class Translation {
  Eng? eng;
  Eng? guj;

  Translation({this.eng, this.guj});

  Translation.fromJson(Map<String, dynamic> json) {
    eng = json['eng'] != null ? new Eng.fromJson(json['eng']) : null;
    guj = json['guj'] != null ? new Eng.fromJson(json['guj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eng != null) {
      data['eng'] = this.eng!.toJson();
    }
    if (this.guj != null) {
      data['guj'] = this.guj!.toJson();
    }
    return data;
  }
}

class Eng {
  String? desc;
  String? title;

  Eng({this.desc, this.title});

  Eng.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['title'] = this.title;
    return data;
  }
}
