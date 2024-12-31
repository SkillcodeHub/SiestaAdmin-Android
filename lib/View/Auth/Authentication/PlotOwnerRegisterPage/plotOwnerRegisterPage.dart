import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../Data/Response/status.dart';
import '../../../../Utils/Widgets/errorScreen_widget.dart';
import '../../../../Utils/utils.dart';
import '../../../../View_Model/Auth_View_Model/OwnerRegistration_View_Model/addOwnerRequest_view_model.dart';
import '../../../../View_Model/Auth_View_Model/OwnerRegistration_View_Model/ownerRegistrationPlotList_view_model.dart';
import '../../../../constants/string_res.dart';
import '../LoginPage/login_screen.dart';

class PlotOwnerRegisterScreen extends StatefulWidget {
  const PlotOwnerRegisterScreen({super.key});

  @override
  State<PlotOwnerRegisterScreen> createState() =>
      _PlotOwnerRegisterScreenState();
}

class _PlotOwnerRegisterScreenState extends State<PlotOwnerRegisterScreen> {
  String? selectedPlot;
  String? plotId;
  final _formKey = GlobalKey<FormState>();
  bool showFamilyDetails = false;
  late Future<void> fetchDataFuture;

  // Sample plot numbers - replace with your actual data

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _familyName1Controller = TextEditingController();
  final TextEditingController _familyMobile1Controller =
      TextEditingController();
  final TextEditingController _familyName2Controller = TextEditingController();
  final TextEditingController _familyMobile2Controller =
      TextEditingController();
  final TextEditingController _familyName3Controller = TextEditingController();
  final TextEditingController _familyMobile3Controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final ownerRegistrationPlotListViewmodel =
          Provider.of<OwnerRegistrationPlotListViewmodel>(context,
              listen: false);
      ownerRegistrationPlotListViewmodel.fetchOwnerRegistrationPlotListApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ownerRegistrationPlotListViewmodel =
        Provider.of<OwnerRegistrationPlotListViewmodel>(context);

    final addOwnerRequestViewModel =
        Provider.of<AddOwnerRequestViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(color: Colors.white),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              AppString.get(context).plotOwnerRegistration(),
              style: TextStyle(fontSize: headerFontSize, color: Colors.white),
            ),
          ],
        ),
      ),
      body: FutureBuilder<void>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          } else {
            // Render the UI with the fetched data
            return ChangeNotifierProvider<
                OwnerRegistrationPlotListViewmodel>.value(
              value: ownerRegistrationPlotListViewmodel,
              child: Consumer<OwnerRegistrationPlotListViewmodel>(
                builder: (context, value, _) {
                  switch (value.ownerRegistrationPlotList.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      // print(
                      //     'value.scheduledActivitiesList.message.toString()');
                      // print(value.scheduledActivitiesList.message);
                      // return ErrorScreenWidget(
                      //   onRefresh: () async {
                      //     fetchData();
                      //   },
                      //   loadingText:
                      //       value.scheduledActivitiesList.message.toString(),
                      // );

                      if (value.ownerRegistrationPlotList.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {
                            fetchData();
                          },
                          loadingText: value.ownerRegistrationPlotList.message
                              .toString(),
                        );
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        });
                        return Container();
                      }
                    case Status.COMPLETED:
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Card
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome!',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Please fill in the registration details below',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                // Registration Form Card
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        // Plot Number Dropdown

                                        DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black12),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black12),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          hint: Text(
                                            'Select a Plot No.',
                                            style: TextStyle(
                                                fontSize: descriptionFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade600),
                                          ),
                                          value: selectedPlot,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedPlot =
                                                  newValue.toString();
                                              print(
                                                  'Selected Plot ${selectedPlot}');

                                              final selectedData = value
                                                  .ownerRegistrationPlotList
                                                  .data!
                                                  .data!
                                                  .firstWhere(
                                                (data) =>
                                                    data.propertyName ==
                                                    newValue,
                                              );
                                              plotId =
                                                  selectedData.id.toString();
                                              // Print the selected details
                                              print(
                                                  "Selected doctorId: ${selectedData.id}");
                                              print(
                                                  "Selected doctorName: ${selectedData.propertyName}");
                                              print(plotId =
                                                  selectedData.id.toString());
                                            });
                                          },
                                          items: value.ownerRegistrationPlotList
                                              .data!.data!
                                              .map((data) {
                                            return DropdownMenuItem<String>(
                                              value: data.propertyName,
                                              child: Text(
                                                data.propertyName.toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        descriptionFontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            );
                                          }).toList(),
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select a plot number';
                                            }
                                            return null;
                                          },
                                        ),

                                        SizedBox(height: 20),

                                        // Owner Name TextField
                                        TextFormField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                            labelText: 'Plot Owner Name',
                                            prefixIcon: Icon(Icons.person,
                                                color: Colors.grey[800]),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[800]!),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter owner name';
                                            }
                                            return null;
                                          },
                                        ),

                                        SizedBox(height: 20),

                                        // Mobile Number TextField
                                        TextFormField(
                                          controller: _mobileController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            labelText: 'Mobile Number',
                                            prefixIcon: Icon(Icons.phone,
                                                color: Colors.grey[800]),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[800]!),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter mobile number';
                                            }
                                            return null;
                                          },
                                        ),

                                        SizedBox(height: 20),

                                        // Email TextField
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            prefixIcon: Icon(Icons.email,
                                                color: Colors.grey[800]),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[800]!),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter email';
                                            }
                                            return null;
                                          },
                                        ),

                                        SizedBox(height: 20),

                                        // Add Family Details Switch
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 60.w,
                                              child: Text(
                                                'Want To Add Family Members?',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                            Switch(
                                              value: showFamilyDetails,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  showFamilyDetails = value;

                                                  print(showFamilyDetails);
                                                });
                                              },
                                              activeColor:
                                                  Colors.deepOrangeAccent,
                                            ),
                                          ],
                                        ),

                                        // Family Details Section (Conditional)
                                        if (showFamilyDetails) ...[
                                          SizedBox(height: 20),

                                          // Family Member Name TextField
                                          TextFormField(
                                            controller: _familyName1Controller,
                                            decoration: InputDecoration(
                                              labelText: 'First Member Name',
                                              prefixIcon: Icon(
                                                  Icons.person_outline,
                                                  color: Colors.grey[800]),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[800]!),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (showFamilyDetails &&
                                                  (value == null ||
                                                      value.isEmpty)) {
                                                return 'Please enter family member name';
                                              }
                                              return null;
                                            },
                                          ),

                                          SizedBox(height: 20),

                                          // Family Mobile Number TextField
                                          TextFormField(
                                            controller:
                                                _familyMobile1Controller,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                              labelText: 'First Mobile Number',
                                              prefixIcon: Icon(
                                                  Icons.phone_android,
                                                  color: Colors.grey[800]),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[800]!),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (showFamilyDetails &&
                                                  (value == null ||
                                                      value.isEmpty)) {
                                                return 'Please enter family mobile number';
                                              }
                                              return null;
                                            },
                                          ),

                                          SizedBox(height: 20),

                                          // Family Member Name TextField
                                          TextFormField(
                                            controller: _familyName2Controller,
                                            decoration: InputDecoration(
                                              labelText: 'Second Member Name',
                                              prefixIcon: Icon(
                                                  Icons.person_outline,
                                                  color: Colors.grey[800]),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[800]!),
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 20),

                                          // Family Mobile Number TextField
                                          TextFormField(
                                            controller:
                                                _familyMobile2Controller,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                              labelText: 'Second Mobile Number',
                                              prefixIcon: Icon(
                                                  Icons.phone_android,
                                                  color: Colors.grey[800]),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[800]!),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),

                                          // Family Member Name TextField
                                          TextFormField(
                                            controller: _familyName3Controller,
                                            decoration: InputDecoration(
                                              labelText: 'Third Member Name',
                                              prefixIcon: Icon(
                                                  Icons.person_outline,
                                                  color: Colors.grey[800]),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[800]!),
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 20),

                                          // Family Mobile Number TextField
                                          TextFormField(
                                            controller:
                                                _familyMobile3Controller,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                              labelText: 'Third Mobile Number',
                                              prefixIcon: Icon(
                                                  Icons.phone_android,
                                                  color: Colors.grey[800]),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[800]!),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 30),

                                // Submit Button
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        print(showFamilyDetails ? "" : "self");
                                        print(
                                            showFamilyDetails ? "family" : "");
                                        Map data = {
                                          "pId": plotId,
                                          "fullName": _nameController.text,
                                          "mobile": _mobileController.text,
                                          "rModeSelf": showFamilyDetails
                                              ? ""
                                              : "self", // self
                                          "email": _emailController.text,
                                          "ifFamily":
                                              showFamilyDetails.toString(),
                                          "rModeFamily": showFamilyDetails
                                              ? "family"
                                              : "", // family
                                          "familyDetails": [
                                            {
                                              "familyName":_familyName1Controller.text.toString(),
                                              "familyMobileNo": _familyMobile1Controller.text.toString(),
                                            },
                                            {
                                              "familyName": _familyName2Controller.text.toString(),
                                              "familyMobileNo": _familyMobile2Controller.text.toString(),
                                            },
                                            {
                                              "familyName":_familyName3Controller.text.toString(),
                                              "familyMobileNo":_familyMobile3Controller.text.toString(),
                                            }
                                          ].toString()
                                        };
                                        addOwnerRequestViewModel
                                            .addOwnerRequestApi(data, context);

                                        // // Handle form submission
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //   SnackBar(
                                        //       content: Text(
                                        //           'Processing Registration')),
                                        // );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepOrangeAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
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
                },
              ),
            );
          }
        },
      ),
    );
  }
}
