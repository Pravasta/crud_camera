import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageController with ChangeNotifier {
  XFile? imageFile;
  String? imagePath;

  void _setImage(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void _setImagePath(String value) {
    imagePath = value;
    notifyListeners();
  }

  onGalleryView() async {
    final pick = ImagePicker();

    final XFile? pickedImage = await pick.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      _setImage(pickedImage);
      _setImagePath(pickedImage.path);
    }
  }

  onCameraView() async {
    final pick = ImagePicker();

    final XFile? pickedImage = await pick.pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage != null) {
      _setImage(pickedImage);
      _setImagePath(pickedImage.path);
    }
  }

  toEmptyImage() async {
    if (imagePath != null) {
      imagePath = null;
    }
    notifyListeners();
  }
}
