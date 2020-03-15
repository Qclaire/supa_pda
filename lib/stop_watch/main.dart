import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class TimerPage extends StatefulWidget {
  static String routeName = "timer_page";
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  var second = 0;
  var minute = 0;
  bool run = false;
  Soundpool sounds;
  int startSound;
  int countdownSound;
  int timeupSound;
  int streamId;
  bool countdown = false;

  void timer() async {
    if (run == true && second > 10 || minute > 0) await sounds.play(startSound);

    Timer.periodic(Duration(seconds: 1), (timeout) async {
      if (!run) {
        timeout.cancel();
      }

      if (second > 1) {
        setState(() {
          second -= 1;
        });
        if (second <= 10 && second > 1 && minute == 0) {
          setState(() async {
            streamId = await sounds.play(countdownSound);
          });
        }
        if (second <= 1 && minute == 0) {
          await sounds.play(timeupSound);
        }
      } else if (second <= 1 && minute > 0) {
        setState(() {
          second = 59;
          minute -= 1;
        });
      } else if (second <= 1 && minute == 0) {
        timeout.cancel();
        setState(() {
          second = 0;
          run = false;
        });

        print("Timeout");
      }
    });
  }

  void loadSounds() async {
    sounds = Soundpool(streamType: StreamType.alarm, maxStreams: 3);

    startSound =
        await rootBundle.load("assets/timer/sounds/start.mp3").then((data) {
      return sounds.load(data);
    });

    countdownSound =
        await rootBundle.load("assets/timer/sounds/count.mp3").then((data) {
      return sounds.load(data);
    });
    timeupSound =
        await rootBundle.load("assets/timer/sounds/timeup.mp3").then((data) {
      return sounds.load(data);
    });
    await sounds.setVolume(soundId: countdownSound, volume: 0.70);
    await sounds.setVolume(soundId: timeupSound, volume: 0.80);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSounds();
  }

  @override
  Widget build(BuildContext context) {
    int mup = 0;
    int sup = 0;
    int mdown = 0;
    int sdown = 0;
    int mod = 5;

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onLongPress: () async {
              setState(() {
                run = !run;
              });
              if (run == true && !(second <= 1) && !(minute == 0)) {
                await sounds.play(startSound);
              }
              timer();

              // playSound here
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onVerticalDragUpdate: (resp) {
                      if (!run && resp.delta.dy < 0) {
                        mup = (mup + 1) % mod;
                        if (mup == 0 && minute < 99) {
                          setState(() {
                            minute += 1;
                          });
                        }
                      } else if (!run && resp.delta.dy > 0) {
                        mdown = (mdown + 1) % mod;
                        if (mdown == 0 && 0 < minute)
                          setState(() {
                            minute -= 1;
                          });
                      }
                    },
                    child: Text(
                      "${minute < 10 ? "0$minute" : minute}",
                      style: TextStyle(
                          fontFamily: "times",
                          fontSize: 500,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onVerticalDragUpdate: (resp) {
                      if (!run && resp.delta.dy < 0) {
                        sup = (sup + 1) % mod;
                        if (sup == 0 && second < 60) {
                          setState(() {
                            second += 1;
                          });
                        }
                      } else if (!run && resp.delta.dy > 0) {
                        sdown = (sdown + 1) % mod;
                        if (sdown == 0 && 0 < second)
                          setState(() {
                            second -= 1;
                          });
                      }
                    },
                    child: Text(
                      "${second < 10 ? "0$second" : second}",
                      style: TextStyle(
                          fontFamily: "times",
                          fontSize: 460,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
//    controller?.dispose();
    super.dispose();
  }
}
