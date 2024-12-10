class GetAssetsTypesListModel {
  bool? status;
  String? message;
  List<AssetsTypes>? data;
  Null? meta;

  GetAssetsTypesListModel({this.status, this.message, this.data, this.meta});

  GetAssetsTypesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AssetsTypes>[];
      json['data'].forEach((v) {
        data!.add(new AssetsTypes.fromJson(v));
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

class AssetsTypes {
  String? code;
  String? name;

  AssetsTypes({this.code, this.name});

  AssetsTypes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['Name'] = name;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AssetsTypes) return false;
    final AssetsTypes otherAssetsTypes = other;
    return code == otherAssetsTypes.code && name == otherAssetsTypes.name;
  }

  @override
  int get hashCode => code.hashCode ^ name.hashCode;
}
