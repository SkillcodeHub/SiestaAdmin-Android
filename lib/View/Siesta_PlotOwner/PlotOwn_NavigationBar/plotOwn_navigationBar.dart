import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../Res/colors.dart';
import '../../../constants/string_res.dart';
import '../Plot_Home/plotHomeScreen.dart';
import '../Plot_Logout/plotLogoutScreen.dart';
import '../Plot_Profile/plotProfileScreen.dart';

class PlotOwn_NavigationBar extends StatefulWidget {
  final int indexNumber;

  const PlotOwn_NavigationBar({super.key, required this.indexNumber});

  @override
  State<PlotOwn_NavigationBar> createState() => _PlotOwn_NavigationBarState();
}

class _PlotOwn_NavigationBarState extends State<PlotOwn_NavigationBar> {
  double iconSize = 24;

  // bool canViewReport = false,
  //     canAddSchedTask = false,
  //     canViewNotfRequests = false;
  // late AuthModal authModal;

  @override
  void initState() {
    super.initState();
    // authModal =
    //     Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    // canViewReport = authModal.canRead!.contains(moduleReport);
    // canAddSchedTask = authModal.canAdd!.contains(moduleScheduledActivity);
    // canViewNotfRequests =
    //     authModal.canAdd!.contains(moduleNotificationRequests);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<int>>(
      create: (_) => ValueNotifier<int>(widget.indexNumber),
      child: Consumer<ValueNotifier<int>>(
        builder: (context, selectedIndexProvider, _) {
          final selectedIndex = selectedIndexProvider.value;

          final List<Widget> user = [
            PlotHomeScreen(),
            DashboardProfile(),
            PlotOwnerReportScreen(),

            // PlotLogoutScreen(),
          ];

          void _onItemTapped(int index) {
            // if ((canViewNotfRequests || index != 2) &&
            //     (canViewReport || index != 1)) {
            selectedIndexProvider.value = index;
            // }
          }

          return SafeArea(
            child: Scaffold(
                body: user[selectedIndex],
                bottomNavigationBar: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon:
                          Icon(Icons.home, size: iconSize, color: Colors.black),
                      activeIcon: Icon(Icons.home,
                          size: iconSize, color: appSecondaryColor),
                      label: AppString.get(context).homePage(),
                    ),
                  
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_box_rounded,
                          size: iconSize, color: Colors.black),
                      activeIcon: Icon(Icons.account_box_rounded,
                          size: iconSize, color: appSecondaryColor),
                      label: AppString.get(context).profile(),
                    ),
                 
                   BottomNavigationBarItem(
                      icon: Icon(Icons.power_settings_new,
                          size: iconSize, color: Colors.black),
                      activeIcon: Icon(Icons.power_settings_new,
                          size: iconSize, color: appSecondaryColor),
                      label: AppString.get(context).logout(),
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
                      color:
                          appSecondaryColor), // Set selected label text color
                )),
                
          );
        },
      ),
    );
  }
}
