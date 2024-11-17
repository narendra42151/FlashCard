import 'package:flashcardapp/controller/flashcard_controller.dart';
import 'package:flashcardapp/models/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditFlashcardScreen extends StatelessWidget {
  final FlashcardController controller = Get.find();
  final Flashcard? flashcard;
  final int? index;

  AddEditFlashcardScreen({this.flashcard, this.index});

  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize text controllers if editing existing flashcard
    if (flashcard != null) {
      _questionController.text = flashcard!.question;
      _answerController.text = flashcard!.answer;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(flashcard == null ? 'Create Flashcard' : 'Edit Flashcard'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                controller: _questionController,
                label: 'Question',
                maxLines: 4,
              ),
              SizedBox(height: 24),
              _buildInputField(
                controller: _answerController,
                label: 'Answer',
                maxLines: 4,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveFlashcard,
                child: Text(flashcard == null ? 'Create' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  void _saveFlashcard() {
    if (_formKey.currentState?.validate() ?? false) {
      final newFlashcard = Flashcard(
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
      );

      if (flashcard == null) {
        // Creating new flashcard
        controller.addFlashcard(newFlashcard);
        Get.back();
        Get.snackbar(
          'Success',
          'Flashcard created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(8),
        );
      } else {
        // Updating existing flashcard
        controller.updateFlashcard(index!, newFlashcard);
        Get.back();
        Get.snackbar(
          'Success',
          'Flashcard updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(8),
        );
      }
    }
  }
}
