import 'package:flutter/material.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/spining_lines.dart';

class LoaderWidget extends StatelessWidget {
  final double? size;

  LoaderWidget({this.size});

  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(color: primaryColor, size: size ?? 70);
  }
}
