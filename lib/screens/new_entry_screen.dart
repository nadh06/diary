import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/database_helper.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  NewEntryScreenState createState() => NewEntryScreenState();
}

class NewEntryScreenState extends State<NewEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedMood;
  File? _selectedImage;

  final List<String> moods = ['😊', '😐', '😢', '😡', '😍'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty || _selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and mood are required!')),
      );
      return;
    }

    await DatabaseHelper.instance.insertEntry({
  'title': _titleController.text,
  'content': _contentController.text,
  'mood': _selectedMood,
  'date': DateTime.now().toIso8601String(),
  'imagePath': _selectedImage?.path ?? '',
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Diary Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 5,
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: moods.map((mood) {
                  return ChoiceChip(
                    label: Text(mood, style: TextStyle(fontSize: 18)),
                    selected: _selectedMood == mood,
                    onSelected: (selected) {
                      setState(() => _selectedMood = selected ? mood : null);
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 150)
                  : TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Pick Image'),
                    ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveEntry,
                icon: Icon(Icons.save),
                label: Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
