import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YearContributionChart extends StatelessWidget {
  const YearContributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Generate random contribution data (52 weeks x 7 days)
    final Random random = Random(42); // Fixed seed for consistent preview
    final List<List<int>> contributionData = List.generate(
      52, // weeks in a year
      (_) => List.generate(
        7, // days per week
        (_) => random.nextInt(5), // 0-4 contribution levels
      ),
    );

    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: months
                .map((month) => Text(
                      month,
                      style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withOpacity(0.6)),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 5),
        // Contribution grid
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: 52 * 7,
            itemBuilder: (context, index) {
              final int week = index ~/ 7;
              final int day = index % 7;
              final int value = contributionData[week][day];

              Color cellColor;
              switch (value) {
                case 0:
                  cellColor = colorScheme.primary.withOpacity(0.1);
                  break;
                case 1:
                  cellColor = colorScheme.primary.withOpacity(0.3);
                  break;
                case 2:
                  cellColor = colorScheme.primary.withOpacity(0.5);
                  break;
                case 3:
                  cellColor = colorScheme.primary.withOpacity(0.7);
                  break;
                case 4:
                  cellColor = colorScheme.primary;
                  break;
                default:
                  cellColor = colorScheme.primary.withOpacity(0.1);
              }

              return Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
