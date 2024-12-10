class ActivityGroup {
  bool? status;
  String? message;
  List<ActivityGroups>? data;
  Null? meta;

  ActivityGroup({this.status, this.message, this.data, this.meta});

  ActivityGroup.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ActivityGroups>[];
      json['data'].forEach((v) {
        data!.add(new ActivityGroups.fromJson(v));
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

class ActivityGroups {
  String? code;
  String? name;
  int? priority;

  ActivityGroups({this.code, this.name, this.priority});

  ActivityGroups.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['priority'] = this.priority;
    return data;
  }
}
