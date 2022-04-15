import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flutter/material.dart' as material;
import 'package:spacex_marvel/screens/flutter_game_screen.dart';

import 'asteroid.dart';
import 'bullet.dart';
import 'game_component.dart';

class AirCraft extends SpriteAnimationComponent
    with HasGameRef, HasHitboxes, Collidable, Draggable {
  JoystickComponent joystick;
  int hitcount = 0;
  SpriteAnimation? animationt;
  AirCraft(this.joystick);
  late Timer bulletSpawner;
  late Timer astroSpawner;
  late Timer gameTimer;
  late HitboxPolygon hitbox;
  late AudioPool pool;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = await Flame.images.load('ship_thrust.png');
    pool =
        await AudioPool.create('laser_shot.ogg', minPlayers: 3, maxPlayers: 4);
    animationt = SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.15,
            textureSize: Vector2(140, 180),
            loop: true));
    final spriteSize = Vector2(140 * .7, 180 * .7);
    animation = animationt;
    size = spriteSize;
    anchor = Anchor.center;
    position = Vector2(gameRef.size.x / 2, gameRef.size.y / 2);

    hitbox = HitboxPolygon([
      Vector2(-0.3, -1.0),
      Vector2(-0.6, 0.5),
      Vector2(-0.2, 0.4),
      Vector2(0.2, 0.4),
      Vector2(0.6, 0.5),
      Vector2(0.3, -1.0),
    ]);
    addHitbox(hitbox);
    bulletSpawner = Timer(
      0.3,
      onTick: () {
        //FlameAudio.audioCache.play('laser_shot.ogg');
        pool.start(volume: 0.1);
        gameRef.add(Bullet(
            launchPosition: Vector2(position.x, position.y - (90 * .7))));
      },
      repeat: true,
    );

    astroSpawner = Timer(
      2,
      onTick: () async {
        for (int i = 0; i < HeartWidget.blocHeartWidget.state; i += 15) {
          await Future.delayed(
              Duration(milliseconds: getRandomNumber(50, 100).round()));
          gameRef.add(Asteroid(
              planePosition: Vector2(position.x + getRandomNumber(-150, 150),
                  position.y + getRandomNumber(-150, 150))));
        }
      },
      repeat: true,
    );

    gameTimer = Timer(
      5,
      onTick: () {
        HeartWidget.blocHeartWidget.incrementValue();
      },
      repeat: true,
    );
    bulletSpawner.start();
    astroSpawner.start();
    gameTimer.start();
  }

  final material.Paint hitboxPaint = BasicPalette.green.paint()
    ..style = material.PaintingStyle.stroke;
  final material.Paint dotPaint = BasicPalette.red.paint()
    ..style = material.PaintingStyle.stroke;

  // @override
  // void render(material.Canvas canvas) {
  //   super.render(canvas);
  //   // This is just to clearly see the vertices in the hitboxes
  //   // hitbox.render(canvas, hitboxPaint);
  //   // hitbox
  //   //     .localVertices()
  //   //     .forEach((p) => canvas.drawCircle(p.toOffset(), 4, dotPaint));
  // }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Asteroid) {
      hitcount++;
      if (hitcount >= 5) {
        try {
          //gameRef.add(AiroPlaneBlaster(Vector2(position.x, position.y)));
        } catch (_) {}
      }
    }
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo info) {
    position = info.eventPosition.game;
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      Vector2 updatePosition = Vector2(position.x, position.y)
        ..add(joystick.relativeDelta * maxSpeed * dt);
      if (updatePosition.x <= 0) updatePosition.x = 0;
      if (updatePosition.y <= 0) updatePosition.y = 0;
      if (updatePosition.x >= gameRef.size.x) updatePosition.x = gameRef.size.x;
      if (updatePosition.y >= gameRef.size.y) updatePosition.y = gameRef.size.y;
      position = updatePosition;
    }
    bulletSpawner.update(dt);
    astroSpawner.update(dt);
    gameTimer.update(dt);
  }
}
