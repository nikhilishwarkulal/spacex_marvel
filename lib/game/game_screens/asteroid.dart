import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' as material;
import 'package:spacex_marvel/game/game_screens/game_screen.dart';
import 'package:spacex_marvel/game_bloc/plane_life_bloc.dart';

import 'air_craft.dart';
import 'blast.dart';
import 'bullet.dart';

class Asteroid extends SpriteComponent
    with HasGameRef<GameScreen>, HasHitboxes, Collidable {
  final Vector2 planePosition;
  late Vector2 startingPosition;
  late HitboxCircle hitbox;
  int collisionCount = 0;
  late Timer destroyer;
  double rotateValue = 0;

  Asteroid({required this.planePosition});
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(60, 60);
    sprite = gameRef.astrolidSprite;
    startingPosition =
        Vector2(Random().nextInt(gameRef.size.x.round()).toDouble(), 0);
    position = startingPosition;
    rotateValue = getRandomNumber(-2.0, 2.0);
    hitbox = HitboxCircle(normalizedRadius: 1);
    addHitbox(hitbox);
    anchor = Anchor.center;

    destroyer = Timer(
      25,
      onTick: () {
        gameRef.remove(this);
      },
      repeat: false,
    );
    destroyer.start();
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
    final dir = (planePosition - startingPosition).normalized();
    position += dir * (150 * dt);
    angle += (dt * rotateValue);
    destroyer.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Bullet) {
      collisionCount++;
      if (collisionCount >= 3) {
        try {
          gameRef.add(Blast(Vector2(position.x, position.y)));
          gameRef.remove(this);
        } catch (_) {}
      }
    }
    if (other is AirCraft) {
      try {
        gameRef.add(Blast(Vector2(position.x, position.y)));
        gameRef.remove(this);
        PlaneLifeBloc.shared.incrementValue();
      } catch (_) {}
    }
  }
}

double getRandomNumber(double minimum, double maximum) {
  Random random = Random();
  return random.nextDouble() * (maximum - minimum) + minimum;
}
