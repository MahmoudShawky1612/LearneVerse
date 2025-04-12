import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final void Function(String) searchFunction;
  final String hintText;

  const CustomSearchBar({
     required this.searchController,
     required this.searchFunction,
    this.hintText = 'Search...',
  }) ;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _isSpeechAvailable = false;
  late AnimationController _micAnimationController;
  late Animation<double> _micScaleAnimation;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _micScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut),
    );
    widget.searchController.addListener(_updateClearButtonVisibility);
    _focusNode.addListener(() => setState(() {}));
  }

  Future<void> _initSpeech() async {
    try {
      _isSpeechAvailable = await _speechToText.initialize(
        onError: (error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech recognition error: ${error.errorMsg}')),
        ),
      );
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to initialize speech recognition')),
        );
      }
    }
  }

  void _updateClearButtonVisibility() {
    setState(() {
      // Using the original logic for showing clear button
    });
  }

  Future<void> _startListening() async {
    if (!_isSpeechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        partialResults: true,
      ),
    );
    _micAnimationController.forward();
    if (mounted) setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    _micAnimationController.reverse();
    if (mounted) setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (mounted) {
      setState(() {
        widget.searchController.text = result.recognizedWords;
        if (result.finalResult) {
          widget.searchFunction(result.recognizedWords);
          _micAnimationController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _micAnimationController.dispose();
    widget.searchController.removeListener(_updateClearButtonVisibility);
    _focusNode.dispose();
    _speechToText.stop();
    super.dispose();
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
          border: Border.all(
            color: _focusNode.hasFocus ? colorScheme.primary : Colors.transparent,
            width: 1.5,
          ),
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
                focusNode: _focusNode,
                onChanged: widget.searchFunction,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
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
                textInputAction: TextInputAction.search,
              ),
            ),
            GestureDetector(
              onTap: () {
                _speechToText.isNotListening
                    ? _startListening()
                    : _stopListening();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ScaleTransition(
                  scale: _micScaleAnimation,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: _speechToText.isListening
                          ? Colors.redAccent
                          : colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _speechToText.isListening ? Icons.mic_off : Icons.mic,
                      size: 20,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}