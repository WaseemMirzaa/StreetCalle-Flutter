import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageState(selectedImage: XFile('')));

  void selectImage() async {
    final XFile image = await _pickImage();

    if (state.url != null) {
      if (image.path.isNotEmpty) {
        emit(ImageState(selectedImage: image, isUpdated: true, url: null));
        //TODO: If user change the image then previous need to be deleted. Find some Solution
        //await storage.refFromURL(state.url!).delete();
      }
    } else {
      if (image.path.isNotEmpty) {
        emit(ImageState(selectedImage: image));
      }
    }
  }

  void resetImage() {
    emit(state.copyWith(selectedImage: XFile('')));
  }

  void resetForUpdateImage(String url) {
    emit(state.copyWith(selectedImage: XFile(''), url: url));
  }

  Future<XFile> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return state.selectedImage;
    }
    return XFile(pickedFile.path);
  }
}
