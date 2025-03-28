import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:vax_care_user/app_constants/app_urls.dart';
import 'package:vax_care_user/app_modules/home_page_module/model/healthcare_provider.dart';

Future<List<HealthcareProvider>> getHealthcareProviderList({
  required double latitude,
  required double longitude,
  required int childId,
}) async {
  try {
    Map<String, dynamic> params = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "child_id": childId.toString(),
    };
    // Construct the URL with query parameters
    final url = Uri.parse(AppUrls.getHealthcareProviderListUrl).replace(
      queryParameters: params,
    );

    final resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(resp.body);
      final response =
          decoded.map((item) => HealthcareProvider.fromJson(item)).toList();
      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(resp.body);
      throw Exception(
        '${errorResponse['message'] ?? 'Unknown error'}',
      );
    }
  } on SocketException {
    throw Exception('Server error');
  } on HttpException {
    throw Exception('Something went wrong');
  } on FormatException {
    throw Exception('Bad request');
  } catch (e) {
    throw Exception(e.toString());
  }
}
