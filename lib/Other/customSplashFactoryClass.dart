// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomSplashFactory extends InteractiveInkFeatureFactory {
  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    bool containedInkWell = false,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
    RectCallback? rectCallback,
    TextDirection? textDirection,
  }) {
    return InkSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      radius: radius ?? 1500,
      onRemoved: onRemoved,
      textDirection: TextDirection.ltr,
      borderRadius: borderRadius,
    );
  }
}
