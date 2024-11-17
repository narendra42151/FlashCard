import 'package:flashcardapp/models/flashcard.dart';
import 'package:get/get.dart';

class FlashcardController extends GetxController {
  final flashcards = <Flashcard>[].obs;
  final currentIndex = 0.obs;

  void addFlashcard(Flashcard flashcard) {
    flashcards.add(flashcard);
  }

  void updateFlashcard(int index, Flashcard flashcard) {
    flashcards[index] = flashcard;
  }

  void deleteFlashcard(int index) {
    flashcards.removeAt(index);
    if (currentIndex.value >= flashcards.length) {
      currentIndex.value = flashcards.isEmpty ? 0 : flashcards.length - 1;
    }
  }

  void nextCard() {
    if (currentIndex.value < flashcards.length - 1) {
      currentIndex.value++;
    }
  }

  void previousCard() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }
}
