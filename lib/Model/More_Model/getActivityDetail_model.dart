class ActivityDetailModel {
  bool? status;
  String? message;
  ActivityDetail? data;

  ActivityDetailModel({this.status, this.message, this.data});

  ActivityDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new ActivityDetail.fromJson(json['data']) : null;
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

class ActivityDetail {
  int? activityId;
  String? activityName;
  String? activityDescription;
  String? activityNameTranslation;
  String? activityDescriptionTranslation;
  int? maxSkipTimeoutDays;
  dynamic translation;
  int? isImageRequired;
  Null? activityImageId;
  Null? activityThumbnailId;
  int? organizationId;
  String? createdDateUTC;
  Null? comments;
  int? active;

  ActivityDetail(
      {this.activityId,
      this.activityName,
      this.activityDescription,
      this.activityNameTranslation,
      this.activityDescriptionTranslation,
      this.maxSkipTimeoutDays,
      this.translation,
      this.isImageRequired,
      this.activityImageId,
      this.activityThumbnailId,
      this.organizationId,
      this.createdDateUTC,
      this.comments,
      this.active});

  ActivityDetail.fromJson(Map<String, dynamic> json) {
    activityId = json['activityId'];
    activityName = json['activityName'];
    activityDescription = json['activityDescription'];
    activityNameTranslation = json['activityNameTranslation'];
    activityDescriptionTranslation = json['activityDescriptionTranslation'];
    maxSkipTimeoutDays = json['maxSkipTimeoutDays'];
    translation = json['translation'];
    // != null
    //     ? new Translation.fromJson(json['translation'])
    //     : null;
    isImageRequired = json['isImageRequired'];
    activityImageId = json['activityImageId'];
    activityThumbnailId = json['activityThumbnailId'];
    organizationId = json['organizationId'];
    createdDateUTC = json['createdDateUTC'];
    comments = json['comments'];
    active = json['active'];
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
    data['translation'] = this.translation;

    // if (this.translation != null) {
    //   data['translation'] = this.translation!.toJson();
    // }
    data['isImageRequired'] = this.isImageRequired;
    data['activityImageId'] = this.activityImageId;
    data['activityThumbnailId'] = this.activityThumbnailId;
    data['organizationId'] = this.organizationId;
    data['createdDateUTC'] = this.createdDateUTC;
    data['comments'] = this.comments;
    data['active'] = this.active;
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
