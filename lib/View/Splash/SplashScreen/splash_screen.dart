import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/Splash/SplashServices/splash_services.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splasheSrvices = SplashServices();

  @override
  void initState() {
    super.initState();
    splasheSrvices.checkAuthentication(context);
    Timer(
      Duration(seconds: 1),
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('asset/images/main_bg.png'),
            ),
          ),
          child: Stack(
            children: <Widget>[
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.35),
                  ),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Card(
                    margin: EdgeInsets.all(16),
                    color: Colors.white70,
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              AppString.get(context).appHeadingAdmin(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.black),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              AppString.get(context).appSubHeading(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 48,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
