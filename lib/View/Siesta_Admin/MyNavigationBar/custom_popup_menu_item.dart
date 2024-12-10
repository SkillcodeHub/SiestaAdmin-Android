import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class CustomPopupMenuItem extends Equatable {
  final String title;
  final IconData icon;
  final VoidCallback? action;

  CustomPopupMenuItem({
    required this.title,
    required this.icon,
    this.action,
  });

  @override
  List<Object> get props => [title];
}
