import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => userSettings()));
          // Navigator.pushNamed(context, RoutesName.settings);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => BookApointmentScreen()));
        },
        child: CircleAvatar(
          backgroundImage: AssetImage('images/doctor.png'),
        ));
  }
}
