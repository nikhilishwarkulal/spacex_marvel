import 'dart:async';

import 'package:flame/components.dart';

import 'air_craft.dart';

class GameComponent extends Component with HasGameRef {
  JoystickComponent joystick;
  GameComponent(this.joystick);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(AirCraft(joystick));
    // add(AiroPlaneBlaster(joystick));
  }
}

const double maxSpeed = 300.0;
