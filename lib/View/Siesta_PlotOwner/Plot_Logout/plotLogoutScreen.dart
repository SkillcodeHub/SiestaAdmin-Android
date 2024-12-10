import 'package:flutter/material.dart';

import '../../../constants/string_res.dart';

class PlotLogoutScreen extends StatefulWidget {
  const PlotLogoutScreen({super.key});

  @override
  State<PlotLogoutScreen> createState() => _PlotLogoutScreenState();
}

class _PlotLogoutScreenState extends State<PlotLogoutScreen> {
  @override
  void initState() {
    super.initState();
    // Show dialog after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLogoutDialog();
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppString.get(context).confirm(),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(AppString.get(context).areYouSureWantToLogout()),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppString.get(context).cancel(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                AppString.get(context).logout(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _handleLogout();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    // PackageInfo.fromPlatform().then((value) {
    //   switch (value.packageName) {
    //     case "com.axon.siesta_ams.admin":
    //       Provider.of<AuthStateProvider>(context, listen: false)
    //           .logoutUser()
    //           .whenComplete(() {
    //         Navigator.of(context).pushNamedAndRemoveUntil(
    //             HomePageAdmin.routeName, (dynamic) => false);
    //       });
    //       break;
    //     case "com.axon.siesta_ams.member":
    //       Provider.of<AuthStateProvider>(context, listen: false)
    //           .logoutUser()
    //           .whenComplete(() {
    //         Navigator.of(context).pushNamedAndRemoveUntil(
    //             HomePageMember.routeName, (dynamic) => false);
    //       });
    //       break;
    //   }
    // }).catchError((e) {
    //   print('Error during logout: $e');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(); // Empty scaffold that will show the dialog
  }
}