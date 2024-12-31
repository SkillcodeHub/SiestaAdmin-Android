import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Provider/app_language_provider.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/View/file_upload/bloc/file_upload_bloc.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/Auth_View_Model/Login_View_Model/login_view_model.dart';
import 'package:siestaamsapp/View_Model/Auth_View_Model/authCheck_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/addNotifiedTaskManually_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/addScheduledTaskManually_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getActivitiesList_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getActivitySchedulerItemDetails_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getActivity_schedulersList_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getAssetsDetailsList_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getAssetsList_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getAssetsTypesList_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/scheduled_activitiesById_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/scheduled_activities_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/updateScheduled_Task_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/addNewActivity_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/addUpdateActivityTranslation_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/getActivityDetail_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/updateActivity_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Execution_Stages_List_View_Model/activity_execution_stage_detail_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Execution_Stages_List_View_Model/activity_execution_stages_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Execution_Stages_List_View_Model/addUpdateActivityExecutionStagesTranslations_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/activitySchedulerParamsList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/addNewActivitySchedulers_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/schedulerPendingActivityItemList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/schedulerPendingItemList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/updateActivitySchedulerItem_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Asset_View_Model/addNewAsset_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Asset_View_Model/addUpdateAssetTranslations_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Asset_View_Model/updateAsset_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/addNewAuthRole_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/addUpdateAuthRoleTranslations_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/appModules_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/authentication_roles_details_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/authentication_roles_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/dashboardTypes_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/languageList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/updateAuthRole_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/GetUsersList_View_Model/getUsersDetail_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/GetUsersList_View_Model/getUsersList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/GetUsersList_View_Model/updateUserDetails_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/PendingUserRequests_View_Model/pending_user_request_view_model.dart';
import 'package:siestaamsapp/View_Model/Report_View_Model/activityGroups_view_model.dart';
import 'package:siestaamsapp/View_Model/Report_View_Model/priorityTaskDetails_view_model.dart';
import 'package:siestaamsapp/View_Model/Report_View_Model/priorityTask_view_model.dart';
import 'package:siestaamsapp/View_Model/Report_View_Model/taskStage_view_model.dart';
import 'package:siestaamsapp/View_Model/Request_View_Model/notificationRequest_view_model.dart';
import 'package:sizer/sizer.dart';
import 'Utils/Widgets/app_theme.dart';
import 'View_Model/Auth_View_Model/OwnerRegistration_View_Model/addOwnerRequest_view_model.dart';
import 'View_Model/Auth_View_Model/OwnerRegistration_View_Model/ownerRegistrationPlotList_view_model.dart';
import 'View_Model/PlotOwner_View_Model/getPlotOwnerActivity_schedulersList_view_model.dart';
import 'View_Model/PlotOwner_View_Model/getPlotOwnerAssetsList_view_model.dart';
import 'View_Model/PlotOwner_View_Model/getPlotOwnerProfile_view_model.dart';
import 'View_Model/PlotOwner_View_Model/plotOwnerScheduledActivities_view_model.dart';
import 'View_Model/PlotOwner_View_Model/updateProfileDetails_view_model.dart';

class ContainerSizeNotifier extends ChangeNotifier {
  double width = 500;
  double height = 850;

  void toggleSize() {
    if (width == 500 && height == 850) {
      width = 650;
      height = double.infinity;
    } else {
      width = 500;
      height = 850;
    }

    notifyListeners();
  }
}

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseDatabase.instance.setPersistenceEnabled(true);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // EquatableConfig.stringify = true;

  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((value) =>
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  // );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FileUploadBloc>(
          create: (context) => FileUploadBloc(
            uploader: FlutterUploader(),
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (context) => LanguageProvider()),

          ChangeNotifierProvider(create: (_) => DoctorNameProvider()),
          ChangeNotifierProvider(create: (_) => ContainerSizeNotifier()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => AddNewActivityViewModel()),
          ChangeNotifierProvider(create: (_) => UpdateActivityViewModel()),
          ChangeNotifierProvider(create: (_) => ImageState()),
          ChangeNotifierProvider(create: (_) => AddNewAssetViewModel()),
          ChangeNotifierProvider(create: (_) => AddNewAuthRoleViewModel()),
          ChangeNotifierProvider(create: (_) => UpdateAuthRoleViewModel()),
          ChangeNotifierProvider(create: (_) => UpdateUserDetailsViewModel()),
          ChangeNotifierProvider(create: (_) => UpdateAssetViewModel()),
          ChangeNotifierProvider(create: (_) => UpdatescheduledTaskViewModel()),
          ChangeNotifierProvider(
              create: (_) => UpdateActivitySchedulerItemViewModel()),
          ChangeNotifierProvider(
              create: (_) => AddUpdateActivityTranslationViewModel()),
          ChangeNotifierProvider(
              create: (_) => AddUpdateAuthRoleTranslationViewModel()),
          ChangeNotifierProvider(
              create: (_) => AddUpdateAssetTranslationViewModel()),
          ChangeNotifierProvider(
              create: (_) =>
                  AddUpdateActivityExecutionStagesTranslationViewModel()),
          ChangeNotifierProvider(
              create: (_) => AddNotifiedTaskManuallyViewModel()),
          ChangeNotifierProvider(
              create: (_) => AddScheduledTaskManuallyViewModel()),
          ChangeNotifierProvider(
              create: (_) => AddNewActivitySchedulersViewModel()),

          ChangeNotifierProvider(create: (_) => AddOwnerRequestViewModel()),
                    ChangeNotifierProvider(create: (_) => UpdateProfileDetailsViewModel()),


          ChangeNotifierProvider<AuthStateProvider>(
            create: (_) => AuthStateProvider(
              flutterSecureStorage: FlutterSecureStorage(),
            ),
          ),
          ChangeNotifierProvider<ExpandableListSettingProvider>(
            create: (_) => ExpandableListSettingProvider(),
          ),
          ChangeNotifierProvider<AuthCheckViewmodel>(
              create: (_) => AuthCheckViewmodel()),
          ChangeNotifierProvider<AppLanguageProvider>(
              create: (_) => AppLanguageProvider()),
          ChangeNotifierProvider<ScheduledActivitiesViewmodel>.value(
              value: ScheduledActivitiesViewmodel()),
          ChangeNotifierProvider<ScheduledActivitiesByIdByIdViewmodel>.value(
              value: ScheduledActivitiesByIdByIdViewmodel()),
          ChangeNotifierProvider<TaskStageViewmodel>.value(
              value: TaskStageViewmodel()),
          ChangeNotifierProvider<ActivityGroupsViewmodel>.value(
              value: ActivityGroupsViewmodel()),
          ChangeNotifierProvider<PriorityTaskViewmodel>.value(
              value: PriorityTaskViewmodel()),
          ChangeNotifierProvider<GetActivitySchedulersListViewmodel>.value(
              value: GetActivitySchedulersListViewmodel()),
          ChangeNotifierProvider<GetAssetsListViewmodel>.value(
              value: GetAssetsListViewmodel()),
          ChangeNotifierProvider<GetActivitiesListViewmodel>.value(
              value: GetActivitiesListViewmodel()),
          ChangeNotifierProvider<NotificationRequestViewmodel>.value(
              value: NotificationRequestViewmodel()),
          ChangeNotifierProvider<GetActivityDetailsViewmodel>.value(
              value: GetActivityDetailsViewmodel()),
          ChangeNotifierProvider<AuthenticationRolesViewmodel>.value(
              value: AuthenticationRolesViewmodel()),
          ChangeNotifierProvider<AuthenticationRolesDetailsViewmodel>.value(
              value: AuthenticationRolesDetailsViewmodel()),
          ChangeNotifierProvider<AppModulesViewmodel>.value(
              value: AppModulesViewmodel()),
          ChangeNotifierProvider<DashboardTypeViewmodel>.value(
              value: DashboardTypeViewmodel()),
          ChangeNotifierProvider<LanguageListViewmodel>.value(
              value: LanguageListViewmodel()),
          ChangeNotifierProvider<GetUsersListViewmodel>.value(
              value: GetUsersListViewmodel()),
          ChangeNotifierProvider<GetUserDetailsViewmodel>.value(
              value: GetUserDetailsViewmodel()),
          ChangeNotifierProvider<PendingUserRequestViewmodel>.value(
              value: PendingUserRequestViewmodel()),
          ChangeNotifierProvider<ActivityExecutionStagesListViewmodel>.value(
              value: ActivityExecutionStagesListViewmodel()),
          ChangeNotifierProvider<ActivityExecutionStageDetailsViewmodel>.value(
              value: ActivityExecutionStageDetailsViewmodel()),
          ChangeNotifierProvider<GetAssetsTypeListViewmodel>.value(
              value: GetAssetsTypeListViewmodel()),
          ChangeNotifierProvider<GetAssetsDetailsListViewmodel>.value(
              value: GetAssetsDetailsListViewmodel()),
          ChangeNotifierProvider<SchedulerPendingItemListViewmodel>.value(
              value: SchedulerPendingItemListViewmodel()),
          ChangeNotifierProvider<ActivitySchedulerParamsListViewmodel>.value(
              value: ActivitySchedulerParamsListViewmodel()),
          ChangeNotifierProvider<GetActivitySchedulerItemViewmodel>.value(
              value: GetActivitySchedulerItemViewmodel()),
          ChangeNotifierProvider<PriorityTaskDetailsViewmodel>.value(
              value: PriorityTaskDetailsViewmodel()),
          ChangeNotifierProvider<
                  SchedulerPendingActivityItemListViewmodel>.value(
              value: SchedulerPendingActivityItemListViewmodel()),
          ChangeNotifierProvider<OwnerRegistrationPlotListViewmodel>.value(
              value: OwnerRegistrationPlotListViewmodel()),
          ChangeNotifierProvider<PlotOwnerScheduledActivitiesViewmodel>.value(
              value: PlotOwnerScheduledActivitiesViewmodel()),
          ChangeNotifierProvider<
                  GetPlotOwnerActivitySchedulersListViewmodel>.value(
              value: GetPlotOwnerActivitySchedulersListViewmodel()),
          ChangeNotifierProvider<GetPlotOwnerAssetsListViewmodel>.value(
              value: GetPlotOwnerAssetsListViewmodel()),
          ChangeNotifierProvider<GetPlotOwnerProfileViewmodel>.value(
              value: GetPlotOwnerProfileViewmodel()),
        ],
        child: LayoutBuilder(builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          return Directionality(
            textDirection: TextDirection.ltr,
            child:
                isTablet ? _buildTabletLayout(context) : _buildMobileLayout(),
          );
        }),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Center(
            child: Consumer<ContainerSizeNotifier>(
              builder: (context, containerSize, _) {
                return Container(
                  width: containerSize.width,
                  height: containerSize.height,
                  child: Builder(
                    builder: (context) {
                      return Sizer(
                        builder: (context, orientation, deviceType) {
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            title: 'Sieasta',
                            theme: ThemeData(
                              brightness: Brightness.light,
                              primaryColor: Color(0xFF2196F3),
                              primarySwatch: AppPrimaryColor,
                              // colorScheme: ColorScheme.light(
                              //   secondary: Colors.deepOrangeAccent,
                              //   primary: primaryColor,
                              //   primaryVariant: appPrimaryColor,
                              //   secondaryVariant:
                              //       Colors.deepOrangeAccent.shade700,
                              // ),
                              textTheme: GoogleFonts.nanumGothicTextTheme(
                                  Theme.of(context).textTheme),
                            ),
                            initialRoute: RoutesName.splash,
                            onGenerateRoute: Routes.generateRoute,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Container(
            height: 60,
            width: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade800),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: () {
                Provider.of<ContainerSizeNotifier>(context, listen: false)
                    .toggleSize();
              },
              child: Consumer<ContainerSizeNotifier>(
                builder: (context, containerSize, _) {
                  return Image.asset(containerSize.width == 500
                      ? 'asset/images/full_screen.png'
                      : 'asset/images/minimize_screen.png');
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Consumer<ContainerSizeNotifier>(
      builder: (context, containerSize, _) {
        return Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Sieasta',
              theme: AppTheme.lightTheme,
              initialRoute: RoutesName.splash,
              onGenerateRoute: Routes.generateRoute,
            );
          },
        );
      },
    );
  }
}
