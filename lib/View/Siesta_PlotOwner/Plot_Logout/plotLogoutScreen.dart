import 'package:flutter/material.dart';

import '../../../constants/string_res.dart';
import '../../Auth/Authentication/LoginPage/login_screen.dart';
import '../../SharedPreferences/sharePreference.dart';

class PlotOwnerReportScreen extends StatefulWidget {
  const PlotOwnerReportScreen({super.key});

  @override
  State<PlotOwnerReportScreen> createState() => _PlotOwnerReportScreenState();
}

class _PlotOwnerReportScreenState extends State<PlotOwnerReportScreen> {

    UserPreferences userPreference = UserPreferences();

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
                                              userPreference.logoutProcess();

                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(); // Empty scaffold that will show the dialog
  }
}