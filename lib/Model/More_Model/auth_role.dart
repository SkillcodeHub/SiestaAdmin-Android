class AuthRoleModel {
  bool? status;
  String? message;
  List<AuthRole>? data;
  dynamic meta;

  AuthRoleModel({this.status, this.message, this.data, this.meta});

  AuthRoleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AuthRole>[];
      json['data'].forEach((v) {
        data!.add(new AuthRole.fromJson(v));
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

class AuthRole {
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

  AuthRole(
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

  AuthRole.fromJson(Map<String, dynamic> json) {
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
