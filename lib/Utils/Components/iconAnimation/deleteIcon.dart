import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class DeleteIconWidget extends StatelessWidget {
  const DeleteIconWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      child: Lottie.asset('images/deleteLogo.json',
          reverse: false, repeat: false, fit: BoxFit.cover),
    );
  }
}
