import 'package:flashcardapp/controller/flashcard_controller.dart';
import 'package:flashcardapp/models/flashcard.dart';
import 'package:flashcardapp/screens/edit_FlashCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final int index;

  FlashcardWidget({required this.flashcard, required this.index});

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _flipAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
    ]).animate(_animationController);
  }

  void flipCard() {
    if (_animationController.isAnimating) return;

    if (isFront) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() => isFront = !isFront);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final angle = _flipAnimation.value * 3.14159;
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              alignment: Alignment.center,
              child: angle < 1.57079
                  ? _buildCardSide(
                      widget.flashcard.question,
                      [Colors.blue.shade400, Colors.blue.shade700],
                      true,
                    )
                  : Transform(
                      transform: Matrix4.identity()..rotateY(3.14159),
                      alignment: Alignment.center,
                      child: _buildCardSide(
                        widget.flashcard.answer,
                        [Colors.purple.shade400, Colors.purple.shade700],
                        false,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardSide(
      String text, List<Color> gradientColors, bool isFrontSide) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      height: MediaQuery.of(context).size.width * 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isFrontSide)
            Positioned(
              right: 8,
              top: 8,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: () => Get.to(
                      () => AddEditFlashcardScreen(
                        flashcard: widget.flashcard,
                        index: widget.index,
                      ),
                      transition: Transition.downToUp,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.white),
                    onPressed: () => _showDeleteDialog(context),
                  ),
                ],
              ),
            ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Icon(
                    Icons.touch_app,
                    color: Colors.white.withOpacity(0.5),
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Flashcard'),
        content: Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final controller = Get.find<FlashcardController>();
              controller.deleteFlashcard(widget.index);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
