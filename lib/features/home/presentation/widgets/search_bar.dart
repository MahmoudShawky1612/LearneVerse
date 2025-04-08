import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final void Function(String) searchFunction;

  const CustomSearchBar(this.searchController, this.searchFunction, {Key? key})
      : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      widget.searchController.text = result.recognizedWords;
    });
    widget.searchFunction(result.recognizedWords);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              child: TextFormField(
                controller: widget.searchController,
                onChanged: widget.searchFunction,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.4)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  suffixIcon: widget.searchController.text.isNotEmpty
                      ? GestureDetector(
                    onTap: () {
                      widget.searchController.clear();
                      widget.searchFunction('');
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
                _speechToText.isNotListening
                    ? _startListening()
                    : _stopListening();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: _speechToText.isListening
                      ? Colors.redAccent
                      : colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _speechToText.isListening ? Icons.mic_off : Icons.mic,
                  size: 20,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
