import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class TypingIndicator extends StatefulWidget {
  final String senderName;

  const TypingIndicator({super.key, this.senderName = 'AI Assistant'});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  final int _dotCount = 3;

  @override
  void initState() {
    super.initState();

    _animationControllers = List.generate(_dotCount, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      )..repeat(reverse: true);
    });

    // Stagger the animations
    for (int i = 0; i < _dotCount; i++) {
      _animationControllers[i].forward(from: i * 0.2);
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 46, bottom: 4),
            child: Text(
              widget.senderName,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 30), // Avatar space
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bubbleGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_dotCount, (index) {
                    return AnimatedBuilder(
                      animation: _animationControllers[index],
                      builder: (context, child) {
                        final offset = Tween<double>(
                          begin: 0,
                          end: -8,
                        ).evaluate(_animationControllers[index]);

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          transform: Matrix4.translationValues(0, offset, 0),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
