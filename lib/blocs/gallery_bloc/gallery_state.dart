part of 'gallery_bloc.dart';

abstract class GalleryState extends Equatable{
  final List? states;

  const GalleryState([this.states]);

  @override
  List<Object?> get props => (states ?? []);
}

class GalleryEmpty extends GalleryState{}
class GalleryLoading extends GalleryState{}
class GallerySuccess extends GalleryState{
  final List<Photos>? photos;
  const GallerySuccess({this.photos});
}
class GalleryError extends GalleryState{
  final String error;

  const GalleryError({required this.error});
}

class GalleryLoadMore extends GalleryState{
  final List<Photos>? currentPhotos;
  const GalleryLoadMore({this.currentPhotos});
}