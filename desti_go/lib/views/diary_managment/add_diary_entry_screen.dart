import 'dart:io';
import 'package:desti_go/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:desti_go/providers/diary_provider.dart';
import 'package:desti_go/providers/authorization_provider.dart';

class AddDiaryEntryScreen extends ConsumerStatefulWidget {
  final DateTime date;
  final String tripId;

  AddDiaryEntryScreen({required this.date, required this.tripId});

  @override
  _AddDiaryEntryScreenState createState() => _AddDiaryEntryScreenState();
}

class _AddDiaryEntryScreenState extends ConsumerState<AddDiaryEntryScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  File? _imageFile;

  //handling picking an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Add a diary entry',
        onLogout: () async {
          try {
            await ref.read(authProvider.notifier).signOut();
            Navigator.pushNamed(context, '/');
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error signing out.')),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Text',
                hintText: 'Enter your diary text here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _imageURLController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                hintText: 'Enter image URL (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            //button to add image from gallery if its null, if not display the picked image
            const SizedBox(height: 16.0),
            _imageFile != null
                ? Image.file(_imageFile!)
                : Center(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 97, 64, 187),
                        foregroundColor: Colors.white,
                        elevation: 5.0,
                        shadowColor: Colors.black.withOpacity(1),
                      ),
                      child: const Text('Pick Image from Gallery'),
                    ),
                  ),
            //adding diary entry based on user input
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String text = _textEditingController.text.trim();
                  //if no url was given set as empty
                  String? imageURL = _imageURLController.text.trim().isEmpty ? null : _imageURLController.text;

                  //if no parameters were added to the entry display error
                  if (text.isEmpty && imageURL == null && _imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter text or image URL or pick an image.')),
                    );
                    return;
                  }

                  try {
                    final diaryNotifier = ref.read(diaryProvider.notifier);
                    await diaryNotifier.addDiaryEntry(
                      tripId: widget.tripId,
                      text: text,
                      imageURL: imageURL,
                      timestamp: widget.date,
                      imageFile: _imageFile,
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add diary entry.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 97, 64, 187),
                  foregroundColor: Colors.white,
                  elevation: 5.0,
                  shadowColor: Colors.black.withOpacity(1),
                ),
                child: const Text('Add Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
