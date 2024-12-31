import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View_Model/Auth_View_Model/Login_View_Model/login_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:sizer/sizer.dart';

import '../PlotOwnerRegisterPage/plotOwnerRegisterPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileStr = TextEditingController();
  FocusNode mobileFocus = FocusNode();
  bool _btLoginEnable = true;
  String? _mobile;
  final _formKey = GlobalKey<FormState>();
  final TapGestureRecognizer _tapRecognizer = TapGestureRecognizer();

  void initState() {
    super.initState();
  }

  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  String? validateMobile(String? value) {
// Indian Mobile number are of 10 digit only
    if (value?.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent.shade100.withOpacity(0.8),
      body: Container(
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
                child: Center(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 54,
                      ),
                      Flexible(
                        child: Container(
                          child: Card(
                            color: Colors.white.withOpacity(0.9),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image(
                                      height: 150,
                                      alignment: Alignment.center,
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'asset/images/work_management.png'),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppString.get(context).appHeadingAdmin(),
                                      style: TextStyle(
                                        fontSize: headerFontSize,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: mobileStr,
                                    enabled: _btLoginEnable,
                                    keyboardType: TextInputType.phone,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        labelText:
                                            AppString.get(context).hintMobile(),
                                        suffixIcon: Icon(Icons.phone_android)),
                                    enableSuggestions: true,
                                    validator: validateMobile,
                                    onSaved: (value) {
                                      _mobile = value!;
                                    },
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  // _btLoginEnable

                                  authViewModel.loading
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            ElevatedButton(
                                              onPressed: null,
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .disabledColor,
                                                  backgroundColor:
                                                      Colors.deepOrangeAccent),
                                              child: Text(AppString.get(context)
                                                  .pleaseWait()),
                                            ),
                                            CircularProgressIndicator(),
                                          ],
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            authViewModel.loginApi(
                                                mobileStr.text.toString(),
                                                context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor:
                                                  Colors.deepOrangeAccent,
                                              backgroundColor:
                                                  Colors.deepOrangeAccent),
                                          child: Text(
                                            AppString.get(context).login(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),

                                  SizedBox(
                                    height: 12,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Colors
                                              .black), // Style for the regular text
                                      children: [
                                        TextSpan(
                                            text: 'Register As a Plot Owner? '),
                                        TextSpan(
                                          text: 'Click Here',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PlotOwnerRegisterScreen()));
                                            },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 44,
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
