import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

class Blast extends SpriteAnimationComponent with HasGameRef {
  Vector2 blastPosition;
  SpriteAnimation? animationt;
  final bool isAiroplane;
  Blast(this.blastPosition, {this.isAiroplane = false});
  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = await Flame.images.load('explosion.png');
    FlameAudio.audioCache.play('explosion.wav');
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

  // @override
  // void update(double dt) {
  //   super.update(dt);
  // }
}
