import 'package:flutter/material.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:sizer/sizer.dart';

class LoaderContainerWidget extends StatelessWidget {
  const LoaderContainerWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(appPrimaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Container(
              height: 3.h,
              width: 3.h,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            )),
      ),
    );
  }
}
