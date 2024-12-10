import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivity_schedulersList_model.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsList_model.dart';
import 'package:siestaamsapp/Model/More_Model/activityExecution_stages_model.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role.dart';
import 'package:siestaamsapp/Model/More_Model/getUsersList_model.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/Auth/Authentication/OTPVerify/otpVerify_screen.dart';
import 'package:siestaamsapp/View/PoppupMenuItem/file_upload_screen.dart';
import 'package:siestaamsapp/View/PoppupMenuItem/profilePage_screen.dart';
import 'package:siestaamsapp/View/PoppupMenuItem/settings_screen.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/ScheduledTaskDetail_Screen.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/camera_page.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/images_slider_list.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/scheduledTaskAddNew_screen.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activities/activity_add_new.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activities/activity_detail.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activities/activity_list.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activity_Execution_Stages/activity_execution_stage_detail.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activity_Execution_Stages/activity_execution_stages_list.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activity_Scheduler/activity_scheduler_add_new.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activity_Scheduler/activity_scheduler_details.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activity_Scheduler/activity_scheduler_list.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activity_Scheduler/activity_selection_page.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Asset/assets_details.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Asset/assets_list.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Authentication_Roles/athentication_role_detail.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Authentication_Roles/authentication_role_add_new.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Authentication_Roles/authentication_roles_list.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Pending_User_Requests/pending_users_list.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Users/users_detail.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Users/users_list.dart';
import 'package:siestaamsapp/View/Splash/SplashScreen/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
      case RoutesName.verifyOtp:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                OtpVerifyScreen(mobile: settings.arguments as Map));
      case RoutesName.scheduledTaskDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) => ScheduledTaskDetail(
                  data: settings.arguments as Map,
                ));
      case RoutesName.fileUploadScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => FileUploadScreen());
      case RoutesName.profileScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => ProfileScreen());
      case RoutesName.settingScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => SettingScreen());
      case RoutesName.cameraScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => CameraPage());
      case RoutesName.imageSliderScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => ImagesSliderListView(
                  imagesSliderList: settings.arguments as ImagesSliderList,
                ));
      case RoutesName.ScheduledTaskAddNew:
        return MaterialPageRoute(
            builder: (BuildContext context) => ScheduledTaskAddNewPage());
      case RoutesName.ActivityList:
        return MaterialPageRoute(
            builder: (BuildContext context) => ActivityListPage());
      case RoutesName.ActivitySchedulerList:
        return MaterialPageRoute(
            builder: (BuildContext context) => ActivitySchedulerListPage());
      case RoutesName.ActivityAddNewPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => ActivityAddNewPage());
      case RoutesName.ActivityDetailPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => ActivityDetailPage(
                  activity: settings.arguments as Activities,
                ));
      case RoutesName.ActivitySchedulerAddNew:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            final arguments = settings.arguments;
            return ActivitySchedulerAddNewPage(
              activity:
                  arguments != null ? arguments as ActivitySchedulers : null,
            );
          },
        );

      // activity: settings.arguments as ScheduledActivities
      case RoutesName.AuthRoleDetails:
        return MaterialPageRoute(
            builder: (BuildContext context) => AuthRoleDetailsPage(
                  authRole: settings.arguments as AuthRole,
                ));
      case RoutesName.authRoleAddNewPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => AuthRoleAddNewPage());

      case RoutesName.assetsListPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => AssetsListPage());
      case RoutesName.authRolesPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => AuthRolesPage());
      case RoutesName.usersListPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => UsersListPage());
      case RoutesName.usersDetailPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                UsersDetailPage(user: settings.arguments as User));
      case RoutesName.pendingUsersListPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => PendingUsersListPage());
      case RoutesName.activityExecutionStagesListPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ActivityExecutionStagesListPage());
      case RoutesName.activityExecutionStageDetailsPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => ActivityExecutionStageDetailPage(
                activityExecutionStage:
                    settings.arguments as ActivityExecutionStage));
      case RoutesName.assetsDetailsPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                AssetsDetailsPage(property: settings.arguments as Assets));
      case RoutesName.activitySelectionPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => ActivitySelectionPage(
                  selection: (settings.arguments as dynamic)['selection']
                      as Map<num, Activities>,
                  activitiesList: (settings.arguments as dynamic)['activities']
                      as List<Activities>,
                ));

      case RoutesName.activitySchedulerDetailPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => ActivitySchedulerDetailPage(
                activity: settings.arguments as ActivitySchedulers));

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
