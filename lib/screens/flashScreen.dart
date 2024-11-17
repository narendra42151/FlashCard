import 'package:flashcardapp/controller/flashcard_controller.dart';
import 'package:flashcardapp/screens/edit_FlashCard.dart';
import 'package:flashcardapp/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  final FlashcardController controller = Get.put(FlashcardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Flashcards',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 28),
                  onPressed: () => Get.to(
                    () => AddEditFlashcardScreen(),
                    transition: Transition.downToUp,
                  ),
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: Obx(() {
              if (controller.flashcards.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildFlashcardView(context);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.library_books_outlined,
              size: 72,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No flashcards yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first flashcard to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Create Flashcard'),
            onPressed: () => Get.to(
              () => AddEditFlashcardScreen(),
              transition: Transition.downToUp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: Hero(
                tag: 'flashcard',
                child: Obx(() => FlashcardWidget(
                      flashcard:
                          controller.flashcards[controller.currentIndex.value],
                      index: controller.currentIndex.value,
                    )),
              ),
            ),
          ),
        ),
        _buildNavigationControls(context),
      ],
    );
  }

  Widget _buildNavigationControls(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: controller.previousCard,
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.1),
                padding: EdgeInsets.all(12),
              ),
            ),
            Obx(() => AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    '${controller.currentIndex.value + 1}/${controller.flashcards.length}',
                    key: ValueKey(controller.currentIndex.value),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                )),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_rounded),
              onPressed: controller.nextCard,
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.1),
                padding: EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
