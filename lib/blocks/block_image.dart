import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class BlockImage extends StatelessWidget{

  final String? urlImage;
  final String? imageAssetBundle;
  final String? imageLocal;
  final double? width;
  final double? height;
  final double blockSize;
  final double iconSize;
  final double imageRadius;
  final BoxFit fit;
  final Color? backgroundColor;
  final bool circle;
  final Alignment? alignment;
  
  BlockImage({
    super.key,
    this.urlImage,
    this.imageAssetBundle,
    this.imageLocal,
    this.blockSize = 60.0,
    this.iconSize = 20.0,
    this.width,
    this.height,
    this.imageRadius = 8.0,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.circle = false,
    this.alignment
  });
  
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final imageWidget = _buildImage(Colors.white);

    return ClipRRect(
      borderRadius: BorderRadius.circular(circle == true ? 0.0 : imageRadius),
      child: Container(
        width: width != null ? width : blockSize, 
        height: height != null ? height : blockSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.primary,
          shape: circle == true ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: imageWidget ?? _buildPlaceholder(
          theme.colorScheme.primary,
        ),
      )
    );

  }

  Widget? _buildImage(Color colorIcon) {
    final String? source = 
    (urlImage != null && urlImage!.isNotEmpty)
      ? urlImage
      : (imageAssetBundle != null && imageAssetBundle!.isNotEmpty)
        ? imageAssetBundle
        : (imageLocal != null && imageLocal!.isNotEmpty)
          ? imageLocal
          : null;
          
    if (source == null) return null;

    return ExtendedImage(
      image: urlImage != null
        ? ExtendedNetworkImageProvider(urlImage!, cache: true)
        : imageAssetBundle != null
          ? AssetImage(imageAssetBundle!)
          : FileImage(File(imageLocal!)) as ImageProvider,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      shape: circle ? BoxShape.circle : BoxShape.rectangle,
      loadStateChanged: (state) => state.frameNumber != null ? state.completedWidget : _buildPlaceholder(colorIcon),
    );
  }

  Widget _buildPlaceholder(Color colorIcon) => Center(
    child: Icon(
      Icons.sports_esports_outlined, 
      size: iconSize, color: colorIcon)
  );

}