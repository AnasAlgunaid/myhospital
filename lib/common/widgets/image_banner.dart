import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myhospital/core/utils/url_launcher_utils.dart';
import 'package:shimmer/shimmer.dart';

class ImageBanner extends StatelessWidget {
  const ImageBanner({
    super.key,
    required this.imageUrl,
    this.borderRadius = 12.0,
    this.hyperlink = '',
  });

  final String imageUrl;
  final String hyperlink;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    double width = 320;
    double height = width / 2; // 2:1 ratio

    return GestureDetector(
      onTap: () async {
        await launchHyperlink(hyperlink);
      },
      child: Container(
        width: width, // Fixed width for each banner
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        clipBehavior:
            Clip.antiAlias, // Ensures the image respects the border radius
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover, // Ensures the image covers the entire container
          width: double.infinity,
          height: height,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: width,
              height: height,
              color: Colors.grey.shade300, // Placeholder shimmer color
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: width,
            height: height,
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
