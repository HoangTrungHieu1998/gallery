part of 'gallery_bloc.dart';

@immutable
abstract class GalleryEvent extends Equatable{
  final List? events;

  const GalleryEvent([this.events]);

  @override
  List<Object?> get props => (events ?? []);
}

class GetImageFromApi extends GalleryEvent{
  final int page;

  const GetImageFromApi(this.page);

}

class LoadMoreImageFromApi extends GalleryEvent{
  final List<Photos>? currentPhotos;
  const LoadMoreImageFromApi({this.currentPhotos});
}