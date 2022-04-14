import 'package:flutter/material.dart';
import 'package:spacex_marvel/core/bloc/bloc.dart';
import 'package:spacex_marvel/screens/flutter_game_screen.dart';

class PlaneLifeBloc extends Bloc<int> {
  static PlaneLifeBloc shared = PlaneLifeBloc();
  DateTime duration = DateTime.now();
  @override
  int initDefaultValue() {
    return 5;
  }

  void reset() {
    emit(5);
  }

  void incrementValue() {
    if (state <= 0) return;
    if (duration.difference(DateTime.now()).inSeconds.abs() <= 1) {
      return;
    }
    duration = DateTime.now();
    emit(state - 1);
    if (state == 0) {
      if (FlutterGameScreen.cont != null) {
        Navigator.pop(FlutterGameScreen.cont!);
        PlaneLifeBloc.shared.reset();
        HeartWidget.blocHeartWidget.reset();
      }
    }
  }
}
