class LanguageListModel {
  bool? status;
  String? message;
  List<Language>? data;
  Null? meta;

  LanguageListModel({this.status, this.message, this.data, this.meta});

  LanguageListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Language>[];
      json['data'].forEach((v) {
        data!.add(new Language.fromJson(v));
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

class Language {
  String? name;
  String? languageCode;
  int? isActive;

  Language({this.name, this.languageCode, this.isActive});

  Language.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    languageCode = json['languageCode'];
    isActive = json['isActive'];
  }
    factory Language.fromSnapshot(snapshot) => Language(
        name: snapshot["name"],
        isActive: snapshot["isActive"],
        languageCode: snapshot["languageCode"],
      );


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['languageCode'] = this.languageCode;
    data['isActive'] = this.isActive;
    return data;
  }
}
