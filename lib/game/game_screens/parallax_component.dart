import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';
import 'package:spacex_marvel/flame_extensions/parallax_extension.dart';

import 'game_screen.dart';

class SpaceXParallaxComponent {
  Future<ParallaxComponent> get(
      {required SpaceXParallaxComponentType spaceXParallaxComponentType,
      required GameScreen gameRef}) async {
    return await gameRef.loadParallaxComponent(
      [
        SpaceXParallaxImageData(
          spaceXParallaxComponentType.getFileName(),
          alignment: Alignment.center,
          fill: LayerFill.width,
        ),
      ],
      baseVelocity: Vector2(0, -20),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
      repeat: ImageRepeat.repeatY,
    );
  }
}

enum SpaceXParallaxComponentType { purpleNebulaSix }

extension SpaceXParallaxComponentTypeExtension on SpaceXParallaxComponentType {
  String getFileName() {
    switch (this) {
      case SpaceXParallaxComponentType.purpleNebulaSix:
        return "par_one.png";
    }
  }
}
