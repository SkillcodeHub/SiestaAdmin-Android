import 'package:equatable/equatable.dart';

class ActivityTranslation extends Equatable {
  String? title;
  String? desc;
  String? languageCode;

  ActivityTranslation({
    this.title,
    this.desc,
    this.languageCode,
  });

  ActivityTranslation copyWith({
    String? title,
    String? desc,
    String? languageCode,
  }) =>
      ActivityTranslation(
        title: title ?? this.title,
        desc: desc ?? this.desc,
        languageCode: languageCode ?? this.languageCode,
      );

  factory ActivityTranslation.fromJson(Map<String, dynamic> json) =>
      ActivityTranslation(
        title: json["title"],
        desc: json["desc"],
        languageCode: json["languageCode"],
      );

  Map<String, dynamic> toJson() => {
        "translation": title,
        "description": desc,
        "languageCode": languageCode,
      };

  @override
  List<Object> get props => [
        this.title!,
        this.desc!,
        this.languageCode!,
      ];
}
