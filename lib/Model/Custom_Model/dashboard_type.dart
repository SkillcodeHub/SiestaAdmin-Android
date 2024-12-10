class DashboardTypeModel {
  bool? status;
  String? message;
  List<DashboardType>? data;
  Null? meta;

  DashboardTypeModel({this.status, this.message, this.data, this.meta});

  DashboardTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DashboardType>[];
      json['data'].forEach((v) {
        data!.add(new DashboardType.fromJson(v));
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

class DashboardType {
  String? code;
  String? name;
  int? isActive;

  DashboardType({this.code, this.name, this.isActive});

  DashboardType.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['Name'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['Name'] = this.name;
    data['isActive'] = this.isActive;
    return data;
  }
}
