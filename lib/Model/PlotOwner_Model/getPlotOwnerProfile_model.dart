class GetPlotOwnerProfileDetailsModel {
  bool? status;
  String? message;
  Data? data;

  GetPlotOwnerProfileDetailsModel({this.status, this.message, this.data});

  GetPlotOwnerProfileDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? userFullname;
  String? userEmail;
  int? userMobile;
  Null? userMobileIsdCode;
  String? createdDateUtc;

  Data(
      {this.id,
      this.userFullname,
      this.userEmail,
      this.userMobile,
      this.userMobileIsdCode,
      this.createdDateUtc});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userFullname = json['userFullname'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    userMobileIsdCode = json['userMobileIsdCode'];
    createdDateUtc = json['createdDateUtc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userFullname'] = this.userFullname;
    data['userEmail'] = this.userEmail;
    data['userMobile'] = this.userMobile;
    data['userMobileIsdCode'] = this.userMobileIsdCode;
    data['createdDateUtc'] = this.createdDateUtc;
    return data;
  }
}
