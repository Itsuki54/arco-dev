import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../components/common/child_appbar.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
        title: "ランキング",
        icon: Icon(Icons.emoji_events, size: 40),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 280,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 85,
                            height: 85,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 154, 98, 41),
                              borderRadius: BorderRadius.circular(140),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 154, 98, 41),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 85,
                            height: 85,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 215, 0),
                              borderRadius: BorderRadius.circular(140),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 215, 0),
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 215, 0),
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 215, 0),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 85,
                            height: 85,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 189, 195, 201),
                              borderRadius: BorderRadius.circular(140),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 189, 195, 201),
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 189, 195, 201),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "運動",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
