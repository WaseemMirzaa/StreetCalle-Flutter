import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageState(selectedImage: XFile('')));

  void selectImage() async {
    final XFile image = await _pickImage();
    emit(ImageState(selectedImage: image));
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
