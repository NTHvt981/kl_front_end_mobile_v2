import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class LanguageDetectionService {
  //------------------SINGLETON---------------------------//
  static final LanguageDetectionService _languageService = LanguageDetectionService._internal();

  factory LanguageDetectionService() {
    return _languageService;
  }

  // singleton boilerplate
  LanguageDetectionService._internal() {
  }
  //------------------PRIVATE ATTRIBUTES------------------//
  final _identifier = GoogleMlKit.nlp.languageIdentifier(confidenceThreshold: 0.5);

  //------------------PUBLIC METHODS----------------------//
  Future<String> Detect(String text) async
  {
    try {
      final String response = await _identifier.identifyLanguage(text);
      return response;
    } on PlatformException catch (pe) {
      if (pe.code == _identifier.errorCodeNoLanguageIdentified) {
        throw("language not supported!");
      }
    }
    return "ERROR";
  }

  void Release() {
    _languageService.Release();
  }
}