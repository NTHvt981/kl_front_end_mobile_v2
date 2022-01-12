import 'package:google_ml_kit/google_ml_kit.dart';

class TranslationService {
  // singleton boilerplate
  static final TranslationService _translationService = TranslationService._internal();

  factory TranslationService() {
    return _translationService;
  }

  // singleton boilerplate
  TranslationService._internal() { }


  final translateLanguageModelManager = GoogleMlKit.nlp.translateLanguageModelManager();

  //------------------PUBLIC METHODS----------------------//
  Future<String> Translate(String text, String sourceLang) async
  {
    final _translator = GoogleMlKit.nlp.onDeviceTranslator(
        sourceLanguage: sourceLang,
        targetLanguage: TranslateLanguage.ENGLISH
    );

    await translateLanguageModelManager.isModelDownloaded(sourceLang).then((isSupport) async {
      if (!isSupport)
        {
          await translateLanguageModelManager.downloadModel(sourceLang, isWifiRequired: true);
        }
    });

    return _translator.translateText(text);
  }
}