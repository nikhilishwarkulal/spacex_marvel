import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spacex_marvel/bloc/bloc.dart';
import 'package:spacex_marvel/bloc/bloc_builder.dart';
import 'package:spacex_marvel/game/game_screens/game_screen.dart';

class FlutterGameScreen extends StatefulWidget {
  const FlutterGameScreen({Key? key}) : super(key: key);
  static BuildContext? cont;
  @override
  _FlutterGameScreenState createState() => _FlutterGameScreenState();
}

class _FlutterGameScreenState extends State<FlutterGameScreen> {
  late GameScreen gameScreen;

  @override
  void initState() {
    super.initState();
    gameScreen = GameScreen();
  }

  @override
  Widget build(BuildContext context) {
    FlutterGameScreen.cont = context;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget(game: gameScreen),
            const HeartWidget(),
            const HeartList()
          ],
        ),
      ),
    );
  }
}

class HeartList extends StatelessWidget {
  const HeartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: BlocBuilder(
          bloc: PlaneLife.shared,
          builder: () {
            return Row(
              children: getHeart(PlaneLife.shared.state),
            );
          }),
    );
  }

  List<Widget> getHeart(int n) {
    List<Widget> list = [];
    for (int i = 0; i < n; i++) {
      list.add(Container(
        height: 25,
        width: 25,
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.only(
          top: 4,
        ),
        child: Image.asset("assets/images/heart_pulse.png"),
      ));
    }
    return list;
  }
}

class PlaneLife extends Bloc<int> {
  static PlaneLife shared = PlaneLife();
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
        PlaneLife.shared.reset();
        HeartWidget.blocHeartWidget.reset();
      }
    }
  }
}

class HeartWidget extends StatelessWidget {
  const HeartWidget({Key? key}) : super(key: key);
  static BlocHeartWidget blocHeartWidget = BlocHeartWidget();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: BlocBuilder(
          bloc: blocHeartWidget,
          builder: () {
            return Container(
              height: 3,
              width: MediaQuery.of(context).size.width *
                  (blocHeartWidget.state / 100),
              color: Colors.green,
            );
          }),
    );
  }
}

class BlocHeartWidget extends Bloc<int> {
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
          PlaneLife.shared.reset();
          HeartWidget.blocHeartWidget.reset();
        }
      }
    }
  }
}
