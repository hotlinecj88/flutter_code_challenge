import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;

double calculateScaleRatio(int width, int height, {int maxSize = 800}) {
  final int maxDimension = width > height ? width : height;
  if (maxDimension <= maxSize) {
    return 1.0;  // No resize needed
  } 
  // if too big, e.g. > maxSize — reduce to 1/5 or ~20%
  if (maxDimension > maxSize * 5) {
    return 0.2;
  }
  // if just moderately bigger — scale to fit maxSize
  return maxSize / maxDimension;
}

Future<void> function_imagePicker({ 
  required ValueNotifier<String?> imagePickerListenable,
  ImageSource imageSource = ImageSource.gallery,
  String? customFileName,
}) async {
  final uuid = Uuid();
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: imageSource);
  
  if (pickedFile != null) {
    final File originalFile = File(pickedFile.path);
    final Uint8List imageBytes = await originalFile.readAsBytes();

    final img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) return;

    final double scaleRatio = calculateScaleRatio(decodedImage.width, decodedImage.height);
    final int newWidth = (decodedImage.width * scaleRatio).round();
    final int newHeight = (decodedImage.height * scaleRatio).round();

    final img.Image resized = img.copyResize(decodedImage, width: newWidth, height: newHeight);
    final List<int> resizedBytes = img.encodeJpg(resized, quality: 70);

    final dir = await getTemporaryDirectory();

    final fileName = customFileName != null
      ? '${customFileName}.jpg'
      : '${uuid.v6().toString()}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final resizedPath = path.join(dir.path, fileName);
    final resizedFile = await File(resizedPath).writeAsBytes(resizedBytes);

    imagePickerListenable.value = resizedFile.path;

    final int originalSize = imageBytes.lengthInBytes;
    final int resizedSize = resizedBytes.length;

    print('Original image size: ${(originalSize / 1024).toStringAsFixed(2)} KB');
    print('Resized image size: ${(resizedSize / 1024).toStringAsFixed(2)} KB');

    final double ratio = (resizedSize / originalSize) * 100;
    print('Reduced to ${ratio.toStringAsFixed(2)}% of original size.');
  }
}