class ImageBannerModel {
  final String id;
  final String imageUrl;
  final String hyperlink;

  ImageBannerModel({
    required this.id,
    required this.imageUrl,
    this.hyperlink = '',
  });

  factory ImageBannerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ImageBannerModel(
      id: id,
      imageUrl: data['imageUrl'] ?? '', // Default to empty string if null
      hyperlink: data['hyperlink'] ?? '', // Default to empty string if null
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'hyperlink': hyperlink,
    };
  }
}
