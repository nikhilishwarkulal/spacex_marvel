import 'package:flutter/material.dart';
import 'package:spacex_marvel/core/bloc/bloc.dart';
import 'package:spacex_marvel/game_bloc/plane_life_bloc.dart';
import 'package:spacex_marvel/screens/flutter_game_screen.dart';

class HeartWidgetBloc extends Bloc<int> {
  @override
  int initDefaultValue() {
    return 0;
  }

  void reset() {
    emit(0);
  }

  void setValue(int value) {
    emit(value);
  }

  void incrementValue() {
    if (state >= 100) {
      return;
    }
    if (state < 100) {
      emit(state + 1);
      if (state == 100) {
        if (FlutterGameScreen.cont != null) {
          Navigator.pop(FlutterGameScreen.cont!);
          PlaneLifeBloc.shared.reset();
          HeartWidget.blocHeartWidget.reset();
        }
      }
    }
  }
}
