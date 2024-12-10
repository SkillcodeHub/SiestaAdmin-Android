import 'package:equatable/equatable.dart';

class ListItem<T> extends Equatable {
  bool isSelected = false;
  T data;

  ListItem(
    this.data, {
    required this.isSelected,
  });

  @override
  List<Object?> get props => [this.isSelected, this.data];
}
