import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:precache_images/datebase.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  bool isloading = false;

  // initState method is called before the page loades
  @override
  void initState() {
    // addPostFrameCallback is called after the widgets has been renderd
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      preloadImages();
    });

    super.initState();
  }

  Future<void> preloadImages() async {
    isloading = true;
    setState(() {});
    await Future.wait(images.map((imageURL) {
      return precacheImage(CachedNetworkImageProvider(imageURL), context);
    }));
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preache image '),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Show progress indicator when the images are loading
    if (isloading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(32),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: images.length, // Increase the list with one item
      itemBuilder: (context, index) {
        return CircleAvatar(
          radius: 50,
          backgroundImage: CachedNetworkImageProvider(images[index]),
        );
      },
    );
  }
}
