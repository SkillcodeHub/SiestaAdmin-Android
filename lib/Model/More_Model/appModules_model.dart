class AppModulesModel {
  bool? status;
  String? message;
  List<AppModule>? data;
  Null? meta;

  AppModulesModel({this.status, this.message, this.data, this.meta});

  AppModulesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AppModule>[];
      json['data'].forEach((v) {
        data!.add(new AppModule.fromJson(v));
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

class AppModule {
  String? moduleCode;
  String? moduleName;
  String? moduleDescription;
  String? comment;
  int? organizationId;
  int? isActive;

  AppModule(
      {this.moduleCode,
      this.moduleName,
      this.moduleDescription,
      this.comment,
      this.organizationId,
      this.isActive});

  AppModule.fromJson(Map<String, dynamic> json) {
    moduleCode = json['moduleCode'];
    moduleName = json['moduleName'];
    moduleDescription = json['moduleDescription'];
    comment = json['comment'];
    organizationId = json['organizationId'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['moduleCode'] = this.moduleCode;
    data['moduleName'] = this.moduleName;
    data['moduleDescription'] = this.moduleDescription;
    data['comment'] = this.comment;
    data['organizationId'] = this.organizationId;
    data['isActive'] = this.isActive;
    return data;
  }
}
