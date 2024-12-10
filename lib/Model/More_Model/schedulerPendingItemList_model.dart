class SchedulerPendingItemListModel {
  bool? status;
  String? message;
  List<Property>? data;
  Null? meta;

  SchedulerPendingItemListModel(
      {this.status, this.message, this.data, this.meta});

  SchedulerPendingItemListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Property>[];
      json['data'].forEach((v) {
        data!.add(new Property.fromJson(v));
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

class Property {
  int? id;
  String? propertyName;
  String? propertyNumber;
  String? propertyTypeCode;
  String? propertyTypeName;
  String? description;
  num? mergedPropertyId;
  String? propertyArea;
  num? propertyDevStageId;
  String? propertyDevStageName;
  String? comments;
  num? organizationId;
  String? createdDateUtc;
  num? isActive;
  num? ownerId;
  String? ownerName;
  dynamic translation;
  String? propertyDescriptionTranslation;
  String? propertyNameTranslation;

  Property({
    this.id,
    this.propertyNumber,
    this.propertyName,
    this.propertyTypeCode,
    this.propertyTypeName,
    this.description,
    this.mergedPropertyId,
    this.propertyArea,
    this.propertyDevStageId,
    this.propertyDevStageName,
    this.comments,
    this.organizationId,
    this.createdDateUtc,
    this.isActive,
    this.ownerId,
    this.ownerName,
    this.translation,
    this.propertyDescriptionTranslation,
    this.propertyNameTranslation,
  });

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyName = json['propertyName'];
    propertyNumber = json["propertyNumber"];
    propertyTypeCode = json["propertyTypeCode"];
    propertyTypeName = json["propertyTypeName"];
    description = json["description"];
    mergedPropertyId = json["mergedPropertyId"];
    propertyArea = json["propertyArea"];
    propertyDevStageId = json["propertyDevStageId"];
    propertyDevStageName = json["propertyDevStageName"];
    comments = json["comments"];
    organizationId = json["organizationId"];
    createdDateUtc = json["createdDateUTC"];
    isActive = json["isActive"];
    ownerId = json["ownerId"];
    ownerName = json["ownerName"];
    translation = json["translation"];
    propertyDescriptionTranslation = json["propertyDescriptionTranslation"];
    propertyNameTranslation = json['propertyNameTranslation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['propertyName'] = this.propertyName;
    data["propertyNumber"] = this.propertyNumber;
    data["propertyTypeCode"] = this.propertyTypeCode;
    data["propertyTypeName"] = this.propertyTypeName;
    data["description"] = this.description;
    data["mergedPropertyId"] = this.mergedPropertyId;
    data["propertyArea"] = this.propertyArea;
    data["propertyDevStageId"] = this.propertyDevStageId;
    data["propertyDevStageName"] = this.propertyDevStageName;
    data["comments"] = this.comments;
    data["organizationId"] = this.organizationId;
    data["createdDateUTC"] = this.createdDateUtc;
    data["isActive"] = this.isActive;
    data["ownerId"] = this.ownerId;
    data["ownerName"] = this.ownerName;
    data["translation"] = this.translation;
    data["propertyDescriptionTranslation"] =
        this.propertyDescriptionTranslation;
    data['propertyNameTranslation'] = this.propertyNameTranslation;
    return data;
  }
}
