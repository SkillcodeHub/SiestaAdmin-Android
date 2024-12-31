class AppUrl {
  //Base Url
  // http://localhost:6000/api/
  // static var baseUrl = "http://10.0.2.2:6000/api/";

  // static var baseUrl = "http://10.0.2.2:3000/";
  // static var baseUrl = "http://192.168.1.2:9000/";
  static var baseUrl = "http://app.siestaleisurehomes.com/";
    // static var baseUrl = "https://5ef3-2405-201-2012-9075-45d9-324-3a99-af4e.ngrok-free.app/";


  //Get OTP
  // static var loginUrl = baseUrl + 'user/sendOTP';
  static var loginUrl = baseUrl + 'authentication/login';

  //OTP Verify
  static var otpverifyUrl = baseUrl + 'authentication/validate';
  //Auth Check Url
  static var authCheckUrl = baseUrl + 'authentication/authcheck';

  //owner Registration Plot List Url
  static var ownerRegistrationPlotListUrl = baseUrl + 'authentication/listOfPlots';

  //owner Registration Plot List Url
  static var addownerRequestUrl = baseUrl + 'authentication/registerOwner';



  // get Plot Owner Profile Details Url
  static var getPlotOwnerProfileDetailsUrl = baseUrl + 'users/profile';

  // update Profile Details Url
  static var updateProfileDetailsUrl = baseUrl + 'users/profile';



  //Scheduled Activities
  static var scheduledActivitiesUrl = baseUrl + 'scheduled-activities';

  //Scheduled Activities
  static var scheduledActivitiesByIdUrl = baseUrl + 'scheduled-activities/';

  //Task Stage Url
  static var taskStageUrl = baseUrl + 'reports/taskStage';

  //activity Groups Url
  static var activityGroupsUrl = baseUrl + 'activities/groups';

  //priority Task Url
  static var priorityTaskUrl = baseUrl + 'reports/priorityTask';

  //priority Task Url
  static var getActivitySchedulersListUrl = baseUrl + 'activities/scheduler';

  //get Activities List Url
  static var getActivitiesListUrl = baseUrl + 'activities/';

  //Assets List Url
  static var getAssetsListUrl = baseUrl + 'properties/';

  //Assets List Url
  static var getAssetsDetailsListUrl = baseUrl + 'properties/';

  //Assets List Url
  static var getAssetsTypesListUrl = baseUrl + 'properties/property_types/';

  //Notifications Requests Url
  static var notificationsRequestsUrl = baseUrl + 'notifications/requests/';

  //Activity Details Url
  static var activityDetailsUrl = baseUrl + 'activities/';

  //Authentication Roles Url
  static var authenticationRolesUrl = baseUrl + 'auth_roles/';
  //Authentication Role Details Url
  static var authenticationRoleDetailsUrl = baseUrl + 'auth_roles/?roleCode=';

  //Authentication Role Details Url
  static var appModulesListUrl = baseUrl + 'modules/';

  //Language List Url
  static var languageListUrl = baseUrl + 'resources/language';

  //dashboard Type Url
  static var dashboardTypeUrl = baseUrl + 'resources/dashboard_types/';
  //dashboard Type Url
  static var getUsersListUrl = baseUrl + 'users/';

  //pending Requests Url
  static var getPendingUsersrequestListUrl =
      baseUrl + 'users/pending_requests/';

  //activity Execution Stages List Url
  static var activityExecutionStagesListUrl =
      baseUrl + 'resources/act_exec_stages';

  //scheduler Pending Item List Url
  static var schedulerPendingItemListUrl =
      baseUrl + 'activities/schedulerPendingItem';

  //activity Scheduler Params List Url
  static var activitySchedulerParamsListUrl =
      baseUrl + 'activities/scheduler/params';

  //add New Activity Url
  static var addNewActivityUrl = baseUrl + 'activities/';

  //update Activity Url
  static var updateActivityUrl = baseUrl + 'activities/';

  //add New Activity Schedulers Url
  static var addNewActivitySchedulersUrl = baseUrl + 'activities/schedulers';

  //add New Asset Url
  static var addNewAssetUrl = baseUrl + 'properties/';

  //Update Asset Url
  static var updateAssetUrl = baseUrl + 'properties/';

  //add NewAuth Role Url
  static var addNewAuthRoleUrl = baseUrl + 'auth_roles/';

  //Update Auth Role Url
  static var updateAuthRoleUrl = baseUrl + 'auth_roles/';

  //Update User Details Url
  static var updateUserDetailsUrl = baseUrl + 'users/';

  //add Scheduled TaskManually Url
  static var addScheduledTaskManuallyUrl = baseUrl + 'scheduled-activities';

  //add Notified TaskManually Url
  static var addNotifiedTaskManuallyUrl = baseUrl + 'scheduled-activities';

  //add Notified TaskManually Url
  static var addUpdateActivityExecutionStagesTranslationsUrl =
      baseUrl + 'resources/act_exec_stages/translations';

  //add Update Asset Translations Url
  static var addUpdateAssetTranslationsUrl =
      baseUrl + 'properties/translations/';

  //add Update Auth Role Translations Url
  static var addUpdateAuthRoleTranslationsUrl =
      baseUrl + 'auth_roles/translations/';

  //add Update Activity Translations Url
  static var addUpdateActivityTranslationsUrl =
      baseUrl + 'activities/translations/';

  //update Activity Scheduler Item Url
  static var updateActivitySchedulerItemUrl = baseUrl + 'activities/scheduler/';

  //profile Url
  static var profileUrl = baseUrl + 'users/profile';


  //profile Url
  static var editProfileUrl = baseUrl + 'users/profile';

}
