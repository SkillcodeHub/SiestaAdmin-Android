class GetAssetsDetailsListModel {
  bool? status;
  String? message;
  AssetsDetails? data;

  GetAssetsDetailsListModel({this.status, this.message, this.data});

  GetAssetsDetailsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new AssetsDetails.fromJson(json['data']) : null;
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

class AssetsDetails {
  int? id;
  String? propertyNumber;
  String? propertyName;
  dynamic propertyNameTranslation;
  dynamic propertyDescriptionTranslation;
  String? propertyTypeCode;
  String? propertyTypeName;
  dynamic description;
  dynamic ownerId;
  dynamic ownerName;
  dynamic mergedPropertyId;
  dynamic propertyArea;
  dynamic propertyDevStageId;
  dynamic propertyDevStageName;
  dynamic translation;
  int? organizationId;
  String? createdDateUTC;
  dynamic comments;
  int? isActive;

  AssetsDetails(
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
      this.organizationId,
      this.createdDateUTC,
      this.comments,
      this.isActive});

  AssetsDetails.fromJson(Map<String, dynamic> json) {
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
    translation = json['translation'];
    organizationId = json['organizationId'];
    createdDateUTC = json['createdDateUTC'];
    comments = json['comments'];
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
    data['translation'] = this.translation;
    data['organizationId'] = this.organizationId;
    data['createdDateUTC'] = this.createdDateUTC;
    data['comments'] = this.comments;
    data['isActive'] = this.isActive;
    return data;
  }
}
