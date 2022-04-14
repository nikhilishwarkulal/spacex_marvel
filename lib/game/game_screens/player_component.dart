import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' as material;
import 'package:spacex_marvel/game/game_screens/game_screen.dart';
import 'package:spacex_marvel/screens/flutter_game_screen.dart';

class AiroPlaneComponent extends Component with HasGameRef {
  JoystickComponent joystick;
  AiroPlaneComponent(this.joystick);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(AiroPlane(joystick));
    // add(AiroPlaneBlaster(joystick));
  }
}

class AiroPlaneBlaster extends SpriteAnimationComponent with HasGameRef {
  Vector2 blastPosition;
  SpriteAnimation? animationt;
  final bool isAiroplane;
  AiroPlaneBlaster(this.blastPosition, {this.isAiroplane = false});
  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = await Flame.images.load('explosion.png');
    FlameAudio.audioCache.play('explosion.ogg');
    animationt = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
          amount: 64,
          amountPerRow: 8,
          stepTime: 0.03,
          textureSize: Vector2(256, 256),
          loop: false),
    );
    final spriteSize = Vector2(140, 140);
    animation = animationt;
    size = spriteSize;
    anchor = Anchor.center;
    position = Vector2(blastPosition.x, blastPosition.y);
    animationt?.onComplete = oncomplete;
  }

  void oncomplete() {
    try {
      gameRef.remove(this);
    } catch (_) {}
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

class AiroPlane extends SpriteAnimationComponent
    with HasGameRef, HasHitboxes, Collidable, Draggable {
  JoystickComponent joystick;
  int hitcount = 0;
  SpriteAnimation? animationt;
  AiroPlane(this.joystick);
  late Timer bulletSpawner;
  late Timer astroSpawner;
  late Timer gameTimer;
  late HitboxPolygon hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = await Flame.images.load('ship_thrust.png');

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
        FlameAudio.audioCache.play('laser_shot.ogg');
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
          gameRef.add(Astraloids(
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

  @override
  void render(material.Canvas canvas) {
    super.render(canvas);
    // This is just to clearly see the vertices in the hitboxes
    // hitbox.render(canvas, hitboxPaint);
    // hitbox
    //     .localVertices()
    //     .forEach((p) => canvas.drawCircle(p.toOffset(), 4, dotPaint));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Astraloids) {
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

double getRandomNumber(double minimum, double maximum) {
  Random random = Random();
  return random.nextDouble() * (maximum - minimum) + minimum;
}

class Astraloids extends SpriteComponent
    with HasGameRef<GameScreen>, HasHitboxes, Collidable {
  final Vector2 planePosition;
  late Vector2 startingPosition;
  late HitboxCircle hitbox;
  int collisionCount = 0;
  late Timer destroyer;
  double rotateValue = 0;

  Astraloids({required this.planePosition});
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

  @override
  void render(material.Canvas canvas) {
    super.render(canvas);
    // This is just to clearly see the vertices in the hitboxes
    // hitbox.render(canvas, hitboxPaint);
  }

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
          gameRef.add(AiroPlaneBlaster(Vector2(position.x, position.y)));
          gameRef.remove(this);
        } catch (_) {}
      }
    }
    if (other is AiroPlane) {
      try {
        gameRef.add(AiroPlaneBlaster(Vector2(position.x, position.y)));
        gameRef.remove(this);
        PlaneLife.shared.incrementValue();
      } catch (_) {}
    }
  }
}

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

  @override
  void render(material.Canvas canvas) {
    super.render(canvas);
    // This is just to clearly see the vertices in the hitboxes
    // hitbox.render(canvas, hitboxPaint);
  }

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
    if (other is Astraloids) {
      try {
        gameRef.remove(this);
      } catch (_) {}
    }
  }
}

const double maxSpeed = 300.0;
