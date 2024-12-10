class ActivitySchedulerParamsListModel {
  bool? status;
  String? message;
  List<SchedulerParams>? data;
  Null? meta;

  ActivitySchedulerParamsListModel(
      {this.status, this.message, this.data, this.meta});

  ActivitySchedulerParamsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SchedulerParams>[];
      json['data'].forEach((v) {
        data!.add(new SchedulerParams.fromJson(v));
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

class SchedulerParams {
  String? paramName;
  String? paramCode;
  String? description;
  int? dayValue;
  int? monthValue;

  SchedulerParams(
      {this.paramName,
      this.paramCode,
      this.description,
      this.dayValue,
      this.monthValue});

  SchedulerParams.fromJson(Map<String, dynamic> json) {
    paramName = json['paramName'];
    paramCode = json['paramCode'];
    description = json['description'];
    dayValue = json['dayValue'];
    monthValue = json['monthValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paramName'] = this.paramName;
    data['paramCode'] = this.paramCode;
    data['description'] = this.description;
    data['dayValue'] = this.dayValue;
    data['monthValue'] = this.monthValue;
    return data;
  }
}
