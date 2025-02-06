import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognizerService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<String> recognizeText(InputImage inputImage) async {
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  void dispose() {
    _textRecognizer.close();
  }
}