library string_res_admin_app;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Provider/app_language_provider.dart';

const String APP_NAME_ADMIN = 'Siesta CMS';
const String APP_NAME_MEMBER = 'Siesta Member';

abstract class AppString {
  static AppString get(BuildContext context) {
    AppLanguageProvider provider =
        Provider.of<AppLanguageProvider>(context, listen: false);

    switch (provider.getCurrentAppLanguage) {
      case 'eng':
        {
          return _Eng();
        }
      case 'guj':
        {
          return _Guj();
        }
      default:
        {
          return _Eng();
        }
    }
  }

  String plotOwnerRegistration();

  String appHeadingAdmin();

  String appSubHeading();

  String appHeadingMember();

  String initPleaseWait();

  String login();

  String hintEmail();

  String hintMobile();

  String hintFullName();

  String siestaAMSAdmin();

  String register();

  String pleaseWait();

  String verify();

  String verifyOTP();

  String settings();

  String language();

  String confirm();

  String areYouSureWantToLogout();

  String logout();

  String cancel();

  String mobile();

  String email();

  String ok();

  String sessionExpired();

  String pleaseLoginAgainYourLoginSessionIsExpired();

  String refresh();

  String retry();

  String somethingWentWrong();

  String assignedTo();

  String plot();

  String slip();

  String additionalInformation();

  String additionalInfo();

  String assignedBy();

  String notAssigned();

  String instructions();

  String notStartedYet();

  String notCompletedYet();

  String startedOn();

  String completedOn();

  String owner();

  String scheduledAt();

  String scheduledOn();

  String dev();

  String schdledDate();

  String date();

  String status();

  String moduleListPages();

  String module();

  String activityScheduler();

  String activities();

  String schedule();

  String every();

  String active();

  String disabled();

  String editActivitySchedule();

  String detail();

  String activity();

  String description();

  String scheduler();

  String plotDetail();

  String plotNo();

  String update();

  String change();

  String times();

  String updating();

  String message();

  String addNewScheduler();

  String done();

  String confirmTaskCompleteMessage();

  String success();

  String completed();

  String start();

  String markComplete();

  String notAMemberYetRegister();

  String alreadyAMemberLogin();

  String addNewActivity();

  String yes();

  String maxSkipTimeoutDays();

  String updateActivity();

  String confirmMarkAsStarted();

  String users();

  String usersList();

  String administration();

  String pendingMemberApproval();

  String connectivityProblem();

  String addTranslation();

  String activityMainDetailEditInEnglishOnly();

  String pleaseEnterOTP();

  String loginSuccess();

  String add();

  String selectPlot();

  String emptyData();

  String goBack();

  String clickToAddNewActivityToScheduler();

  String clearAll();

  String selectSchedule();

  String selectDate();

  String validateEmptySchedulerData();

  String validateSchedulerData();

  String confirmAddNewSchedulers();

  String expandableList();

  String expandedByDefault();

  String imagesList();

  String superAdminViews();

  String visibleSuperAdminViews();

  String viewAll();

  String before();

  String more();

  String after();

  String images();

  String assets();

  String lastInterval();

  String mo();

  String tu();

  String we();

  String th();

  String fr();

  String sa();

  String su();

  String autoSchedulable();

  String day();

  String week();

  String month();

  String or();

  String arbitrary();

  String arbitrarily();

  String appUpdateAvailable();

  String uploads();

  String noPendingUploads();

  String actions();

  String by();

  String removeCompleted();

  String sort();

  String admin();

  String type();

  String reportPage();

  String homePage();

  String morePage();

  String monthlyReport();

  String notifiedActivity();

  String notified();

  String comment();

  String tentativeDeadline();

  String groupPriority();

  String submit();

  String priorityActivity();

  String imageRequired();

  String name();

  String number();

  String wantToAddNewAsset();

  String wantToUpdateAsset();

  String list();

  String pendingAndBlocked();

  String authenticationRoles();

  String canAdd();

  String canView();

  String canUpdate();

  String permissions();

  String expand();

  String collapse();

  String roleCode();

  String roleName();

  String pendingMemberRequests();

  String delayDeadline();

  String scheduledDate();

  String dashboardTypes();

  String newUserRequests();

  String pending();

  String blocked();

  String requests();

  String maintenanceTask();

  String propertyType();

  String profile();

  String yourAuthStatusIsPending();

  String undefinedDashboardDetected();

  String errorEmail();

  String errorFullName();

  String validateFormData();

  String ownership();

  String history();

  String activityStagesReport();

  String stage();

  String translation();

  String others();

  String activityStages();

  String autoRemovableByScheduler();

  String stageName();

  String stageCode();

  String remove();

  String appUsageUsers();

  String contactHasNoPhoneNumber();

  String choosePhoneNumber();

  String choosePhoneAndEmail();

  String problem();

  String failure();

  String unSupportedAdminUserForApp();

  String unSupportedMemberUserForApp();

  String contactsPermissionNotAvailable();

  String cameraPermissionNotAvailable();

  String storagePermissionNotAvailable();

  String contactAlreadyAvailableInList();

  String warning();

  String noAssociateMembersAdded();

  String rejected();

  String appAssociatesList();

  String wantsToAddAssociateMember();

  String wantsToAdd();

  String associateMember();

  String associateMembersRequest();

  String accept();

  String reject();

  String accepted();

  String selectAtleastOneActivity();
}

class _Guj extends AppString {
  @override
  String plotOwnerRegistration() {
    return 'સિએસ્ટા પ્લોટ માલિકી નોંધણી';
  }

  String appHeadingAdmin() {
    return 'સિએસ્ટા CMS';
  }

  @override
  String siestaAMSAdmin() {
    return 'Siesta AMS Admin';
  }

  @override
  String appSubHeading() {
    return 'સિએસ્ટા પ્લોટ માલિકી સંગઠન (એસ.પી.ઓ.એ)';
  }

  @override
  String appHeadingMember() {
    return 'સિએસ્ટા સભ્ય';
  }

  @override
  String appUpdateAvailable() {
    return 'એપ્લિકેશન અપડેટ ઉપલબ્ધ છે';
  }

  @override
  String lastInterval() {
    return 'છેલ્લું અંતરાલ';
  }

  @override
  String images() {
    return 'છબીઓ';
  }

  @override
  String after() {
    return 'પછી';
  }

  @override
  String more() {
    return 'વધુ';
  }

  @override
  String before() {
    return 'પહેલાં';
  }

  @override
  String viewAll() {
    return 'બધું બતાવો';
  }

  @override
  String visibleSuperAdminViews() {
    return 'દૃશ્યમાન સુપર એડમિન સ્ક્રીન';
  }

  @override
  String superAdminViews() {
    return 'સુપર એડમિન સ્ક્રીન';
  }

  @override
  String imagesList() {
    return 'છબીઓની સૂચિ';
  }

  @override
  String expandedByDefault() {
    return 'વિસ્તૃત';
  }

  @override
  String expandableList() {
    return 'વિસ્તૃત યાદી';
  }

  @override
  String confirmAddNewSchedulers() {
    return 'નવા શેડ્યુલર ઉમેરવાની પુષ્ટિ કરો';
  }

  @override
  String validateSchedulerData() {
    return 'યોગ્ય શેડ્યૂલર ડેટા પ્રદાન કરો';
  }

  @override
  String validateEmptySchedulerData() {
    return 'સબમિટ કરતા પહેલા પ્રવૃત્તિ શેડ્યૂલર્સ ઉમેરો';
  }

  @override
  String selectDate() {
    return 'તારીખ પસંદ કરો';
  }

  @override
  String selectSchedule() {
    return 'શેડ્યૂલ પસંદ કરો';
  }

  @override
  String clearAll() {
    return 'બધું સાફ કરો';
  }

  @override
  String clickToAddNewActivityToScheduler() {
    return 'શેડ્યૂલરમાં નવી પ્રવૃત્તિ ઉમેરવા માટે ક્લિક કરો';
  }

  @override
  String goBack() {
    return 'પાછા જાવ';
  }

  @override
  String emptyData() {
    return 'કોઈ ડેટા ઉપલબ્ધ નથી';
  }

  @override
  String selectPlot() {
    return 'પ્લોટ પસંદ કરો';
  }

  @override
  String add() {
    return 'ઉમેરો';
  }

  @override
  String loginSuccess() {
    return 'લોગીન સફળતા';
  }

  @override
  String pleaseEnterOTP() {
    return 'કૃપા કરીને ઓટીપી દાખલ કરો';
  }

  @override
  String activityMainDetailEditInEnglishOnly() {
    return 'જ્યારે એપ્લિકેશન વૈશ્વિક ભાષા અંગ્રેજી હોય ત્યારે સંપાદિત કરી શકાય છે';
  }

  @override
  String addTranslation() {
    return 'અનુવાદ ઉમેરો';
  }

  @override
  String connectivityProblem() {
    return 'કનેક્ટિવિટી સમસ્યા';
  }

  @override
  String pendingMemberApproval() {
    return 'બાકી સભ્ય મંજૂરી';
  }

  @override
  String administration() {
    return 'સંચાલન';
  }

  @override
  String usersList() {
    return 'વપરાશકર્તાઓની સૂચિ';
  }

  @override
  String users() {
    return 'વપરાશકર્તા';
  }

  @override
  String confirmMarkAsStarted() {
    return 'શું તમે ખરેખર કાર્ય શરૂ કરવા માંગો છો';
  }

  @override
  String updateActivity() {
    return 'પ્રવૃત્તિ અપડેટ કરો';
  }

  @override
  String maxSkipTimeoutDays() {
    return 'મહત્તમ સમયસમાપ્તિ દિવસ';
  }

  @override
  String yes() {
    return 'હા';
  }

  @override
  String addNewActivity() {
    return 'નવી પ્રવૃત્તિ ઉમેરો';
  }

  @override
  String alreadyAMemberLogin() {
    return 'અહીં લૉગિન કરો.';
  }

  @override
  String notAMemberYetRegister() {
    return 'હજી સભ્ય નથી. નોંધણી કરો';
  }

  @override
  String markComplete() {
    return 'સંપૂર્ણ તરીકે ચિહ્નિત કરો';
  }

  @override
  String start() {
    return 'શરૂઆત';
  }

  @override
  String completed() {
    return 'પૂર્ણ';
  }

  @override
  String success() {
    return 'સફળતા';
  }

  @override
  String confirmTaskCompleteMessage() {
    return 'શું તમે ખરેખર કાર્યને પૂર્ણ તરીકે ચિહ્નિત કરવા માંગો છો?';
  }

  @override
  String done() {
    return 'થઈ ગયું';
  }

  @override
  String addNewScheduler() {
    return 'નવું શેડ્યૂલર ઉમેરો';
  }

  @override
  String message() {
    return 'સંદેશ';
  }

  @override
  String updating() {
    return 'અપડેટ કરી રહયા છે';
  }

  @override
  String times() {
    return 'વખત';
  }

  @override
  String change() {
    return 'ફેરફાર';
  }

  @override
  String update() {
    return 'સુધારો';
  }

  @override
  String plotNo() {
    return 'પ્લોટ નં';
  }

  @override
  String plotDetail() {
    return 'પ્લોટ વિગતવાર';
  }

  @override
  String scheduler() {
    return 'અનુસૂચિ';
  }

  @override
  String description() {
    return 'વર્ણન';
  }

  @override
  String activity() {
    return 'પ્રવૃત્તિ';
  }

  @override
  String detail() {
    return 'વિગત';
  }

  @override
  String editActivitySchedule() {
    return 'પ્રવૃત્તિ શેડ્યૂલ સંપાદિત કરો';
  }

  @override
  String disabled() {
    return 'નિષ્ક્રિય';
  }

  @override
  String active() {
    return 'સક્રિય';
  }

  @override
  String every() {
    return 'દરેક';
  }

  @override
  String schedule() {
    return 'સૂચિ';
  }

  @override
  String activities() {
    return 'પ્રવૃત્તિઓ';
  }

  @override
  String activityScheduler() {
    return 'પ્રવૃત્તિ શેડ્યૂલર';
  }

  @override
  String module() {
    return 'વિભાગ';
  }

  @override
  String moduleListPages() {
    return 'વિભાગ સૂચિ પાના';
  }

  @override
  String status() {
    return 'સ્થિતિ';
  }

  @override
  String date() {
    return 'તારીખ';
  }

  @override
  String schdledDate() {
    return 'સુનિશ્ચિત તારીખ';
  }

  @override
  String dev() {
    return 'બાંધકામ';
  }

  @override
  String scheduledOn() {
    return 'સુનિશ્ચિત થયેલ';
  }

  @override
  String scheduledAt() {
    return 'સુનિશ્ચિત સમય';
  }

  @override
  String owner() {
    return 'માલિક';
  }

  @override
  String completedOn() {
    return 'ના રોજ પૂર્ણ';
  }

  @override
  String startedOn() {
    return 'ચાલુ કર્યું';
  }

  @override
  String notCompletedYet() {
    return 'હજી પૂરું થયું નથી';
  }

  @override
  String notStartedYet() {
    return 'હજુ શરૂ કર્યું નથી';
  }

  @override
  String instructions() {
    return 'સૂચનો';
  }

  @override
  String notAssigned() {
    return 'સોંપેલું નથી';
  }

  @override
  String assignedBy() {
    return 'સોંપાયેલ દ્વારા';
  }

  @override
  String additionalInfo() {
    return 'વધારાની માહીતી';
  }

  @override
  String additionalInformation() {
    return 'વધારાની માહિતી';
  }

  @override
  String slip() {
    return 'ચિઠ્ઠી';
  }

  @override
  String plot() {
    return 'પ્લોટ';
  }

  @override
  String assignedTo() {
    return 'સોંપાયેલ';
  }

  @override
  String somethingWentWrong() {
    return 'કંઈક ખોટું થયું';
  }

  @override
  String retry() {
    return 'ફરી પ્રયાસ કરો';
  }

  @override
  String refresh() {
    return 'નવીકરણ';
  }

  @override
  String pleaseLoginAgainYourLoginSessionIsExpired() {
    return 'ફરીથી લોગિન કરો. તમારું લોગિન સત્ર સમાપ્ત થયું.';
  }

  @override
  String sessionExpired() {
    return 'સત્ર સમાપ્ત';
  }

  @override
  String ok() {
    return 'બરાબર';
  }

  @override
  String email() {
    return 'ઇમેઇલ';
  }

  @override
  String mobile() {
    return 'મોબાઇલ';
  }

  @override
  String cancel() {
    return 'રદ કરો';
  }

  @override
  String logout() {
    return 'લૉગ આઉટ';
  }

  @override
  String areYouSureWantToLogout() {
    return 'શું તમે ખરેખર લોગઆઉટ કરવા માંગો છો';
  }

  @override
  String confirm() {
    return 'ખાતરી કરો';
  }

  @override
  String language() {
    return 'ભાષા';
  }

  @override
  String settings() {
    return 'સેટિંગ્સ';
  }

  @override
  String verifyOTP() {
    return 'ઓટીપી ચકાસો';
  }

  @override
  String verify() {
    return 'ચકાસો';
  }

  @override
  String pleaseWait() {
    return 'મહેરબાની કરી રાહ જુવો';
  }

  @override
  String register() {
    return 'નોંધણી';
  }

  @override
  String hintFullName() {
    return 'પૂરું નામ*';
  }

  @override
  String hintMobile() {
    return 'મોબાઇલ*';
  }

  @override
  String hintEmail() {
    return 'ઇમેઇલ*';
  }

  @override
  String login() {
    return 'લોગીન';
  }

  @override
  String initPleaseWait() {
    return 'કૃપા કરીને પ્રતીક્ષા કરો';
  }

  @override
  String assets() {
    return 'સંપત્તિ';
  }

  @override
  String mo() {
    return 'સોમ';
  }

  @override
  String tu() {
    return 'મંગળ';
  }

  @override
  String we() {
    return 'બુધ';
  }

  @override
  String th() {
    return 'ગુરુ';
  }

  @override
  String fr() {
    return 'શુક્ર';
  }

  @override
  String sa() {
    return 'શનિ';
  }

  @override
  String su() {
    return 'રવિ';
  }

  @override
  String autoSchedulable() {
    return 'આપમેળે સુનિશ્ચિત';
  }

  @override
  String day() {
    return 'દિવસ';
  }

  @override
  String month() {
    return 'મહિનો';
  }

  @override
  String week() {
    return 'અઠવાડિયું';
  }

  @override
  String or() {
    return 'અથવા';
  }

  @override
  String arbitrary() {
    return 'મનસ્વી';
  }

  @override
  String arbitrarily() {
    return 'મનસ્વી રીતે';
  }

  @override
  String uploads() {
    return 'અપલોડ્સ';
  }

  @override
  String noPendingUploads() {
    return 'અપલોડ્સ બાકી નથી';
  }

  @override
  String actions() {
    return 'ક્રિયા';
  }

  @override
  String by() {
    return 'દ્વારા';
  }

  @override
  String removeCompleted() {
    return 'પૂર્ણ થયેલ અપલોડ દૂર કરો';
  }

  @override
  String sort() {
    return 'વર્ગીકરણ';
  }

  @override
  String admin() {
    return 'એડમિન';
  }

  @override
  String type() {
    return 'પ્રકાર';
  }

  @override
  String reportPage() {
    return 'અહેવાલ';
  }

  @override
  String homePage() {
    return 'મુખ્ય';
  }

  @override
  String morePage() {
    return 'વધુ';
  }

  @override
  String monthlyReport() {
    return 'માસિક અહેવાલ';
  }

  @override
  String notifiedActivity() {
    return 'સૂચિત પ્રવૃત્તિ';
  }

  @override
  String notified() {
    return 'સૂચિત';
  }

  @override
  String comment() {
    return 'ટિપ્પણી';
  }

  @override
  String tentativeDeadline() {
    return 'કામચલાઉ સમયમર્યાદા';
  }

  @override
  String groupPriority() {
    return 'જૂથ અગ્રતા';
  }

  @override
  String submit() {
    return 'સમર્પિત કરવું';
  }

  @override
  String priorityActivity() {
    return 'અગ્રતા પ્રવૃત્તિ';
  }

  @override
  String imageRequired() {
    return 'છબી જરૂરી છે?';
  }

  @override
  String name() {
    return 'નામ';
  }

  @override
  String number() {
    return 'નંબર';
  }

  @override
  String wantToAddNewAsset() {
    return 'નવી સંપત્તિ ઉમેરવા માંગો છો?';
  }

  @override
  String wantToUpdateAsset() {
    return 'સંપત્તિ અપડેટ કરવા માંગો છો?';
  }

  @override
  String list() {
    return 'યાદી';
  }

  @override
  String pendingAndBlocked() {
    return 'બાકી અને અવરોધિત';
  }

  @override
  String authenticationRoles() {
    return 'પ્રમાણીકરણ ભૂમિકા';
  }

  @override
  String canAdd() {
    return 'ઉમેરી શકો';
  }

  @override
  String canView() {
    return 'જોઈ શકો';
  }

  @override
  String canUpdate() {
    return 'અપડેટ કરી શકો';
  }

  @override
  String permissions() {
    return 'પરવાનગી';
  }

  @override
  String collapse() {
    return 'ઘટાડવું';
  }

  @override
  String expand() {
    return 'વિસ્તૃત કરો';
  }

  @override
  String roleCode() {
    return 'ભૂમિકા સંહિતા';
  }

  @override
  String roleName() {
    return 'ભૂમિકા નામ';
  }

  @override
  String pendingMemberRequests() {
    return 'બાકી સભ્ય વિનંતીઓ';
  }

  @override
  String delayDeadline() {
    return 'વિલંબની અંતિમ મુદત';
  }

  @override
  String scheduledDate() {
    return 'સુનિશ્ચિત તારીખ';
  }

  @override
  String dashboardTypes() {
    return 'ડેશબોર્ડ પ્રકાર';
  }

  @override
  String newUserRequests() {
    return 'નવા સભ્યોની વિનંતીઓ';
  }

  @override
  String pending() {
    return 'બાકી';
  }

  @override
  String blocked() {
    return 'પ્રતિબંધિત';
  }

  @override
  String requests() {
    return 'વિનંતીઓ';
  }

  @override
  String maintenanceTask() {
    return 'જાળવણી કાર્ય';
  }

  @override
  String propertyType() {
    return 'મિલકત પ્રકાર';
  }

  @override
  String profile() {
    return 'પ્રોફાઇલ';
  }

  @override
  String yourAuthStatusIsPending() {
    return 'તમારો પ્રમાણીકરણ દરજ્જો બાકી છે. તમારી વિનંતી મંજૂર થાય ત્યાં સુધી કૃપા કરી પ્રતીક્ષા કરો.';
  }

  @override
  String undefinedDashboardDetected() {
    return 'અસ્પૃષ્ટ ડેશબોર્ડ મળ્યું છે. એપ્લિકેશનને અપડેટ કરો અથવા પાનાને ફરીથી લોડ કરો';
  }

  @override
  String errorEmail() {
    return 'કૃપા કરીને માન્ય ઇમેઇલનો ઉપયોગ કરો';
  }

  @override
  String errorFullName() {
    return 'પૂર્ણ નામ 5 અથવા વધુની લંબાઈનું હોવું જોઈએ';
  }

  @override
  String validateFormData() {
    return 'કૃપા કરીને ફોર્મ ડેટાને માન્ય કરો';
  }

  @override
  String ownership() {
    return 'માલિકી';
  }

  @override
  String history() {
    return 'ઇતિહાસ';
  }

  @override
  String activityStagesReport() {
    return 'પ્રવૃત્તિના તબક્કાઓનો અહેવાલ';
  }

  @override
  String stage() {
    return 'તબક્કો';
  }

  @override
  String translation() {
    return 'ભાષાન્તર';
  }

  @override
  String others() {
    return 'અન્ય';
  }

  @override
  String activityStages() {
    return 'પ્રવૃત્તિના તબક્કાઓ';
  }

  @override
  String autoRemovableByScheduler() {
    return 'શેડ્યૂલર દ્વારા આપમેળે દૂર કરી શકાય';
  }

  @override
  String stageName() {
    return 'સ્ટેજ નામ';
  }

  @override
  String stageCode() {
    return 'સ્ટેજ કોડ';
  }

  @override
  String remove() {
    return 'દૂર કરો';
  }

  @override
  String appUsageUsers() {
    return 'એપ્લિકેશન ઉપયોગકર્તા';
  }

  @override
  String contactHasNoPhoneNumber() {
    return 'સંપર્કનો કોઈ ફોન નંબર નથી';
  }

  @override
  String choosePhoneNumber() {
    return 'ફોન નંબર પસંદ કરો';
  }

  @override
  String choosePhoneAndEmail() {
    return 'ફોન અને ઇમેઇલ પસંદ કરો';
  }

  @override
  String problem() {
    return 'સમસ્યા';
  }

  @override
  String failure() {
    return 'નિષ્ફળતા';
  }

  @override
  String unSupportedAdminUserForApp() {
    return 'કૃપા કરીને લોગ-ઇન કરવા માટે સિયેસ્ટા એડમિન એપનો ઉપયોગ કરો.';
  }

  @override
  String unSupportedMemberUserForApp() {
    return 'કૃપા કરીને લોગ-ઇન કરવા માટે સિયેસ્ટા મેમ્બર એપનો ઉપયોગ કરો.';
  }

  @override
  String contactsPermissionNotAvailable() {
    return 'સંપર્કોની પરવાનગી ઉપલબ્ધ નથી';
  }

  @override
  String contactAlreadyAvailableInList() {
    return 'સંપર્ક પહેલાથી જ સૂચિમાં ઉપલબ્ધ છે';
  }

  @override
  String warning() {
    return 'ચેતવણી';
  }

  @override
  String noAssociateMembersAdded() {
    return 'હજી સુધી કોઈ સહયોગી સભ્યો ઉમેર્યા નથી. 8 સભ્યો સુધી ઉમેરી શકાય છે';
  }

  @override
  String rejected() {
    return 'નામંજૂર';
  }

  @override
  String appAssociatesList() {
    return 'એપ્લિકેશન સહયોગીની સૂચિ';
  }

  @override
  String wantsToAddAssociateMember() {
    return 'સહયોગી સભ્ય ઉમેરવા માંગે છે';
  }

  @override
  String wantsToAdd() {
    return 'ઉમેરવા માંગે છે';
  }

  @override
  String associateMember() {
    return 'સહયોગી સભ્ય';
  }

  @override
  String associateMembersRequest() {
    return 'સહયોગી સભ્યની વિનંતી';
  }

  @override
  String accept() {
    return 'સ્વીકાર';
  }

  @override
  String reject() {
    return 'નામંજૂર';
  }

  @override
  String accepted() {
    return 'સ્વીકૃત';
  }

  @override
  String selectAtleastOneActivity() {
    return 'ઓછામાં ઓછી એક પ્રવૃત્તિ પસંદ કરો';
  }

  @override
  String cameraPermissionNotAvailable() {
    return 'કાર્ય કરવા માટે કેમેરાની પરવાનગી જરૂરી છે';
  }

  @override
  String storagePermissionNotAvailable() {
    return 'કાર્ય કરવા માટે સ્ટોરેજની પરવાનગી જરૂરી છે';
  }
}

class _Eng extends AppString {
  @override
  String appHeadingAdmin() {
    return APP_NAME_ADMIN;
  }

  @override
  String appHeadingMember() {
    return APP_NAME_MEMBER;
  }

  @override
  String plotOwnerRegistration() {
    return 'Siesta Plot Owner Registration';
  }

  @override
  String appSubHeading() {
    return 'Siesta Plot Owner Association (SPOA)';
  }

  @override
  String appUpdateAvailable() {
    return 'App Update is available';
  }

  @override
  String lastInterval() {
    return 'Last Interval';
  }

  @override
  String images() {
    return 'Images';
  }

  @override
  String after() {
    return 'After';
  }

  @override
  String more() {
    return 'more';
  }

  @override
  String before() {
    return 'Before';
  }

  @override
  String viewAll() {
    return 'View All';
  }

  @override
  String visibleSuperAdminViews() {
    return 'Visible Super Admin Views';
  }

  @override
  String superAdminViews() {
    return 'Super Admin Views';
  }

  @override
  String imagesList() {
    return 'Images List';
  }

  @override
  String expandedByDefault() {
    return 'Expanded By Default';
  }

  @override
  String expandableList() {
    return 'Expandable List';
  }

  @override
  String confirmAddNewSchedulers() {
    return 'Are you sure want to add new Schedulers';
  }

  @override
  String validateSchedulerData() {
    return 'Provide correct Scheduler data';
  }

  @override
  String validateEmptySchedulerData() {
    return 'Add Activity Schedulers before submit';
  }

  @override
  String selectDate() {
    return 'Select Date';
  }

  @override
  String selectSchedule() {
    return 'Select Schedule';
  }

  @override
  String clearAll() {
    return 'Clear all';
  }

  @override
  String clickToAddNewActivityToScheduler() {
    return 'Click to add new Activity to Scheduler';
  }

  @override
  String goBack() {
    return 'Go back';
  }

  @override
  String emptyData() {
    return 'No data available';
  }

  @override
  String selectPlot() {
    return 'Select Plot';
  }

  @override
  String add() {
    return 'Add';
  }

  @override
  String loginSuccess() {
    return 'Login Success';
  }

  @override
  String pleaseEnterOTP() {
    return 'Please enter OTP';
  }

  @override
  String activityMainDetailEditInEnglishOnly() {
    return 'Can be edited only when App global language is English';
  }

  @override
  String addTranslation() {
    return 'Add translation';
  }

  @override
  String connectivityProblem() {
    return 'Connectivity Problem';
  }

  @override
  String pendingMemberApproval() {
    return 'Pending Member Approval';
  }

  @override
  String administration() {
    return 'Administration';
  }

  @override
  String usersList() {
    return 'Users List';
  }

  @override
  String users() {
    return 'Users';
  }

  @override
  String confirmMarkAsStarted() {
    return 'Are you sure want to start the Activity';
  }

  @override
  String updateActivity() {
    return 'Update Activity';
  }

  @override
  String maxSkipTimeoutDays() {
    return 'Max Skip Timeout Days';
  }

  @override
  String yes() {
    return 'Yes';
  }

  @override
  String addNewActivity() {
    return 'Add New Activity';
  }

  @override
  String alreadyAMemberLogin() {
    return 'Already a member? Login here';
  }

  @override
  String notAMemberYetRegister() {
    return 'Not a member yet? Register here.';
  }

  @override
  String markComplete() {
    return 'Mark Complete';
  }

  @override
  String start() {
    return 'Start';
  }

  @override
  String completed() {
    return 'Completed';
  }

  @override
  String success() {
    return 'Success';
  }

  @override
  String confirmTaskCompleteMessage() {
    return 'Are you sure want to mark the task as Complete?';
  }

  @override
  String done() {
    return 'Done';
  }

  @override
  String addNewScheduler() {
    return 'Add New Scheduler';
  }

  @override
  String message() {
    return 'Message';
  }

  @override
  String updating() {
    return 'Updating';
  }

  @override
  String times() {
    return 'time(s)';
  }

  @override
  String change() {
    return 'Change';
  }

  @override
  String update() {
    return 'Update';
  }

  @override
  String plotNo() {
    return 'Plot No';
  }

  @override
  String plotDetail() {
    return 'Plot Detail';
  }

  @override
  String scheduler() {
    return 'Scheduler';
  }

  @override
  String description() {
    return 'Description';
  }

  @override
  String activity() {
    return 'Activity';
  }

  @override
  String detail() {
    return 'Detail';
  }

  @override
  String editActivitySchedule() {
    return 'Edit Activity Schedule';
  }

  @override
  String disabled() {
    return 'Disabled';
  }

  @override
  String active() {
    return 'Active';
  }

  @override
  String every() {
    return 'Every';
  }

  @override
  String schedule() {
    return 'Schedule';
  }

  @override
  String activities() {
    return 'Activities';
  }

  @override
  String activityScheduler() {
    return 'Activity Scheduler';
  }

  @override
  String module() {
    return 'Module';
  }

  @override
  String moduleListPages() {
    return 'Module List Pages';
  }

  @override
  String status() {
    return 'Status';
  }

  @override
  String date() {
    return 'Date';
  }

  @override
  String schdledDate() {
    return 'Schdld Date';
  }

  @override
  String dev() {
    return 'Dev';
  }

  @override
  String scheduledOn() {
    return 'Scheduled On';
  }

  @override
  String scheduledAt() {
    return 'Scheduled At';
  }

  @override
  String owner() {
    return 'Owner';
  }

  @override
  String completedOn() {
    return 'Completed On';
  }

  @override
  String startedOn() {
    return 'Started On';
  }

  @override
  String notCompletedYet() {
    return 'Not Completed Yet';
  }

  @override
  String notStartedYet() {
    return 'Not Started Yet';
  }

  @override
  String instructions() {
    return 'Instructions';
  }

  @override
  String notAssigned() {
    return 'Not Assigned';
  }

  @override
  String assignedBy() {
    return 'Assigned By';
  }

  @override
  String additionalInfo() {
    return 'Additional Info';
  }

  @override
  String additionalInformation() {
    return 'Additional Information';
  }

  @override
  String slip() {
    return 'Slip';
  }

  @override
  String plot() {
    return 'Plot';
  }

  @override
  String assignedTo() {
    return 'Assigned To';
  }

  @override
  String somethingWentWrong() {
    return 'Something went wrong';
  }

  @override
  String retry() {
    return 'Retry';
  }

  @override
  String refresh() {
    return 'Refresh';
  }

  @override
  String pleaseLoginAgainYourLoginSessionIsExpired() {
    return 'Please Login again. Your login session expired.';
  }

  @override
  String sessionExpired() {
    return 'Session Expired';
  }

  @override
  String ok() {
    return 'OK';
  }

  @override
  String mobile() {
    return 'Mobile';
  }

  @override
  String cancel() {
    return 'Cancel';
  }

  @override
  String logout() {
    return 'Logout';
  }

  @override
  String areYouSureWantToLogout() {
    return 'Are you sure want to logout?';
  }

  @override
  String confirm() {
    return 'Confirm';
  }

  @override
  String verify() {
    return 'Verify';
  }

  @override
  String language() {
    return 'Language';
  }

  @override
  String settings() {
    return 'Settings';
  }

  @override
  String verifyOTP() {
    return 'Verify OTP';
  }

  @override
  String initPleaseWait() {
    return 'Initializing. Please wait...';
  }

  @override
  String siestaAMSAdmin() {
    return 'Siesta AMS Admin';
  }

  @override
  String pleaseWait() {
    return 'Please wait...';
  }

  @override
  String register() {
    return 'Register';
  }

  @override
  String login() {
    return 'Login';
  }

  @override
  String hintEmail() {
    return 'Email*';
  }

  @override
  String hintFullName() {
    return 'FullName*';
  }

  @override
  String hintMobile() {
    return 'Mobile*';
  }

  @override
  String email() {
    return 'Email';
  }

  @override
  String assets() {
    return 'Assets';
  }

  @override
  String mo() {
    return 'Mo';
  }

  @override
  String tu() {
    return 'Tu';
  }

  @override
  String we() {
    return 'We';
  }

  @override
  String th() {
    return 'Th';
  }

  @override
  String fr() {
    return 'Fr';
  }

  @override
  String sa() {
    return 'Sa';
  }

  @override
  String su() {
    return 'Su';
  }

  @override
  String autoSchedulable() {
    return 'Auto Schedulable';
  }

  @override
  String day() {
    return 'Day';
  }

  @override
  String month() {
    return 'Month';
  }

  @override
  String week() {
    return 'Week';
  }

  @override
  String or() {
    return 'Or';
  }

  @override
  String arbitrary() {
    return 'Arbitrary';
  }

  @override
  String arbitrarily() {
    return 'Arbitrarily';
  }

  @override
  String uploads() {
    return 'Uploads';
  }

  @override
  String noPendingUploads() {
    return 'No Pending Uploads';
  }

  @override
  String actions() {
    return 'Actions';
  }

  @override
  String by() {
    return 'By';
  }

  @override
  String removeCompleted() {
    return 'Remove Completed';
  }

  @override
  String sort() {
    return 'Sort';
  }

  @override
  String admin() {
    return 'Admin';
  }

  @override
  String type() {
    return 'Type';
  }

  @override
  String reportPage() {
    return 'Report';
  }

  @override
  String homePage() {
    return 'Home';
  }

  @override
  String morePage() {
    return 'More';
  }

  @override
  String monthlyReport() {
    return 'Monthly Report';
  }

  @override
  String notifiedActivity() {
    return 'Notified Task';
  }

  @override
  String notified() {
    return 'Notified';
  }

  @override
  String comment() {
    return 'Comment';
  }

  @override
  String tentativeDeadline() {
    return 'Tentative Deadline';
  }

  @override
  String groupPriority() {
    return 'Group Priority';
  }

  @override
  String submit() {
    return 'Submit';
  }

  @override
  String priorityActivity() {
    return 'Priority Task';
  }

  @override
  String imageRequired() {
    return 'Is Image Required?';
  }

  @override
  String name() {
    return 'Name';
  }

  @override
  String number() {
    return 'Number';
  }

  @override
  String wantToAddNewAsset() {
    return 'You want to add new Asset/Property?';
  }

  @override
  String wantToUpdateAsset() {
    return 'Want to update the Asset/Property?';
  }

  @override
  String list() {
    return 'List';
  }

  @override
  String pendingAndBlocked() {
    return 'Pending & Blocked';
  }

  @override
  String authenticationRoles() {
    return 'Authentication Roles';
  }

  @override
  String canAdd() {
    return 'Can Add';
  }

  @override
  String canView() {
    return 'Can View';
  }

  @override
  String canUpdate() {
    return 'Can Update';
  }

  @override
  String permissions() {
    return 'Permissions';
  }

  @override
  String collapse() {
    return 'Collapse';
  }

  @override
  String expand() {
    return 'Expand';
  }

  @override
  String roleCode() {
    return 'Role Code';
  }

  @override
  String roleName() {
    return 'Role Name';
  }

  @override
  String pendingMemberRequests() {
    return 'Pending Member Requests';
  }

  @override
  String delayDeadline() {
    return 'Delay Deadline';
  }

  @override
  String scheduledDate() {
    return 'Scheduled Date';
  }

  @override
  String dashboardTypes() {
    return 'Dashboard Types';
  }

  @override
  String newUserRequests() {
    return 'New User Requests';
  }

  @override
  String blocked() {
    return 'Blocked';
  }

  @override
  String pending() {
    return 'Pending';
  }

  @override
  String requests() {
    return 'Requests';
  }

  @override
  String maintenanceTask() {
    return 'Maintenance Task';
  }

  @override
  String propertyType() {
    return 'Property Type';
  }

  @override
  String profile() {
    return 'Profile';
  }

  @override
  String yourAuthStatusIsPending() {
    return 'Your Authentication Status is Pending. Please wait till your request is approved.';
  }

  @override
  String undefinedDashboardDetected() {
    return 'Undefined Dashboard is set for the current User. Please update the App or reload the page.';
  }

  @override
  String errorEmail() {
    return 'Please use valid Email';
  }

  @override
  String errorFullName() {
    return 'FullName must be of length 5 or more';
  }

  @override
  String validateFormData() {
    return 'Please validate form data';
  }

  @override
  String ownership() {
    return 'Ownership';
  }

  @override
  String history() {
    return 'History';
  }

  @override
  String activityStagesReport() {
    return 'Activity Stages Report';
  }

  @override
  String stage() {
    return 'Stage';
  }

  @override
  String translation() {
    return 'Translation';
  }

  @override
  String others() {
    return 'Others';
  }

  @override
  String activityStages() {
    return 'Activity Stages';
  }

  @override
  String autoRemovableByScheduler() {
    return 'Auto Removable by Scheduler';
  }

  @override
  String stageCode() {
    return 'Stage Code';
  }

  @override
  String stageName() {
    return 'Stage Name';
  }

  @override
  String remove() {
    return 'Remove';
  }

  @override
  String appUsageUsers() {
    return 'App Usage Users';
  }

  @override
  String contactHasNoPhoneNumber() {
    return 'Contact has no phone number';
  }

  @override
  String choosePhoneNumber() {
    return 'Choose Phone number';
  }

  @override
  String choosePhoneAndEmail() {
    return 'Choose Phone and Email';
  }

  @override
  String problem() {
    return 'Problem';
  }

  @override
  String failure() {
    return 'Failure';
  }

  @override
  String unSupportedAdminUserForApp() {
    return 'Please use Siesta Admin App to Login.';
  }

  @override
  String unSupportedMemberUserForApp() {
    return 'Please use Siesta Member App to Login.';
  }

  @override
  String contactsPermissionNotAvailable() {
    return 'Contacts permission not available.';
  }

  @override
  String contactAlreadyAvailableInList() {
    return 'Contact already available in list';
  }

  @override
  String warning() {
    return 'Warning';
  }

  @override
  String noAssociateMembersAdded() {
    return 'No Associate members added yet. Upto 8 members can be added';
  }

  @override
  String rejected() {
    return 'Rejected';
  }

  @override
  String appAssociatesList() {
    return 'App Associates List';
  }

  @override
  String wantsToAddAssociateMember() {
    return 'wants to add Associate Member.';
  }

  @override
  String wantsToAdd() {
    return 'wants to add';
  }

  @override
  String associateMember() {
    return 'Associate Member';
  }

  @override
  String associateMembersRequest() {
    return "Associate Member's Request";
  }

  @override
  String accept() {
    return 'Accept';
  }

  @override
  String reject() {
    return 'Reject';
  }

  @override
  String accepted() {
    return 'Accepted';
  }

  @override
  String selectAtleastOneActivity() {
    return 'Select at least one Activity';
  }

  @override
  String cameraPermissionNotAvailable() {
    return 'Camera permission required to perform the task.';
  }

  @override
  String storagePermissionNotAvailable() {
    return 'Storage permission required to perform the task.';
  }
}
