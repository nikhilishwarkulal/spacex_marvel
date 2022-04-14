import 'package:flutter/material.dart';

import 'flutter_game_screen.dart';

class HudScreen extends StatefulWidget {
  const HudScreen({Key? key}) : super(key: key);

  @override
  _HudScreenState createState() => _HudScreenState();
}

class _HudScreenState extends State<HudScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/splash_logo.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 40,
                    ),
                    child: Text(
                      "SpaceX",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 40,
                    ),
                    child: Text(
                      "Marvel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    width: 280,
                    margin: const EdgeInsets.only(
                      left: 40,
                      top: 30,
                    ),
                    child: const Text(
                      "Spacex Marvel is a open source development game for Leanring and Development and  Research purpose.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FlutterGameScreen()),
                      );
                    },
                    child: Container(
                      height: 56,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 40),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(28)),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text(
                              "Start Game",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 3,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
