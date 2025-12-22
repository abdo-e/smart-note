import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes_app/providers/auth_provider.dart';
import 'package:smart_notes_app/providers/notes_provider.dart';
import 'package:smart_notes_app/models/Note.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({super.key});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  
  Note? currentNote;
  bool isEditMode = false;
  String? _imageBase64;
  File? _imageFile;
  bool _isPinned = false;
  String? _selectedCategory;
  Color _selectedColor = Color(0xFF6A5ACD); // Default color

  final List<String> _categories = ['Personal', 'Work', 'Study', 'Ideas', 'Others'];
  final List<Color> _colors = [
    Color(0xFF6A5ACD), // Slate Blue
    Colors.red[400]!,
    Colors.green[400]!,
    Colors.blue[400]!,
    Colors.orange[400]!,
    Colors.pink[400]!,
    Colors.teal[400]!,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentNote == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      
      if (args != null) {
        currentNote = args['note'] as Note?;
        
        if (currentNote != null) {
          isEditMode = true;
          titleController.text = currentNote!.title;
          contentController.text = currentNote!.content;
          _imageBase64 = currentNote!.imagePath;
          _isPinned = currentNote!.isPinned;
          _selectedCategory = currentNote!.category;
          if (currentNote!.color != null) {
            try {
              _selectedColor = Color(int.parse(currentNote!.color!));
            } catch (e) {
              _selectedColor = Color(0xFF6A5ACD);
            }
          }
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
      _imageBase64 = null;
    });
  }

  Future<void> handleSaveNote(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      
      if (authProvider.currentUser == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      bool success;
      if (isEditMode) {
        success = await notesProvider.editNote(
          currentNote!.id,
          titleController.text,
          contentController.text,
          imagePath: _imageBase64,
          category: _selectedCategory,
          color: _selectedColor.value.toString(),
          isPinned: _isPinned,
        );
      } else {
        success = await notesProvider.addNote(
          authProvider.currentUser!.id,
          titleController.text,
          contentController.text,
          imagePath: _imageBase64,
          category: _selectedCategory,
          color: _selectedColor.value.toString(),
          isPinned: _isPinned,
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode ? 'Note updated successfully' : 'Note created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notesProvider.errorMessage ?? 'Error saving note'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Note' : 'Add Note',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6A5ACD),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () {
              setState(() {
                _isPinned = !_isPinned;
              });
            },
            tooltip: _isPinned ? 'Unpin' : 'Pin',
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and Color Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    height: 58,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Color: '),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Pick a Color'),
                                content: Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: _colors.map((color) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedColor = color;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                          border: _selectedColor == color
                                              ? Border.all(color: Colors.black, width: 2)
                                              : null,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _selectedColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: 'Write your note here...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 120),
                    child: Icon(Icons.notes),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[50],
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Content is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Text(
                'Image (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo_library, color: Colors.white),
                    label: Text('Choose Image', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A5ACD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  if (_imageBase64 != null) ...[
                    SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _removeImage,
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      label: Text('Remove', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ],
              ),
              if (_imageBase64 != null) ...[
                SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF6A5ACD), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      base64Decode(_imageBase64!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 32),
              Consumer<NotesProvider>(
                builder: (context, notesProvider, child) {
                  return notesProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () => handleSaveNote(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6A5ACD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isEditMode ? 'Update Note' : 'Save Note',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
