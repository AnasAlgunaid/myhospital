import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({
    super.key,
    this.borderRadius = 12.0,
  });

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    double width = 320;
    double height = width / 2; // 2:1 ratio

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, // Base color for shimmer
      highlightColor: Colors.grey.shade100, // Highlight color for shimmer
      child: Container(
        width: width, // Same width as ImageBanner
        height: height, // Same height as ImageBanner
        decoration: BoxDecoration(
          color: Colors.grey, // Placeholder color
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
