import 'package:app_flutter_project/widgets/custom_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectBlockDash extends StatelessWidget {
  final int height;
  final int? width;
  ShimmerEffectBlockDash(this.height, {this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0x263465FF),
      highlightColor: const Color(0x3B3465FF),
      child: Container(
        height: height.toDouble(),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: CustomStyle().bottomBarShadow1,
        ),
        width: (width == null || width == 0)
            ? MediaQuery.of(context).size.width - 40
            : width!.toDouble(),
      ),
    );
  }
}