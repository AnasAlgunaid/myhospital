import 'package:flutter/material.dart';
import 'package:myhospital/common/widgets/image_banner.dart';
import 'package:myhospital/features/banners/models/image_banner_model.dart';
import 'package:myhospital/features/banners/widgets/shimmer_banner.dart';

class ScrollableBanners extends StatelessWidget {
  const ScrollableBanners({
    super.key,
    required this.banners,
    this.isLoading = false,
  });

  final List<ImageBannerModel> banners; // List of image URLs
  final bool isLoading; // Flag to indicate loading state

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // Height of each banner
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        padding: const EdgeInsets.only(left: 8.0),
        itemCount:
            isLoading ? 3 : banners.length, // Show 3 shimmer banners if loading
        itemBuilder: (context, index) {
          if (isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0), // Add spacing
              child: ShimmerBanner(), // Shimmer loading banner
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add spacing
            child: ImageBanner(
              imageUrl: banners[index].imageUrl,
              hyperlink: banners[index].hyperlink,
            ),
          );
        },
      ),
    );
  }
}
