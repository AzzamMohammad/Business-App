import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_text/skeleton_text.dart';

class LoadingListItem extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color? widgetColor;


  const LoadingListItem._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.radius = double.infinity,
    this.widgetColor = const Color(0xff076579),
    Key? key}) : super(key: key);

  const LoadingListItem.Square({
    required double width,
    required double height,
    required double radius,
    required Color color,
    }) : this._(width: width , height: height , radius: radius , widgetColor: color);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      // shimmerDuration: 1000,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      curve: Curves.easeInOutCubic,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: widgetColor
        ),
      ),
    );
  }
}
