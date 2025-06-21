import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageHelper {
  static bool isSvgUrl(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  static Widget buildNetworkImage({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    Widget? placeholder,
  }) {
    if (imageUrl.isEmpty) {
      return errorWidget ?? const Icon(Icons.group,color: Colors.blue,);
    }

    if (isSvgUrl(imageUrl)) {
      return SvgPicture.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (context) => placeholder ?? const SizedBox(),
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? const SizedBox();
        },
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorWidget: (context, error, stackTrace) {
          return errorWidget ?? const SizedBox();
        },
        placeholder: (context, url) {
          return placeholder ?? const SizedBox();
        },
      );
    }
  }
} 