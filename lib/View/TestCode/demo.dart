import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ApiResponse {
  final bool status;
  final String message;
  final List<Data> data;

  ApiResponse(
      {required this.status, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Data> dataList = list.map((i) => Data.fromJson(i)).toList();

    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }
}

class Data {
  final int schedulerId;
  final String activityName;
  final String propertyNumber;

  Data({
    required this.schedulerId,
    required this.activityName,
    required this.propertyNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      schedulerId: json['schedulerId'],
      activityName: json['activityName'],
      propertyNumber: json['propertyNumber'],
    );
  }
}

class MyApp extends StatelessWidget {
  final String apiResponse = '''
    {
      "status": true,
      "message": "successfully fetched ScheduledActivitylist",
      "data": [
          {
              "schedulerId": 78701,
              "activityName": "Watering in Plants in flower bed",
              "propertyNumber": "P70"
          },
          {
              "schedulerId": 78716,
              "activityName": "Bathroom/Toilet cleaning",
              "propertyNumber": "P71"
          },
          {
              "schedulerId": 78657,
              "activityName": "Compound Hard Surface Cleaning",
              "propertyNumber": "Swimming pool"
          },
          {
              "schedulerId": 78144,
              "activityName": "Swimming Pool Clening",
              "propertyNumber": "Swimming pool"
          },
          {
              "schedulerId": 78713,
              "activityName": "Filters Maintenance",
              "propertyNumber": "Swimming pool"
          }
      ],
      "meta": null
    }
  ''';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ExpansionTile Grouping Example'),
        ),
        body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 1),
              () => ApiResponse.fromJson(json.decode(apiResponse))),
          builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView(
                children: _buildExpansionTiles(snapshot.data!.data),
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildExpansionTiles(List<Data> data) {
    Map<String, List<Data>> groupedData = {};

    // Group data by propertyNumber
    data.forEach((element) {
      if (!groupedData.containsKey(element.propertyNumber)) {
        groupedData[element.propertyNumber] = [];
      }
      groupedData[element.propertyNumber]!.add(element);
    });

    return groupedData.entries.map<Widget>((entry) {
      return ExpansionTile(
        title: Text(entry.key),
        children: entry.value.map<Widget>((data) {
          return ListTile(
            title: Text(data.activityName),
          );
        }).toList(),
      );
    }).toList();
  }
}
