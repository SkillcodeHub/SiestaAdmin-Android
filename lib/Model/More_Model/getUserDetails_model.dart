class GetUserDetailsModel {
  bool? status;
  String? message;
  UserDetails? data;

  GetUserDetailsModel({this.status, this.message, this.data});

  GetUserDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new UserDetails.fromJson(json['data']) : null;
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

class UserDetails {
  int? id;
  String? userFullname;
  dynamic userEmail;
  int? userMobile;
  dynamic userMobileIsdCode;
  int? organizationId;
  String? createdDateUTC;
  dynamic createdUserId;
  String? registerationMode;
  dynamic comments;
  int? active;
  List<String>? authRole;
  String? dashboardType;
  int? plotOwnership;

  UserDetails(
      {this.id,
      this.userFullname,
      this.userEmail,
      this.userMobile,
      this.userMobileIsdCode,
      this.organizationId,
      this.createdDateUTC,
      this.createdUserId,
      this.registerationMode,
      this.comments,
      this.active,
      this.authRole,
      this.dashboardType,
      this.plotOwnership});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userFullname = json['userFullname'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    userMobileIsdCode = json['userMobileIsdCode'];
    organizationId = json['organizationId'];
    createdDateUTC = json['createdDateUTC'];
    createdUserId = json['createdUserId'];
    registerationMode = json['registerationMode'];
    comments = json['comments'];
    active = json['active'];
    authRole = json['authRole']?.cast<String>();
    dashboardType = json['dashboardType'];
    plotOwnership = json['plotOwnership'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userFullname'] = this.userFullname;
    data['userEmail'] = this.userEmail;
    data['userMobile'] = this.userMobile;
    data['userMobileIsdCode'] = this.userMobileIsdCode;
    data['organizationId'] = this.organizationId;
    data['createdDateUTC'] = this.createdDateUTC;
    data['createdUserId'] = this.createdUserId;
    data['registerationMode'] = this.registerationMode;
    data['comments'] = this.comments;
    data['active'] = this.active;
    data['authRole'] = this.authRole;
    data['dashboardType'] = this.dashboardType;
    data['plotOwnership'] = this.plotOwnership;
    return data;
  }
}
