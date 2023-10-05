part of 'image_cubit.dart';

class ImageState extends Equatable {
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

  @override
  List<Object?> get props => [selectedImage, isUpdated, url];
}