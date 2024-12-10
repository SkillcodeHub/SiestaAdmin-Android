import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RefreshScreenWidget extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final String noDataText;

  RefreshScreenWidget({
    required this.onRefresh,
    required this.noDataText,
  });

  @override
  State<RefreshScreenWidget> createState() => _RefreshScreenWidgetState();
}

class _RefreshScreenWidgetState extends State<RefreshScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
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
                    Text(
                      'Swipe down to refresh page',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                            ? 14.sp
                            : 12.sp,
                        color: Color(0XFF545454),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Center(
                      child: Image.asset(
                        'images/result_not_found.png',
                        height: 20.h,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Center(
                      child: Text(
                        widget.noDataText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 14.sp
                              : 12.sp,
                          color: Color(0XFF545454),
                          fontWeight: FontWeight.w600,
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
