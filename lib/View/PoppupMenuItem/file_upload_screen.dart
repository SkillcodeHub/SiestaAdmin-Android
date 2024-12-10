import 'package:flutter/material.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../Utils/utils.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).uploads(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {},
            tooltip: AppString.get(context).sort(),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_sweep,
              color: Colors.white,
            ),
            tooltip: AppString.get(context).removeCompleted(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
