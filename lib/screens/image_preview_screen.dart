import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/constants/assets_source.dart';

/// Screen [ImagePreviewScreen] : ImagePreviewScreen lets you zoom in/out on an image
class ImagePreviewScreen extends StatelessWidget {
  static const String routeName = '/image_preview_screen';

  const ImagePreviewScreen({
    Key? key,
  }) : super(key: key);

  DecorationImage _getImage(
      File? imageFile, String? imageUrl, String? imageAsset) {
    return imageFile != null
        ? DecorationImage(
            image: FileImage(
            imageFile,
          ))
        : imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl))
            : DecorationImage(image: AssetImage(imageAsset!));
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final imageFile = data['imageFile'];
    final imageUrl = data['imageUrl'];
    final imageAsset = data['imageAsset'];
    final imageTitle = data['imageTitle'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(imageTitle ?? 'Preview File'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black54,
      body: Center(
          child: imageFile == null && imageUrl == null && imageAsset == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetsSource.appLogo, height: 250),
                    const SizedBox(height: 32),
                    const Text('Sorry, could not load preview for the file.'),
                  ],
                )
              : InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.1,
                  maxScale: 15,
                  child: Container(
                    decoration: BoxDecoration(
                        image: _getImage(imageFile, imageUrl, imageAsset)),
                  ),
                )),
    );
  }
}
