import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ErrorScreenWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final String loadingText;

  ErrorScreenWidget({
    required this.onRefresh,
    required this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 74.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Image.asset(
                        'asset/images/loading.png',
                        height: 20.h,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Center(
                      child: Text(
                        loadingText,
                        style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 14.sp
                              : 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
