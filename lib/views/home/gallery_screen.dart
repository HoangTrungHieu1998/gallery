import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:gallery/models/photo.dart';
import 'package:gallery/views/home/detail_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  final _refreshController = RefreshController(initialRefresh: false);

  List<Photos>? listPhotos;

  List<Photos>? getPhotoFromState(GalleryState state){
    List<Photos>? _list =[];
    if(state is GallerySuccess){
      _list = state.photos;
    }
    if(state is GalleryLoadMore){
      _list = state.currentPhotos;
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<GalleryBloc, GalleryState>(
            builder: (context, state) {
          if (state is GalleryEmpty) {
            return const Text("Reload");
          }
          if (state is GalleryLoading) {
            return Center(
                child: LoadingAnimationWidget.flickr(
              rightDotColor: Colors.black,
              leftDotColor: const Color(0xfffd0079),
              size: 30,
            ));
          }
          if (state is GallerySuccess || state is GalleryLoadMore) {
            listPhotos = getPhotoFromState(state);
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: const WaterDropMaterialHeader(
                backgroundColor: Colors.green,
              ),
              onLoading: (){
                print("Current Photos:${listPhotos!.length}");
                context.read<GalleryBloc>().add(LoadMoreImageFromApi(currentPhotos: listPhotos??[]));
              },
              onRefresh: (){
                context.read<GalleryBloc>().add(const GetImageFromApi(1));
              },
              controller: _refreshController,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2
                  ),
                  itemCount: listPhotos!.length,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            DetailScreen(imageUrl: listPhotos![index].urls!.regular!,imageID: listPhotos![index].id!,))
                        );
                      },
                      child: Hero(
                        tag: listPhotos![index].urls!,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          child: CachedNetworkImage(
                            imageUrl: listPhotos![index].urls!.small!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Center(
                              child: LoadingAnimationWidget.flickr(
                                rightDotColor: Colors.black,
                                leftDotColor: const Color(0xff0bb3c2),
                                size: 25,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image_not_supported_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          } else {
            return const Text("Error");
          }
        },
          listener: (context, state) {
            if (state is GalleryLoadMore) {
              //
            } else {
              _refreshController.loadComplete();
            }
          },
        ),
      ),
    );
  }
}


