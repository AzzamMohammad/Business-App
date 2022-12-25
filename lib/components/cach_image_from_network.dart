import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

ImageProvider GetAndCacheNetworkImageProvider(String ImageURL) {
  // print(ImageURL);
  return  CachedNetworkImageProvider(
      ImageURL,
    );
}

Widget GetAndCacheNetworkImage(String ImageURL,
    Widget Function(BuildContext, String) LoadingWidget, BoxFit boxFit) {
  return CachedNetworkImage(
    imageUrl: ImageURL,
    placeholder: LoadingWidget,
    errorWidget: (context, url, error) => Icon(Icons.error),
    fit: boxFit,
  );
}

Widget GetAndCacheNetworkImageWithoutLoading(String ImageURL, BoxFit boxFit) {
  return CachedNetworkImage(
    imageUrl: ImageURL,
    errorWidget: (context, url, error) => Icon(Icons.error),
    placeholder: (context,s)=>Text('vvvvvvvvv'),
    fit: boxFit,
  );
}
