import 'package:ceo_events/configs/environment_config.dart';
import 'package:ceo_events/configs/events_exception.dart';
import 'package:ceo_events/models/photogallery.dart';
import 'package:ceo_events/models/response_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceo_events/models/event.dart';
import 'package:ceo_events/models/visitor.dart';
import 'package:ceo_events/models/company.dart';
import 'package:dio/dio.dart';

final eventServiceProvider = Provider<AppService>((ref) {
  final config = ref.read(environmentConfigProvider);

  return AppService(config, Dio());
});

class AppService {
  AppService(this._environmentConfig, this._dio);

  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  Future<List<Event>> getEvents() async {
    try {
      final response = await _dio
          .post("https://profile.iteca.az/events_list.json", data: {
        "apiKey": "4b4277bd1523915d0655ecc44992f2db",
        "lang": "en",
        "projectID": 0
      });

      final results =
          List<Map<String, dynamic>>.from(response.data['confList']);

      List<Event> events = results
          .map((eventData) => Event.fromMap(eventData))
          .toList(growable: false);
      return events;
    } on DioError catch (dioError) {
      throw EventsException.fromDioError(dioError);
    }
  }


  Future<List<Visitor>> getVisitors(eventID, eventName) async {
    try {
      final response = await _dio
          .post("https://profile.iteca.az/visitors_list.json", data: {
        "apiKey": "4b4277bd1523915d0655ecc44992f2db",
        "lang": "en",
        "project": "$eventName",
        "projectID": eventID,
        "barcode": "0",
        "page": 1,
        "limit": 1000
      });

      final results =
          List<Map<String, dynamic>>.from(response.data['visitors']);

      List<Visitor> visitors = results
          .map((visitorData) => Visitor.fromMap(visitorData))
          .toList(growable: false);
      return visitors;
    } on DioError catch (dioError) {
      throw EventsException.fromDioError(dioError);
    }
  }


  Future<List<Company>> getCompanies(eventID) async {
    try {
      final response = await _dio
          .post("https://profile.iteca.az/companies_list.json", data: {
        "apiKey": "4b4277bd1523915d0655ecc44992f2db",
        "lang": "en",
        "projectID": "$eventID",
        "project": "bakutel",
        "page": 1,
        "limit": 1000
      });

      final results =
          List<Map<String, dynamic>>.from(response.data['companies']);

      List<Company> companies = results
          .map((companyData) => Company.fromMap(companyData))
          .toList(growable: false);
      return companies;
    } on DioError catch (dioError) {
      throw EventsException.fromDioError(dioError);
    }
  }



  Future<List<ResponseStatus>> sendPromo(eventID, eventName, qrCode) async {
    try {
      final response = await _dio
          .post("https://profile.iteca.az/sendpromo.json", data: {
        "apiKey": "4b4277bd1523915d0655ecc44992f2db",
        "projectID": 188,
        "project": "bakutel",
        "QRCode": "https://bakutel.az/company-VXg=.html",
        "ExhibitorID": 28,
        "ToID": 25748,
        "ToEmail": "zaur@ceo.az",
        "ToFullName": "Eldar Mustafayev"
      });

      final results =
          List<Map<String, dynamic>>.from(response.data['responseStatus']);

      List<ResponseStatus> sendpromo = results
          .map((sendPromoData) => ResponseStatus.fromMap(sendPromoData))
          .toList(growable: false);
      return sendpromo;
    } on DioError catch (dioError) {
      throw EventsException.fromDioError(dioError);
    }
  }




  Future<List<Photogallery>> getPhotoGallery(eventID) async {
    try {
      final response = await _dio
          .post("https://profile.iteca.az/photo_gallery.json", data: {
        "apiKey": "4b4277bd1523915d0655ecc44992f2db",
        "lang": "en",
        "projectID": "$eventID"
      });

      final results =
          List<Map<String, dynamic>>.from(response.data['albums']);

      List<Photogallery> albums = results
          .map((albumData) => Photogallery.fromMap(albumData))
          .toList(growable: false);
      return albums;
    } on DioError catch (dioError) {
      throw EventsException.fromDioError(dioError);
    }
  }



}
