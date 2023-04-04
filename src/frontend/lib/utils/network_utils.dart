import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// We need to load the image from the network and then convert it to a Uint8List.
Future<Uint8List?> loadNetworkImage(String path) async {
  final completer = Completer<ImageInfo>();
  var img = NetworkImage(path);
  var resolved = img.resolve(const ImageConfiguration());
  var listener = ImageStreamListener((info, _) => completer.complete(info));
  resolved.addListener(listener);

  final imageInfo = await completer.future;
  resolved.removeListener(listener);
  final byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

  return byteData?.buffer.asUint8List();
}
