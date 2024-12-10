import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class SuccessIconWidget extends StatelessWidget {
  const SuccessIconWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      child: Lottie.asset('images/success.json',
          reverse: false, repeat: false, fit: BoxFit.cover),
    );
  }
}
