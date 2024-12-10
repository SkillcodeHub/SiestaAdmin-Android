class GetUsersListModel {
  bool? status;
  String? message;
  List<User>? data;
  Null? meta;

  GetUsersListModel({this.status, this.message, this.data, this.meta});

  GetUsersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <User>[];
      json['data'].forEach((v) {
        data!.add(new User.fromJson(v));
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

class User {
  int? id;
  String? userFullname;
  String? userEmail;
  int? userMobile;
  String? userMobileIsdCode;
  int? organizationId;
  String? createdDateUTC;
  Null? createdUserId;
  String? registerationMode;
  String? comments;
  int? active;
  List<String>? authRole;
  String? dashboardType;
  int? plotOwnership;

  User({
    this.id,
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
    this.plotOwnership,
  });

  User.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userFullname'] = userFullname;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['userMobileIsdCode'] = userMobileIsdCode;
    data['organizationId'] = organizationId;
    data['createdDateUTC'] = createdDateUTC;
    data['createdUserId'] = createdUserId;
    data['registerationMode'] = registerationMode;
    data['comments'] = comments;
    data['active'] = active;
    data['authRole'] = authRole;
    data['dashboardType'] = dashboardType;
    data['plotOwnership'] = plotOwnership;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! User) return false;
    final User otherUser = other;
    return id == otherUser.id;
  }

  @override
  int get hashCode => id.hashCode;
}
