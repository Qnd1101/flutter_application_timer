import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // int totalTime = 60;
  int times = 1 * 60; // 1min
  late Timer timer;
  String timeView = '0:00:00';
  bool isRunning = false;

  void timeStart() {
    if (isRunning) {
      // 돌고 있는가? => 시간을 멈춤, 상태 변경
      timeStop();
      setState(() {
        isRunning = !isRunning;
      });
    } else {
      //안돌고 있음 => 돌아감, 변경

      // 1초마다 1씩 내려감.. 일정간격마다 수행
      // periodic = 주기
      setState(() {
        isRunning = !isRunning;
      });
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          timeView = Duration(seconds: times).toString().split('.').first;
          times--;
          if (times < 0) {
            timeStop();
          }
        });
      });
    }
  }

  void timeStop() {
    timer.cancel();
  }

  void timeReset() {
    setState(() {
      times = 60;
      isRunning = false;
      timeStop();
      timeView = Duration(seconds: times).toString().split('.').first;
    });
  }

  void addTime(int sec) {
    times = times + sec;
    times = times < 0 ? 0 : times;
    setState(() {
      timeView = Duration(seconds: times).toString().split('.').first;
    });
  }

  @override
  Widget build(BuildContext context) {
    timeView = Duration(seconds: times).toString().split('.').first;
    return MaterialApp(
      home: Scaffold(
        body: Column(children: [
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Text(
                  'my timer',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    timeButton(sec: 60, color: Colors.amber),
                    timeButton(sec: 30, color: Colors.red),
                    timeButton(sec: -30, color: Colors.lightBlue),
                    timeButton(sec: -60, color: Colors.purpleAccent),
                  ],
                ),
              )),
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.red,
              child: Center(
                child: Text(
                  timeView,
                  style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1), fontSize: 50),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.blue,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isRunning)
                      IconButton(
                          iconSize: 50,
                          onPressed: timeStart,
                          icon: const Icon(Icons.pause_circle_rounded))
                    else
                      IconButton(
                          iconSize: 50,
                          onPressed: timeStart,
                          icon: const Icon(Icons.play_circle_rounded)),
                    IconButton(
                        iconSize: 50,
                        onPressed: timeReset,
                        icon: const Icon(Icons.restore)),
                  ],
                ))),
          ),
        ]),
      ),
    );
  }

  GestureDetector timeButton({required int sec, required Color color}) {
    return GestureDetector(
      onTap: () => addTime(sec),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(
          child: Text('$sec'),
        ),
      ),
    );
  }
}
