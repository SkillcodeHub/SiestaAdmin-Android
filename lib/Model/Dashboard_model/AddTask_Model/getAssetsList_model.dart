class GetAssetsListModel {
  bool? status;
  String? message;
  List<Assets>? data;
  Null? meta;

  GetAssetsListModel({this.status, this.message, this.data, this.meta});

  GetAssetsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Assets>[];
      json['data'].forEach((v) {
        data!.add(new Assets.fromJson(v));
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

class Assets {
  int? id;
  String? propertyNumber;
  String? propertyName;
  String? propertyNameTranslation;
  String? propertyDescriptionTranslation;
  String? propertyTypeCode;
  String? propertyTypeName;
  Null? description;
  int? ownerId;
  String? ownerName;
  int? mergedPropertyId;
  Null? propertyArea;
  Null? propertyDevStageId;
  Null? propertyDevStageName;
  Translation? translation;
  Null? comments;
  int? organizationId;
  String? createdDateUTC;
  int? isActive;

  Assets(
      {this.id,
      this.propertyNumber,
      this.propertyName,
      this.propertyNameTranslation,
      this.propertyDescriptionTranslation,
      this.propertyTypeCode,
      this.propertyTypeName,
      this.description,
      this.ownerId,
      this.ownerName,
      this.mergedPropertyId,
      this.propertyArea,
      this.propertyDevStageId,
      this.propertyDevStageName,
      this.translation,
      this.comments,
      this.organizationId,
      this.createdDateUTC,
      this.isActive});

  Assets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyNumber = json['propertyNumber'];
    propertyName = json['propertyName'];
    propertyNameTranslation = json['propertyNameTranslation'];
    propertyDescriptionTranslation = json['propertyDescriptionTranslation'];
    propertyTypeCode = json['propertyTypeCode'];
    propertyTypeName = json['propertyTypeName'];
    description = json['description'];
    ownerId = json['ownerId'];
    ownerName = json['ownerName'];
    mergedPropertyId = json['mergedPropertyId'];
    propertyArea = json['propertyArea'];
    propertyDevStageId = json['propertyDevStageId'];
    propertyDevStageName = json['propertyDevStageName'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
    comments = json['comments'];
    organizationId = json['organizationId'];
    createdDateUTC = json['createdDateUTC'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['propertyNumber'] = this.propertyNumber;
    data['propertyName'] = this.propertyName;
    data['propertyNameTranslation'] = this.propertyNameTranslation;
    data['propertyDescriptionTranslation'] =
        this.propertyDescriptionTranslation;
    data['propertyTypeCode'] = this.propertyTypeCode;
    data['propertyTypeName'] = this.propertyTypeName;
    data['description'] = this.description;
    data['ownerId'] = this.ownerId;
    data['ownerName'] = this.ownerName;
    data['mergedPropertyId'] = this.mergedPropertyId;
    data['propertyArea'] = this.propertyArea;
    data['propertyDevStageId'] = this.propertyDevStageId;
    data['propertyDevStageName'] = this.propertyDevStageName;
    if (this.translation != null) {
      data['translation'] = this.translation!.toJson();
    }
    data['comments'] = this.comments;
    data['organizationId'] = this.organizationId;
    data['createdDateUTC'] = this.createdDateUTC;
    data['isActive'] = this.isActive;
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
