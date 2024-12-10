import 'package:flutter/material.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:sizer/sizer.dart';

class MyDrawer extends StatelessWidget {
  final String doctorName;
  final String email;

  MyDrawer({required this.doctorName, required this.email});

  UserPreferences userPreference = UserPreferences();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            accountName: Text(
              doctorName,
              style: TextStyle(
                fontSize: descriptionFontSize,
              ),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(
                fontSize: descriptionFontSize,
              ),
            ),
            currentAccountPicture: Image.asset(
              'images/doctor_round.png',
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AxonwebUserDetailsScreen(),
              //   ),
              // );
            },
          ),
          ListTile(
            leading: Icon(Icons.login_outlined),
            title: Text('CMS LogIn'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => RoleSelectionScreen(),
              //   ),
              // );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return Container(
                    child: AlertDialog(
                      title: Center(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: Text(
                        'Are you sure, do you want to logout?',
                        style: TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: appPrimaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: 25.w,
                                child: Center(
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            InkWell(
                              onTap: () {
                                userPreference.logoutProcess();
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => LoginScreen(),
                                //   ),
                                //   (route) => false,
                                // );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: appPrimaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: 25.w,
                                child: Center(
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
