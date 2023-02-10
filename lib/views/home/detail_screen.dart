import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery/models/cache_image_model.dart';
import 'package:gallery/models/photo.dart';
import 'package:gallery/services/cache_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DetailScreen extends StatefulWidget {
  final String imageUrl;
  final String imageID;
  const DetailScreen({Key? key,required this.imageUrl,required this.imageID}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  bool isBookmark = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBookmark();
    controller = TransformationController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context,true);
          },
        ),
        actions: [
          IconButton(
              onPressed: addOrRemoveBookmark,
              icon: isBookmark
                  ? const Icon(Icons.bookmark,size: 30)
                  : const Icon(Icons.bookmark_border,size: 30))
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Hero(
            tag: widget.imageID,
            child: GestureDetector(
              onDoubleTapDown: (details) => tapDownDetails = details,
              onDoubleTap: (){
                final position = tapDownDetails!.localPosition;
                const double scale = 3;
                final x = -position.dx * (scale-1);
                final y = -position.dy * (scale-1);
                final zoom = Matrix4.identity()
                  ..translate(x,y)
                  ..scale(scale);
                final value = controller.value.isIdentity() ? zoom : Matrix4.identity();
                controller.value = value;
              },
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                panEnabled: false,
                scaleEnabled: false,
                transformationController: controller,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  imageBuilder: (context, imageProvider) => SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  placeholder: (context, url) => Center(
                    child: LoadingAnimationWidget.flickr(
                      rightDotColor: Colors.black,
                      leftDotColor: const Color(0xff0bb3c2),
                      size: 35,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future addOrRemoveBookmark() async {
    if(!isBookmark){
      final image = CacheImageModel(
        idImage: widget.imageID,
        imageUrl: widget.imageUrl,
      );
      // add bookmark
      await CacheService.instance.create(image).then((value) => setState(() => isBookmark = true));
    }else{
      // remove bookmark
      await CacheService.instance.delete(widget.imageID).then((value) => setState(() => isBookmark = false));
    }
  }

  Future checkBookmark() async{
    final images = await CacheService.instance.readAllCacheImages();
    var result = images.where((element) => element.idImage == widget.imageID);
    if(result.isEmpty){
      setState(() => isBookmark = false);
    }else{
      setState(() => isBookmark = true);
    }
  }
}
