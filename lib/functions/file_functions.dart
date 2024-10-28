import 'dart:io';

// Mégaoctets
const int maxImageSize = 20;
const int maxVideoSize = 300;
const int divider = 1048576;

Future<bool> verifyImageSize(File file) async {
  int length = await file.length();

  // si la taille du fichier est supérieur à maxImageSize
  if (length / divider > maxImageSize) {
    return false;
  }
  return true;
}

Future<Map<String, dynamic>> verifyVideoSize(File file) async {
  int length = await file.length();
  bool result = true;

  // si la taille de la vidéo est supérieur à maxVideoSize
  if (length / divider > maxVideoSize) {
    result = false;
  }
  return {'result': result, 'length': (length/divider).toStringAsFixed(2)};
}