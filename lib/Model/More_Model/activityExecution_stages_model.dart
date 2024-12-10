class ActivityExecutionStagesListModel {
  bool? status;
  String? message;
  List<ActivityExecutionStage>? data;
  Null? meta;

  ActivityExecutionStagesListModel(
      {this.status, this.message, this.data, this.meta});

  ActivityExecutionStagesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ActivityExecutionStage>[];
      json['data'].forEach((v) {
        data!.add(new ActivityExecutionStage.fromJson(v));
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

class ActivityExecutionStage {
  String? stageCode;
  String? stageName;
  String? stageNameTranslation;
  dynamic stageDescriptionTranslation;
  int? organizationId;
  Translation? translation;
  String? createdDateUTC;
  dynamic createdBy;
  int? autoRemoveByScheduler;

  ActivityExecutionStage(
      {this.stageCode,
      this.stageName,
      this.stageNameTranslation,
      this.stageDescriptionTranslation,
      this.organizationId,
      this.translation,
      this.createdDateUTC,
      this.createdBy,
      this.autoRemoveByScheduler});

  ActivityExecutionStage.fromJson(Map<String, dynamic> json) {
    stageCode = json['stageCode'];
    stageName = json['stageName'];
    stageNameTranslation = json['stageNameTranslation'];
    stageDescriptionTranslation = json['stageDescriptionTranslation'];
    organizationId = json['organizationId'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
    createdDateUTC = json['createdDateUTC'];
    createdBy = json['createdBy'];
    autoRemoveByScheduler = json['autoRemoveByScheduler'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stageCode'] = this.stageCode;
    data['stageName'] = this.stageName;
    data['stageNameTranslation'] = this.stageNameTranslation;
    data['stageDescriptionTranslation'] = this.stageDescriptionTranslation;
    data['organizationId'] = this.organizationId;
    if (this.translation != null) {
      data['translation'] = this.translation!.toJson();
    }
    data['createdDateUTC'] = this.createdDateUTC;
    data['createdBy'] = this.createdBy;
    data['autoRemoveByScheduler'] = this.autoRemoveByScheduler;
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
