import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// We need to load the image from the network and then convert it to a Uint8List.
Future<Uint8List?> loadNetworkImage(String path) async {
  final completer = Completer<ImageInfo>();
  var img = NetworkImage(path);
  img
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((info, _) => completer.complete(info)));
  final imageInfo = await completer.future;
  final byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
  return byteData?.buffer.asUint8List();
}
