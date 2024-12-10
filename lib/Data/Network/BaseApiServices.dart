import 'package:dio/dio.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url, String token,String languageType);
  Future<dynamic> getGetWithoutTokenApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, String token, dynamic data);
  Future<dynamic> getPostFormDataApiResponse(
      String url, String token, FormData data);
  Future<dynamic> getPostWithoutTokenApiResponse(String url, dynamic data);
  Future<dynamic> getPatchApiResponse(String url, String token, dynamic data);
  Future<dynamic> getPutApiResponse(String url, String token, dynamic data);
}
