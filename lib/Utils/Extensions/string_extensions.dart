import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:siestaamsapp/Res/colors.dart';

extension StExt on String {
  String getFormattedDate(String format) {
    return DateFormat(format).format(DateTime.parse(this));
  }

  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (appSecondaryColor),
      errorBuilder: (context, error, stackTrace) {
        return PlaceHolderWidget();
      },
    );
  }
}
