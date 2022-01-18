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
  Future<String> Translate({
    required String text,
    required String sourceLang,
    required String targetLang
  }) async
  {
    final _translator = GoogleMlKit.nlp.onDeviceTranslator(
        sourceLanguage: sourceLang,
        targetLanguage: targetLang
    );

    await translateLanguageModelManager.isModelDownloaded(sourceLang).then((isSupport) async {
      if (!isSupport)
        {
          await translateLanguageModelManager.downloadModel(sourceLang, isWifiRequired: true);
        }
    });

    if (targetLang != TranslateLanguage.ENGLISH) {
      await translateLanguageModelManager.isModelDownloaded(targetLang).then((isSupport) async {
        if (!isSupport)
        {
          await translateLanguageModelManager.downloadModel(targetLang, isWifiRequired: true);
        }
      });
    }

    return _translator.translateText(text);
  }
}