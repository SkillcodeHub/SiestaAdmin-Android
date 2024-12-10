import 'package:equatable/equatable.dart';

class SelectableDay extends Equatable {
  final String name;
  final num dayValue;
  final bool isSelected;

  SelectableDay({
    required this.name,
    required this.dayValue,
    required this.isSelected,
  });

  @override
  List<Object> get props => [
        name,
        dayValue,
        isSelected,
      ];

  SelectableDay copyWith({
    num? dayValue,
    String? name,
    bool? isSelected,
  }) =>
      SelectableDay(
        dayValue: dayValue ?? this.dayValue,
        name: name ?? this.name,
        isSelected: isSelected ?? this.isSelected,
      );

  factory SelectableDay.fromJson(Map<String, dynamic> json) => SelectableDay(
        dayValue: json["dayValue"],
        name: json["name"],
        isSelected: json["isSelected"],
      );

  Map<String, dynamic> toJson() => {
        "dayValue": dayValue,
        "name": name,
        "isSelected": isSelected,
      };
}
