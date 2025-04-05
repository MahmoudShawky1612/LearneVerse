import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

import 'contributions.dart';

class ContributionHeader extends StatelessWidget {
  const ContributionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Yearly Contributions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "364 contributions in the last year",
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 15),
          const SizedBox(
            height: 130,
            child: YearContributionChart(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Less",
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6))),
              const SizedBox(width: 4),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 2),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 2),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 2),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 2),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text("More",
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
        ],
      ),
    );
  }
}
