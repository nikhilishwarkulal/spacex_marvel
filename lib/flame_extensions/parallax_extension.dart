import 'package:flame/assets.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';

/// Contains the fields and logic to load a [ParallaxImage]
class SpaceXParallaxImageData extends ParallaxData {
  final String path;
  final LayerFill? fill;
  final Alignment? alignment;
  SpaceXParallaxImageData(this.path, {this.fill, this.alignment});

  @override
  Future<ParallaxRenderer> load(
    ImageRepeat repeat,
    Alignment alignment,
    LayerFill fill,
    Images? images,
  ) {
    return ParallaxImage.load(
      path,
      repeat: repeat,
      alignment: this.alignment ?? alignment,
      fill: this.fill ?? fill,
      images: images,
    );
  }
}
