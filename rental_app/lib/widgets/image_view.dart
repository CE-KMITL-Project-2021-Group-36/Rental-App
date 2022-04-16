import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    Key? key,
    required this.imageList,
    required this.initialPage,
  }) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();

  final List imageList;
  final int initialPage;
}

class _ImageViewState extends State<ImageView> {

  @override
  Widget build(BuildContext context) {
    List _imageList = widget.imageList;
    int _inittialPage = widget.initialPage;
    PageController _pageController = PageController(initialPage: _inittialPage);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: PhotoViewGallery.builder(
            itemCount: _imageList.length,
            pageController: _pageController,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                  _imageList[index],
                ),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
                //initialScale: PhotoViewComputedScale.contained * 0.8,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
            enableRotation: true,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
