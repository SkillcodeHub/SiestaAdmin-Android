import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/dashboard_siesta_administration.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/More_Screen/more_screen.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Report/Report_Screen/report_screen.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Requests/request_screen.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class MyNavigationBar extends StatefulWidget {
  final int indexNumber;

  const MyNavigationBar({Key? key, required this.indexNumber})
      : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  double iconSize = 24;

  bool canViewReport = false,
      canAddSchedTask = false,
      canViewNotfRequests = false;
  late AuthModal authModal;

  @override
  void initState() {
    super.initState();
    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canViewReport = authModal.canRead!.contains(moduleReport);
    canAddSchedTask = authModal.canAdd!.contains(moduleScheduledActivity);
    canViewNotfRequests =
        authModal.canAdd!.contains(moduleNotificationRequests);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<int>>(
      create: (_) => ValueNotifier<int>(widget.indexNumber),
      child: Consumer<ValueNotifier<int>>(
        builder: (context, selectedIndexProvider, _) {
          final selectedIndex = selectedIndexProvider.value;

          final List<Widget> user = [
            DashboardSiestaAdministrationPage(),
            ReportScreen(),
            RequestsScreen(),
            MoreScreen(),
          ];

          void _onItemTapped(int index) {


            
            if ((canViewNotfRequests || index != 2) &&
                (canViewReport || index != 1)) {
              selectedIndexProvider.value = index;
            }
          }

          return Scaffold(
              body: user[selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: iconSize, color: Colors.black),
                    activeIcon: Icon(Icons.home,
                        size: iconSize, color: appSecondaryColor),
                    label: AppString.get(context).homePage(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.drafts,
                        size: iconSize,
                        color: !canViewReport ? Colors.grey : Colors.black),
                    activeIcon: Icon(Icons.drafts,
                        size: iconSize, color: appSecondaryColor),
                    label: AppString.get(context).reportPage(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notification_important,
                        size: iconSize,
                        color:
                            !canViewNotfRequests ? Colors.grey : Colors.black),
                    activeIcon: Icon(Icons.notification_important,
                        size: iconSize, color: appSecondaryColor),
                    label: AppString.get(context).requests(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz,
                        size: iconSize, color: Colors.black),
                    activeIcon: Icon(Icons.more_horiz,
                        size: iconSize, color: appSecondaryColor),
                    label: AppString.get(context).morePage(),
                  ),
                ],
                selectedItemColor:
                    appSecondaryColor, // Set the selected item color to orange
                backgroundColor: context.cardColor,
                mouseCursor: MouseCursor.uncontrolled,
                currentIndex: selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                elevation: 12,
                unselectedLabelStyle: TextStyle(color: appPrimaryColor),
                selectedLabelStyle: TextStyle(
                    color: appSecondaryColor), // Set selected label text color
              ));
        },
      ),
    );
  }
}
