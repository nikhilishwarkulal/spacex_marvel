import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' as material;
import 'package:spacex_marvel/game/game_screens/game_screen.dart';

import 'asteroid.dart';

class Bullet extends SpriteComponent
    with HasGameRef<GameScreen>, HasHitboxes, Collidable {
  final Vector2 launchPosition;
  Bullet({required this.launchPosition});
  late HitboxCircle hitbox;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(25, 25);
    sprite = gameRef.bulletSprite;
    position = launchPosition;
    anchor = Anchor.center;
    hitbox = HitboxCircle(normalizedRadius: 0.8);

    addHitbox(hitbox);
  }

  final material.Paint hitboxPaint = BasicPalette.green.paint()
    ..style = material.PaintingStyle.stroke;

  // @override
  // void render(material.Canvas canvas) {
  //   super.render(canvas);
  //   // This is just to clearly see the vertices in the hitboxes
  //   // hitbox.render(canvas, hitboxPaint);
  // }

  @override
  void update(double dt) {
    super.update(dt);
    final dir = (Vector2(launchPosition.x, 0) - launchPosition).normalized();
    position += dir * (200 * dt);
    if (position.y <= 0) {
      try {
        gameRef.remove(this);
      } catch (_) {}
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Asteroid) {
      try {
        gameRef.remove(this);
      } catch (_) {}
    }
  }
}
