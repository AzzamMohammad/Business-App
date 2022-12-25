import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:flutter/material.dart';
Future<File?> PickImage() async {
  // File? ImageFile;
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if(image == null) return null;
  return File(image.path);
}

Future<File?> PickVideo() async {
  // File? ImageFile;
  final ImagePicker _picker = ImagePicker();
  final XFile? Video = await _picker.pickVideo(source: ImageSource.gallery);
  if(Video == null) return null;
  return File(Video.path);
}

//
// Future<File?> CropImage(File image)async{
//   CroppedFile? CroppedImage = await ImageCropper().cropImage(
//       sourcePath: image.path,
//       compressQuality: 70,
//       compressFormat: ImageCompressFormat.jpg,
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: 'ITE Damas',
//             toolbarColor: Color1,
//             toolbarWidgetColor: Colors.white,
//             lockAspectRatio: false,
//             hideBottomControls: false,
//             cropFrameColor: Color1,
//             cropGridColor: Color1,
//             activeControlsWidgetColor:Color1,
//             cropFrameStrokeWidth :3
//         )
//       ]
//   );
//   if(CroppedImage == null) return null;
//   return File(CroppedImage.path);
// }
