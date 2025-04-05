import 'package:flutter/material.dart';
import 'package:flutterwidgets/core/constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) searchFunction;

  const CustomSearchBar(this.searchController, this.searchFunction,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeExtension = theme.extension<AppThemeExtension>();

    return Center(
      child: Container(
        width: 380,
        height: 60,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.search,
                color: colorScheme.onSurface.withOpacity(0.6),
                size: 26,
              ),
            ),
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: searchFunction,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle:
                      TextStyle(color: colorScheme.onSurface.withOpacity(0.4)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  suffixIcon: searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            searchController.clear();
                            searchFunction('');
                          },
                          child: Icon(
                            Icons.close,
                            color: colorScheme.onSurface.withOpacity(0.6),
                            size: 20,
                          ),
                        )
                      : null,
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Microphone functionality
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  gradient: themeExtension?.buttonGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.mic,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
