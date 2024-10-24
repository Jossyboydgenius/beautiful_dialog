import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';

class GamifiedDialog {
  static void showGamifiedDialog(BuildContext context) {
    int score = 0;
    int highestScore = 0;
    int targetNumber = Random().nextInt(10) + 1;
    Timer? timer;
    int timeLeft = 30;
    AudioPlayer audioPlayer = AudioPlayer();
    AudioPlayer backgroundMusicPlayer = AudioPlayer();

    void startTimer(Function setState) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            timer.cancel();
            BotToast.showText(text: "Time's up!");
          }
        });
      });
    }

    void playSound(String sound) {
      audioPlayer.play(AssetSource(sound));
    }

    void playBackgroundMusic() {
      backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      backgroundMusicPlayer.play(AssetSource('background_music.ogg'));
    }

    void stopBackgroundMusic() {
      backgroundMusicPlayer.stop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (timer == null) {
              startTimer(setState);
              playBackgroundMusic();
            }
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Center(
                child: Text(
                  "Guess the Number Game",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ),
              content: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.lightGreenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Guess a number between 1 and 10",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'CustomFont'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Score: $score",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'CustomFont'),
                    ),
                    Text(
                      "Highest Score: $highestScore",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'CustomFont'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Time Left: $timeLeft",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.redAccent,
                          fontFamily: 'CustomFont'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'CustomFont'),
                          ),
                          onPressed: () {
                            if (index + 1 == targetNumber) {
                              setState(() {
                                score++;
                                if (score > highestScore) {
                                  highestScore = score;
                                }
                                targetNumber = Random().nextInt(10) + 1;
                                timeLeft = 30;
                              });
                              playSound('correct.ogg');
                              BotToast.showText(
                                  text: "Correct! New number generated.");
                            } else {
                              playSound('wrong.ogg');
                              BotToast.showText(
                                  text: "Wrong guess. Try again!");
                            }
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          child: Text(
                            "${index + 6}",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'CustomFont'),
                          ),
                          onPressed: () {
                            if (index + 6 == targetNumber) {
                              setState(() {
                                score++;
                                if (score > highestScore) {
                                  highestScore = score;
                                }
                                targetNumber = Random().nextInt(10) + 1;
                                timeLeft = 30;
                              });
                              playSound('correct.ogg');
                              BotToast.showText(
                                  text: "Correct! New number generated.");
                            } else {
                              playSound('wrong.ogg');
                              BotToast.showText(
                                  text: "Wrong guess. Try again!");
                            }
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    timer?.cancel();
                    stopBackgroundMusic();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
