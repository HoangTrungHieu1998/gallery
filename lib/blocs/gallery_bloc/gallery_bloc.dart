import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gallery/models/photo.dart';
import 'package:gallery/services/image_service.dart';
import 'package:meta/meta.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final ImageService imageService;

  GalleryBloc({required this.imageService}) : super(GalleryEmpty()) {
    on<GetImageFromApi>(_onGetImageFromApi);
    on<LoadMoreImageFromApi>(_onLoadMoreImageFromApi);
  }

  void _onGetImageFromApi(GetImageFromApi event, Emitter<GalleryState> emit) async {
    try{
      emit(GalleryLoading());
      final result = await imageService.getImageData(event.page);
      if(result!.isEmpty){
        emit(GalleryEmpty());
      }else{
        emit(GallerySuccess(photos: result));
      }
    }catch(_){
      emit(GalleryError(error: _.toString()));
    }
  }

  void _onLoadMoreImageFromApi(LoadMoreImageFromApi event, Emitter<GalleryState> emit) async{
    try{
      emit(GalleryLoadMore(currentPhotos: event.currentPhotos));
      int pageNext = (event.currentPhotos!.length / 6).floor() +1;
      final result = await imageService.getImageData(pageNext);
      final newPhotos = [...event.currentPhotos!, ...result!];
      emit(GallerySuccess(photos: newPhotos));
    }catch(_){
      emit(GalleryError(error: _.toString()));
    }
  }
}

