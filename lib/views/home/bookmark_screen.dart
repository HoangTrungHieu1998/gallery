import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery/models/Urls.dart';
import 'package:gallery/models/cache_image_model.dart';
import 'package:gallery/models/photo.dart';
import 'package:gallery/services/cache_service.dart';
import 'package:gallery/views/home/detail_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  late List<CacheImageModel> images;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshCache();
  }

  Future refreshCache() async {
    setState(() => isLoading = true);

    images = await CacheService.instance.readAllCacheImages();
    print("----------${images.length}---------");

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? LoadingAnimationWidget.flickr(
                rightDotColor: Colors.black,
                leftDotColor: const Color(0xfffd0079),
                size: 25,
              )
            : images.isEmpty
                ? const Center(child: Text("No Images"))
                : _buildCacheImages(),
      ),
    );
  }

  Widget _buildCacheImages() => Padding(
        padding: const EdgeInsets.all(2),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2
          ),
          itemCount: images.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => DetailScreen(
                              imageUrl: images[index].imageUrl!,
                              imageID: images[index].idImage!,
                            )))
                    .then((value) => refreshCache());
              },
              child: Hero(
                tag: images[index].id!,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: CachedNetworkImage(
                    imageUrl: images[index].imageUrl!,
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
      );
}
