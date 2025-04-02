import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) searchFunction;

  const CustomSearchBar(this.searchController, this.searchFunction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 380,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.search,
                color: Colors.black54,
                size: 26,
              ),
            ),
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: searchFunction,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            GestureDetector(
              onTap: () {
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.mic,
                  color: Colors.white,
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
