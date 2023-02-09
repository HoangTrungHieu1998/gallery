const String tableImages = 'images';

class CacheImageFields {
  static final List<String> values = [
    /// Add all fields
    id, imageUrl
  ];

  static const String id = '_id';
  static const String idImage = 'idImage';
  static const String imageUrl = 'imageUrl';
}


class CacheImageModel{
  final int? id;
  final String? idImage;
  final String? imageUrl;

  CacheImageModel({this.id,this.idImage, this.imageUrl});

  CacheImageModel copy({
    int? id,
    String? idImage,
    String? imageUrl,
  }) =>
      CacheImageModel(
        id: id ?? this.id,
        idImage: idImage ?? this.idImage,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  static CacheImageModel fromJson(Map<String, Object?> json) => CacheImageModel(
    id: json[CacheImageFields.id] as int?,
    idImage: json[CacheImageFields.idImage] as String,
    imageUrl: json[CacheImageFields.imageUrl] as String,
  );

  Map<String,Object?> toJson() => {
    CacheImageFields.id: id,
    CacheImageFields.idImage: idImage,
    CacheImageFields.imageUrl: imageUrl
  };
}