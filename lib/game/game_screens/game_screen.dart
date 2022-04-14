import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/widgets.dart' as widget;
import 'package:spacex_marvel/game/game_screens/game_component.dart';
import 'package:spacex_marvel/game/game_screens/parallax_component.dart';

class GameScreen extends FlameGame
    with HasDraggables, HasCollidables, HasDraggables {
  late ParallaxComponent parallaxComponent;
  late final GameComponent player;
  late final JoystickComponent joystick;
  late final Sprite bulletSprite;
  late final Sprite astrolidSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    Image bulletImage = await Flame.images.load('bullet.png');
    Image astrolidSpriteImage = await Flame.images.load('stro_s.png');

    bulletSprite = Sprite(
      bulletImage,
      srcPosition: Vector2(16, 0),
      srcSize: Vector2(16, 16),
    );

    astrolidSprite = Sprite(
      astrolidSpriteImage,
    );
    add(await SpaceXParallaxComponent().get(
        spaceXParallaxComponentType:
            SpaceXParallaxComponentType.purpleNebulaSix,
        gameRef: this));

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(20).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: widget.EdgeInsets.only(bottom: 0, left: (canvasSize.x / 2) - 100),
    );
    player = GameComponent(joystick);
    add(player);
    //add(joystick);
  }
}
