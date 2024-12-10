class PriorityTaskModel {
  bool? status;
  String? message;
  List<PriorityTask>? data;
  Null? meta;

  PriorityTaskModel({this.status, this.message, this.data, this.meta});

  PriorityTaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PriorityTask>[];
      json['data'].forEach((v) {
        data!.add(new PriorityTask.fromJson(v));
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

class PriorityTask {
  int? totalCount;
  String? executionStageCode;
  Translation? translation;
  String? executionStageName;
  String? groupName;

  PriorityTask(
      {this.totalCount,
      this.executionStageCode,
      this.translation,
      this.executionStageName,
      this.groupName});

  PriorityTask.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    executionStageCode = json['executionStageCode'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
    executionStageName = json['executionStageName'];
    groupName = json['groupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['executionStageCode'] = this.executionStageCode;
    if (this.translation != null) {
      data['translation'] = this.translation!.toJson();
    }
    data['executionStageName'] = this.executionStageName;
    data['groupName'] = this.groupName;
    return data;
  }
}

class Translation {
  Eng? eng;
  Eng? guj;

  Translation({this.eng, this.guj});

  Translation.fromJson(Map<String, dynamic> json) {
    eng = json['eng'] != null ? new Eng.fromJson(json['eng']) : null;
    guj = json['guj'] != null ? new Eng.fromJson(json['guj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eng != null) {
      data['eng'] = this.eng!.toJson();
    }
    if (this.guj != null) {
      data['guj'] = this.guj!.toJson();
    }
    return data;
  }
}

class Eng {
  String? desc;
  String? title;

  Eng({this.desc, this.title});

  Eng.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['title'] = this.title;
    return data;
  }
}
