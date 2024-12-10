import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AxonIconForAppBarrWidget extends StatelessWidget {
  const AxonIconForAppBarrWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizerUtil.deviceType == DeviceType.mobile
        ? Container(
            margin: EdgeInsets.only(top: 5),
            height: 6.h,
            // width: MediaQuery.of(context).size.width * 0.10,
            width: 10.w,
            child: Image.asset('images/axon-icon.png'),
          )
        : Container(
            // margin: EdgeInsets.only(top: 5),
            height: 3.5.h,
            // width: MediaQuery.of(context).size.width * 0.10,
            width: 10.w,
            child: Image.asset(
              'images/axon-icon.png',
              fit: BoxFit.contain,
            ),
          );
  }
}
