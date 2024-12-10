class SchedulerPendingActivityItemListModel {
  bool? status;
  String? message;
  List<PendingActivity>? data;
  Null? meta;

  SchedulerPendingActivityItemListModel(
      {this.status, this.message, this.data, this.meta});

  SchedulerPendingActivityItemListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PendingActivity>[];
      json['data'].forEach((v) {
        data!.add(new PendingActivity.fromJson(v));
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

class PendingActivity {
  int? activityId;
  String? activityName;
  String? activityDescription;
  String? activityNameTranslation;
  String? activityDescriptionTranslation;

  PendingActivity(
      {this.activityId,
      this.activityName,
      this.activityDescription,
      this.activityNameTranslation,
      this.activityDescriptionTranslation});

  PendingActivity.fromJson(Map<String, dynamic> json) {
    activityId = json['activityId'];
    activityName = json['activityName'];
    activityDescription = json['activityDescription'];
    activityNameTranslation = json['activityNameTranslation'];
    activityDescriptionTranslation = json['activityDescriptionTranslation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
    data['activityDescription'] = this.activityDescription;
    data['activityNameTranslation'] = this.activityNameTranslation;
    data['activityDescriptionTranslation'] =
        this.activityDescriptionTranslation;
    return data;
  }
}
