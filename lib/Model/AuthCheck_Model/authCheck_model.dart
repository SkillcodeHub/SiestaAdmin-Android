class AuthCheckModel {
  bool? status;
  String? message;
  Data? data;

  AuthCheckModel({this.status, this.message, this.data});

  AuthCheckModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? token;
  String? dashboardTypeCode;
  String? dashboardTypeName;
  List<String>? authRole;
  List<String>? canRead;
  List<String>? canAdd;
  List<String>? canUpdate;

  Data(
      {this.token,
      this.dashboardTypeCode,
      this.dashboardTypeName,
      this.authRole,
      this.canRead,
      this.canAdd,
      this.canUpdate});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    dashboardTypeCode = json['dashboardTypeCode'];
    dashboardTypeName = json['dashboardTypeName'];
    authRole = json['authRole'].cast<String>();
    canRead = json['canRead'].cast<String>();
    canAdd = json['canAdd'].cast<String>();
    canUpdate = json['canUpdate'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['dashboardTypeCode'] = this.dashboardTypeCode;
    data['dashboardTypeName'] = this.dashboardTypeName;
    data['authRole'] = this.authRole;
    data['canRead'] = this.canRead;
    data['canAdd'] = this.canAdd;
    data['canUpdate'] = this.canUpdate;
    return data;
  }
}
