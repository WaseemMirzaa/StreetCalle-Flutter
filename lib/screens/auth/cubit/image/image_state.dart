part of 'image_cubit.dart';

class ImageState {
  final XFile selectedImage;
  final bool? isUpdated;
  final String? url;

  ImageState({required this.selectedImage, this.isUpdated, this.url});

  ImageState copyWith({XFile? selectedImage, bool? isUpdated, String? url}) {
    return ImageState(
        selectedImage: selectedImage ?? this.selectedImage,
        isUpdated: isUpdated ?? this.isUpdated,
        url: url ?? this.url
    );
  }
}