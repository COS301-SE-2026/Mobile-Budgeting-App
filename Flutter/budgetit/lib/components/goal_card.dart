import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {

  final String title;
  final String saved;
  final String target;
  final double progress;

  const GoalCard({
    super.key,
    required this.title,
    required this.saved,
    required this.target,
    required this.progress,
  });

  static const Color darkGreen =
      Color(0xFF04240C);

  static const Color cream =
      Color(0xFFDDD6AE);

  static const Color teal =
      Color(0xFF137E84);

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: darkGreen,

        borderRadius:
            BorderRadius.circular(25),

        border: Border.all(
          color: cream.withValues(
            alpha: 0.2,
          ),
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.25,
            ),

            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(

            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              Text(
                title,

                style: const TextStyle(
                  color: cream,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const Icon(
                Icons.flag,
                color: teal,
              ),
            ],
          ),

          const SizedBox(height: 15),

          ClipRRect(

            borderRadius:
                BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,

              backgroundColor:
                  const Color(0x33DDD6AE),

              color: teal,
            ),
          ),

          const SizedBox(height: 15),

          Row(

            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              Text(
                "Saved: $saved",

                style: const TextStyle(
                  color: cream,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                "Target: $target",

                style: TextStyle(
                  color: cream.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}