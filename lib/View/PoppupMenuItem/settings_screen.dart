// import 'dart:async';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:siestaamsapp/Model/More_Model/languageList_model.dart';
// import 'package:siestaamsapp/Provider/app_language_provider.dart';
// import 'package:siestaamsapp/Res/colors.dart';
// import 'package:siestaamsapp/Utils/utils.dart' as Util;
// import 'package:siestaamsapp/Utils/utils.dart';
// import 'package:siestaamsapp/constants/string_res.dart';

// import '../main_admin_providers.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         backgroundColor: appPrimaryColor,
//         titleSpacing: 0,
//         title: Text(
//           AppString.get(context).settings(),
//           style: TextStyle(fontSize: headerFontSize, color: Colors.white),
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraint) {
//           return Container(
//             color: Colors.grey.shade200,
//             height: constraint.maxHeight,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Padding(
//                     padding:
//                         EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
//                     child: _LanguageCard(),
//                   ),
//                   Padding(
//                     padding:
//                         EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
//                     child: _ExpandableListExpandedView(),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _LanguageCard extends StatefulWidget {
//   @override
//   State createState() => _LanguageCardState();
// }

// class _LanguageCardState extends State<_LanguageCard> {
//   late AppLanguageProvider _appStringProvider;
//   List<Language> _langList = [];
//   dynamic _error1;
//   late StreamSubscription<DatabaseEvent> _dispose1;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _reInitFbDb();
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _appStringProvider =
//         Provider.of<AppLanguageProvider>(context, listen: true);
//   }

//   @override
//   void dispose() {
//         _dispose1.cancel();
//     // _dispose2.cancel();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(8),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Text(
//               AppString.get(context).language(),
//               style: TextStyle(
//                 fontSize: headerFontSize,
//               ),
//             ),
//             Divider(
//               color: Colors.grey,
//             ),
//             if (_error1 != null)
//               Util.getErrorView(
//                 context,
//                 error: Util.getErrorMessage(context, _error1),
//               ),
//             if (_langList.isEmpty && _error1 == null)
//               Util.getProgressView(context),
//             for (var iteration in _langList)
//               Row(
//                 children: <Widget>[
//                   Radio<String>(
//                     groupValue: _appStringProvider.getCurrentAppLanguage,
//                     value: iteration.languageCode.toString(),
//                     onChanged:
//                         iteration.isActive == 1 ? _handleLanguageChange : null,
//                   ),
//                   Text(
//                     iteration.name.toString(),
//                     style: TextStyle(
//                         color: iteration.isActive == 1
//                             ? Colors.black
//                             : Theme.of(context).disabledColor,
//                         fontWeight: iteration.isActive == 1
//                             ? FontWeight.bold
//                             : FontWeight.normal),
//                   )
//                 ],
//               )
//           ],
//         ),
//       ),
//     );
//   }

//   void _listener1(DatabaseEvent event) {
//     setState(() {
//       _langList.clear();
//       _langList.addAll(_appStringProvider.getLanguageList(listEvent: event));
//       _error1 = null;
//     });
//   }

//   void _errorListener1(dynamic error) {
//     setState(() {
//       _error1 = error;
//     });
//   }

//   void _handleLanguageChange(String? value) {
//     _appStringProvider.changeLanguage(value!);
//   }

//   void _reInitFbDb() {
//     _dispose1 = _appStringProvider.getLanguageListStream
//         .listen(_listener1, onError: _errorListener1);
//     // _dispose2 = _appStringProvider.getCurrentLanguageStream.listen(_listener2);
//   }
// }

// class _ExpandableListExpandedView extends StatefulWidget {
//   @override
//   State createState() => _ExpandableListExpandedViewState();
// }

// class _ExpandableListExpandedViewState
//     extends State<_ExpandableListExpandedView> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Text(
//               AppString.get(context).expandableList(),
//               style: TextStyle(
//                 fontSize: headerFontSize,
//               ),
//             ),
//             Divider(
//               color: Colors.grey,
//             ),
//             Row(
//               children: <Widget>[
//                 Consumer<ExpandableListSettingProvider>(
//                   builder: (context, provider, widget) {
//                     return Checkbox(
//                       value: provider.isListExpandedByDefault,
//                       onChanged: provider.changeExpandedByDefault,
//                     );
//                   },
//                 ),

//                 SizedBox(
//                   width: 8,
//                 ),
//                 Text(
//                   AppString.get(context).expandedByDefault(),
//                   style: Theme.of(context).textTheme.subtitle1,
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Provider/app_language_provider.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../Utils/utils.dart';
import '../Siesta_Admin/Main_Admin/main_admin.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed:(){

                      Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePageAdmin()));


          }
          
          //  () => Navigator.pop(context,true),


        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).settings(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
            color: Colors.grey.shade200,
            height: constraint.maxHeight,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: _LanguageCard(),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(8),
                  //   child: _ExpandableListExpandedView(),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(
      builder: (context, appLanguageProvider, child) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  AppString.get(context).language(),
                  style: TextStyle(
                    fontSize: headerFontSize,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                ...appLanguageProvider.getLanguageList.map((language) => 
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        groupValue: appLanguageProvider.getCurrentAppLanguage,
                        value: language.languageCode.toString(),
                        onChanged: language.isActive == 1 
                          ? (String? value) {
                              if (value != null) {
                                appLanguageProvider.changeLanguage(value);
                              }
                            } 
                          : null,
                      ),
                      Text(
                        language.name.toString(),
                        style: TextStyle(
                          color: language.isActive == 1
                              ? Colors.black
                              : Theme.of(context).disabledColor,
                          fontWeight: language.isActive == 1
                              ? FontWeight.bold
                              : FontWeight.normal
                        ),
                      )
                    ],
                  )
                ).toList()
              ],
            ),
          ),
        );
      },
    );
  }
}

// Rest of the code remains the same as in the original file
