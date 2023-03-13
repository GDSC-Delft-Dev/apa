// Gets crop growth images from firebase storage
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CropGrowthStagesStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;


  // Gets all images for the given crop sorted by growth stage and caches them
  Future<List<CachedNetworkImage>> getImagesCached(String cropId) async {
    // We store the images at the following path: crop_growth_stages/<cropId>/<growthStage>.png
    final String path = 'crop_growth_stages/$cropId';
    final Reference ref = _storage.ref(path);
    final ListResult result = await ref.listAll();
    final List<Reference> images = result.items;

    // Pretty ugly way to sort the images by growth stage
    images.sort((a, b) => int.parse(a.name.split('/').last.split(".").first)
        .compareTo(int.parse(b.name.split('/').last.split(".").first)));
    final List<CachedNetworkImage> imageWidgets = [];
    for (final Reference image in images) {

      // This package is really nice and allows caching of the fetched images
      imageWidgets.add(CachedNetworkImage(
        imageUrl: await image.getDownloadURL(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ));
    }

    return imageWidgets;
  }

  /// Gets the image for the given crop and growth stage
  Future<Image> getImage(String cropId, String growthStage) async {
    final String path = 'crop_growth_stages/$cropId/$growthStage.png';
    final Reference ref = _storage.ref(path);
    final Uint8List? bytes = await ref.getData();
    return Image.memory(bytes!);
  }
}
