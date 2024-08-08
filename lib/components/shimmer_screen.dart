import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yccetpc/components/app_properties.dart';

class ShimmerLoading extends StatelessWidget {
  final int itemCount;
  final double height;
  final double width;
  final double borderRadius; // Add borderRadius property

  ShimmerLoading({
    required this.itemCount,
    required this.height,
    required this.width,
    this.borderRadius = 8.0, // Set a default value for borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
          child: Shimmer.fromColors(
            baseColor: CardColor,
            highlightColor: Color.fromARGB(255, 190, 190, 190),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                height: height,
                width: width,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
