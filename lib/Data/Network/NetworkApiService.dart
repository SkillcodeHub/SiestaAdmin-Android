import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:siestaamsapp/Data/Response/app_excaptions.dart';

import 'BaseApiServices.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetApiResponse(String url, String token,String languageType) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': '$token',
        'app_default_lang': languageType,
        'Content-Type': 'application/json',
      }).timeout(Duration(seconds: 200));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getGetWithoutTokenApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 100));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPostFormDataApiResponse(
      String url, String token, dio.FormData data) async {
    dynamic responseJson;
    try {
      // Convert FormData to bytes
      List<int> formDataBytes = await data.readAsBytes();

      // Send multipart/form-data request
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Authorization': '$token',
              'Content-Type': 'multipart/form-data; boundary=${data.boundary}',
            },
            body: formDataBytes,
          )
          .timeout(Duration(seconds: 200));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future getPostApiResponse(String url, String token, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await post(Uri.parse(url),
              headers:
                  //  {
                  //   'Authorization': '$token',
                  // },
                  {
                'Authorization': '$token',
                'Content-type': 'application/json',
                'Accept': 'application/json'
              },
              body: json.encode(data))
          .timeout(Duration(seconds: 200));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future getPostWithoutTokenApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await post(Uri.parse(url), body: data)
          .timeout(Duration(seconds: 200));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPatchApiResponse(String url, String token, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await patch(Uri.parse(url),
              headers:

                  //  {
                  //   'Authorization': '$token',
                  //   // 'Content-Type': 'application/json',
                  // },
                  {
                'Authorization': '$token',
                'Content-type': 'application/json',
                'Accept': 'application/json'
              },
              body: json.encode(data))
          .timeout(Duration(seconds: 200));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, String token, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await put(Uri.parse(url),
              headers: {
                'Authorization': '$token',
                // 'Content-Type': 'application/json',
              },
              body: data)
          .timeout(Duration(seconds: 200));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responsejson = jsonDecode(response.body);
        return responsejson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw BadRequestException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());

      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occurred while communicating with server ' +
                'with status code ' +
                response.statusCode.toString());
    }
  }
}
