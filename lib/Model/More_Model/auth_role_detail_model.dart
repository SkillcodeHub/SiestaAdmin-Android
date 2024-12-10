class AuthRoleDetailsModel {
  bool? status;
  String? message;
  AuthRoleDetails? data;
  Modules? modules;

  AuthRoleDetailsModel({this.status, this.message, this.data, this.modules});

  AuthRoleDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new AuthRoleDetails.fromJson(json['data'])
        : null;
    modules =
        json['modules'] != null ? new Modules.fromJson(json['modules']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.modules != null) {
      data['modules'] = this.modules!.toJson();
    }
    return data;
  }
}

class AuthRoleDetails {
  String? roleCode;
  String? roleName;
  dynamic roleNameTranslation;
  dynamic roleDescriptionTranslation;
  List<String>? canRead;
  List<String>? canAdd;
  List<String>? canUpdate;
  dynamic translation;
  String? dashboardCode;
  int? isActive;

  AuthRoleDetails(
      {this.roleCode,
      this.roleName,
      this.roleNameTranslation,
      this.roleDescriptionTranslation,
      this.canRead,
      this.canAdd,
      this.canUpdate,
      this.translation,
      this.dashboardCode,
      this.isActive});

  AuthRoleDetails.fromJson(Map<String, dynamic> json) {
    roleCode = json['roleCode'];
    roleName = json['roleName'];
    roleNameTranslation = json['roleNameTranslation'];
    roleDescriptionTranslation = json['roleDescriptionTranslation'];
    canRead = json['canRead'].cast<String>();
    canAdd = json['canAdd'].cast<String>();
    canUpdate = json['canUpdate'].cast<String>();
    translation = json['translation'];
    dashboardCode = json['dashboardCode'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleCode'] = this.roleCode;
    data['roleName'] = this.roleName;
    data['roleNameTranslation'] = this.roleNameTranslation;
    data['roleDescriptionTranslation'] = this.roleDescriptionTranslation;
    data['canRead'] = this.canRead;
    data['canAdd'] = this.canAdd;
    data['canUpdate'] = this.canUpdate;
    data['translation'] = this.translation;
    data['dashboardCode'] = this.dashboardCode;
    data['isActive'] = this.isActive;
    return data;
  }
}

class Modules {
  int? fieldCount;
  int? affectedRows;
  int? insertId;
  String? info;
  int? serverStatus;
  int? warningStatus;

  Modules(
      {this.fieldCount,
      this.affectedRows,
      this.insertId,
      this.info,
      this.serverStatus,
      this.warningStatus});

  Modules.fromJson(Map<String, dynamic> json) {
    fieldCount = json['fieldCount'];
    affectedRows = json['affectedRows'];
    insertId = json['insertId'];
    info = json['info'];
    serverStatus = json['serverStatus'];
    warningStatus = json['warningStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldCount'] = this.fieldCount;
    data['affectedRows'] = this.affectedRows;
    data['insertId'] = this.insertId;
    data['info'] = this.info;
    data['serverStatus'] = this.serverStatus;
    data['warningStatus'] = this.warningStatus;
    return data;
  }
}
