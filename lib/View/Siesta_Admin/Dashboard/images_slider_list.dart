import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class ImagesSliderListView extends StatefulWidget {
  final ImagesSliderList imagesSliderList;

  const ImagesSliderListView({super.key, required this.imagesSliderList});

  @override
  State<ImagesSliderListView> createState() => _ImagesSliderListViewState();
}

class _ImagesSliderListViewState extends State<ImagesSliderListView> {
  num _sliderImagesLength = 0;

  @override
  Widget build(BuildContext context) {
    String subtitle;
    if (widget.imagesSliderList.imagesList == null) {
      subtitle = '0 ${AppString.get(context).images()}';
    } else {
      subtitle =
          '${widget.imagesSliderList.imagesList.length} ${AppString.get(context).images()}';
    }
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.imagesSliderList.title,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
            ),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Colors.white, fontFamily: 'Raleway'),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: LayoutBuilder(builder: (context, constraint) {
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _sliderImagesLength.toInt(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  /*Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          _ImageSinglePhotoView(
                              widget.imagesSliderList.imagesList[index]),
                    ),
                  );*/

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _ImageGalleryView(
                          widget.imagesSliderList.imagesList, index),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: CachedNetworkImage(
                    imageUrl: widget.imagesSliderList.imagesList[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                        padding: EdgeInsets.all(16),
                        height: 100,
                        width: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            SvgPicture.asset(
                              'asset/images/image_placeholder.svg',
                              height: 100,
                              width: 100,
                              colorBlendMode: BlendMode.srcATop,
                              color: Colors.grey,
                              semanticsLabel: 'Placeholder',
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: LinearProgressIndicator(),
                            )
                          ],
                        ),
                      );
                    },
                    errorWidget: (context, url, obj) {
                      return Container(
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          'asset/images/error.svg',
                          height: 100,
                          width: 100,
                          colorBlendMode: BlendMode.srcATop,
                          color: Colors.grey,
                          semanticsLabel: 'Placeholder',
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _sliderImagesLength = widget.imagesSliderList.imagesList.length;
  }
}

class _ImageGalleryView extends StatefulWidget {
  final List<String> urls;
  final num index;

  _ImageGalleryView(this.urls, this.index, {Key? key}) : super(key: key);

  @override
  __ImageGalleryViewState createState() => __ImageGalleryViewState();
}

class __ImageGalleryViewState extends State<_ImageGalleryView> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index.toInt());
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.red,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Color(0x44000000),
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.urls.length,
        scrollPhysics: BouncingScrollPhysics(),
        pageController: _pageController,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(widget.urls[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.urls[index]),
          );
        },
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded /
                      event.expectedTotalBytes!.toInt(),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagesSliderList {
  String title;
  List<String> imagesList;

  ImagesSliderList({required this.title, required this.imagesList}) : super();
}
