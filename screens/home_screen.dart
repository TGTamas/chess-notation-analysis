import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_cropper_service.dart';
import '../services/text_recognizer_service.dart';
import 'text_display_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isProcessing = false;
  final ImageCropperService _imageCropperService = ImageCropperService();
  final TextRecognizerService _textRecognizerService = TextRecognizerService();
  final List<String> _recognizedWords = []; // List to store recognized words

  Future<void> recognizeText(InputImage inputImage) async {
    setState(() {
      _isProcessing = true;
      _recognizedWords.clear();
    });

    final recognizedText = await _textRecognizerService.recognizeText(inputImage);

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _recognizedWords.addAll(recognizedText.split(RegExp(r'\s+|endl')).where((word) => word.isNotEmpty).toList());
      });

      // Navigate to the new screen with the recognized text
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextDisplayScreen(recognizedText: recognizedText, recognizedWords: _recognizedWords),
        ),
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final croppedFile = await _imageCropperService.cropImage(pickedFile.path);
      if (croppedFile != null) {
        final inputImage = InputImage.fromFilePath(croppedFile.path);
        await recognizeText(inputImage);
      }
    }
  }

  @override
  void dispose() {
    _textRecognizerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isProcessing ? null : () => pickImage(ImageSource.camera),
              child: const Text('Capture Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : () => pickImage(ImageSource.gallery),
              child: const Text('Select from Gallery'),
            ),
            const SizedBox(height: 20),
            _isProcessing
                ? const CircularProgressIndicator()
                : Container(),
          ],
        ),
      ),
    );
  }
}