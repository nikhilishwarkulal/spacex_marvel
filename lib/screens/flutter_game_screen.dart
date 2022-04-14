import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:spacex_marvel/core/bloc/bloc_builder.dart';
import 'package:spacex_marvel/game/game_screens/game_screen.dart';
import 'package:spacex_marvel/game_bloc/heart_widget_bloc.dart';
import 'package:spacex_marvel/game_bloc/plane_life_bloc.dart';

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
          bloc: PlaneLifeBloc.shared,
          builder: () {
            return Row(
              children: getHeart(PlaneLifeBloc.shared.state),
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

class HeartWidget extends StatelessWidget {
  const HeartWidget({Key? key}) : super(key: key);
  static HeartWidgetBloc blocHeartWidget = HeartWidgetBloc();
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
