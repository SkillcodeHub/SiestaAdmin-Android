library siesta_admin.globals;

import 'package:flutter/foundation.dart';

const String urlProduction = 'http://app.siestaleisurehomes.com';
// const String urlDev = 'http://10.0.2.2:3000';
const String urlDev = 'http://app.siestaleisurehomes.com';
const String urlCurrent = kDebugMode ? urlDev : urlProduction;

enum AppTypes { SIESTA_CMS, SIESTA_MEMBER }
