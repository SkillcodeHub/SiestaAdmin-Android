import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Calender/date_utils.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View_Model/Auth_View_Model/Login_View_Model/login_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class OtpVerifyScreen extends StatefulWidget {
  final dynamic mobile;

  const OtpVerifyScreen({super.key, required this.mobile});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String? fcmToken;
  List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  FocusNode otpFocusNode = FocusNode();

  get headerFontSize => null;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String mobile = widget.mobile['Mobile'].toString();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          AppString.get(context).verifyOTP(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.all(8),
        child: Center(
          child: Container(
            child: VerifyOtpForm(
              mobile: mobile,
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyOtpForm extends StatefulWidget {
  final String mobile;
  const VerifyOtpForm({super.key, required this.mobile});

  @override
  State<StatefulWidget> createState() {
    return _VerifyOtpFormState();
  }
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  bool _showProgress = false;
  final key = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  String? _otp;

  void _verifyOtpAction() {
    setState(() {
      _showProgress = true;
    });
  }

  void _syncOTP() {
    _otp = _otpController.text;
  }

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_syncOTP);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    String mobile = widget.mobile;
    return Form(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 16),
              Text(
                AppString.get(context).pleaseEnterOTP(),
                style: TextStyle(
                  fontSize: headerFontSize,
                ),
              ),
              SizedBox(height: 16),
              Container(
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.primary,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    selectedFillColor: Theme.of(context).colorScheme.primary,
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  controller: _otpController,
                  autoFocus: true,
                  onCompleted: (value) {
                    _otp = value;
                    Map data = {
                      "otpNumber": _otp.toString(),
                      "mobile": mobile.toString(),
                    };
                    authViewModel.otpVerifyApi(data, context);
                  },
                  onChanged: (value) {
                    setState(() {
                      _otp = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              authViewModel.signUpLoading
                  ? Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(context).disabledColor,
                          ),
                          onPressed: _showProgress ? null : _verifyOtpAction,
                          child: Text(AppString.get(context).pleaseWait()),
                        ),
                        CircularProgressIndicator()
                      ],
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: _showProgress
                              ? Theme.of(context).disabledColor
                              : appSecondaryColor,
                          backgroundColor: Colors.deepOrangeAccent),
                      onPressed: () async {
                        String enteredOTP = _otp.toString();
                        if (enteredOTP.length != 6) {
                          print("Entered OTP: $enteredOTP");
                          Utils.flushBarErrorMessage(
                              'Please enter a 6-digit OTP*',
                              Duration(seconds: 2),
                              context);
                        } else {
                          print("Entered OTP: $enteredOTP");

                          Map data = {
                            "otpNumber": _otp.toString(),
                            "mobile": mobile.toString(),
                          };
                          authViewModel.otpVerifyApi(data, context);

                          ;
                        }
                      },
                      child: Text(
                        AppString.get(context).verify(),
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Colors.white),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
