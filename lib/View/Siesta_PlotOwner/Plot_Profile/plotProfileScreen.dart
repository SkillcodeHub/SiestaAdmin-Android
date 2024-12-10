import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../../Model/More_Model/getUsersList_model.dart';
import '../../../Utils/Calender/date_utils.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/utils.dart';
import '../../../constants/string_res.dart';

// class PlotProfileScreen extends StatefulWidget {
//   const PlotProfileScreen({super.key});

//   @override
//   State<PlotProfileScreen> createState() => _PlotProfileScreenState();
// }

// class _PlotProfileScreenState extends State<PlotProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }



class DashboardProfile extends StatefulWidget {
  DashboardProfile({Key ? key}) : super(key: key);

  @override
  DashboardProfileState createState() {
    return DashboardProfileState();
  }
}

class DashboardProfileState extends State<DashboardProfile> {
  // Utils.PageStatus pageStatus = Utils.PageStatus.IDLE;
  dynamic pageError;
  User ?oldUser, newUser;
  late TextEditingController emailCtrl, nameCtrl;
  final _formKey = GlobalKey<FormState>();
  // NetworkApi networkApi;

  @override
  void initState() {
    super.initState();
    // networkApi = Provider.of<NetworkApi>(context, listen: false);
    emailCtrl = TextEditingController();
    nameCtrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reloadProfile();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppString.get(context).profile(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed:
                                _showUpdateButton() ? _updateProfile : null,
                            icon: Icon(Icons.save),
                            label: Text(
                              AppString.get(context).update(),
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: AppString.get(context).hintFullName(),
                            labelText: AppString.get(context).hintFullName(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          controller: nameCtrl,
                          onChanged: (value) {
                            setState(() {
                              newUser?.userFullname = value;
                            });
                          },
                          validator: (value) =>
                              value == null || value.length < 5
                                  ? AppString.get(context).errorFullName()
                                  : null,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: AppString.get(context).email(),
                            labelText: AppString.get(context).email(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          controller: emailCtrl,
                          onChanged: (value) {
                            setState(() {
                              newUser?.userEmail = value;
                            });
                          },
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : AppString.get(context).errorEmail(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reloadProfile() {
    setState(() {
      // pageStatus = Utils.PageStatus.PROGRESS;
    });

    // networkApi.getUserProfile(context: context).then((value) {
    //   if (value.status) {
    //     oldUser = User.fromJson(value.data);
    //     nameCtrl.text = oldUser.userFullname!;
    //     emailCtrl.text = oldUser.userEmail!;
    //     newUser = oldUser.copyWith();
    //     setState(() {
    //       pageStatus = Utils.PageStatus.SUCCESS;
    //     });
    //   } else {
    //     setState(() {
    //       pageStatus = Utils.PageStatus.ERROR;
    //       pageError = value.message;
    //     });
    //   }
    // }).catchError((error) {
    //   setState(() {
    //     pageStatus = Utils.PageStatus.ERROR;
    //     pageError = error;
    //   });
    // });
  }

  void _updateProfile() {
    // if (_formKey.currentState.validate()) {
    //   showDialog(
    //       context: context,
    //       builder: (c) {
    //         return Utils.getAlertDialog(
    //           context,
    //           null,
    //           AppString.get(context).confirm(),
    //           negativeText: AppString.get(context).cancel(),
    //           negativeButton: () => Navigator.of(context).pop(false),
    //           positiveButton: () => Navigator.of(context).pop(true),
    //           positiveText: AppString.get(context).update(),
    //         );
    //       }).then((value) {
    //     if (value == null || !value) {
    //       return;
    //     }

    //     showDialog(
    //         context: context,
    //         builder: (c) {
    //           return Utils.getProgressDialog(context);
    //         });
    //     networkApi
    //         .updateUserProfile(
    //       context: context,
    //       fullName: nameCtrl.text,
    //       email: emailCtrl.text,
    //     )
    //         .then((value) {
    //       Navigator.pop(context);
    //       if (value.status) {
    //         reloadProfile();
    //       } else {
    //         Utils.showSnackMessage(
    //             context, Utils.getErrorMessage(context, value.message));
    //       }
    //     }).catchError((error) {
    //       Navigator.pop(context);
    //       Utils.showSnackMessage(
    //           context, Utils.getErrorMessage(context, error));
    //     });
    //   });
    // } else {
    //   Utils.showSnackMessage(
    //       context,
    //       Utils.getErrorMessage(
    //           context, AppString.get(context).validateFormData()));
    // }
  
  
  
  }

  bool _showUpdateButton() {
    return newUser != oldUser;
  }
}
