import 'package:smart_notes_app/models/Note.dart';
import 'package:smart_notes_app/config/apiConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final String apiBaseUrl = getApiBaseUrl();

Future<List<Note>> fetchNotes(String userId) async {
  final userIdInt = int.parse(userId);
  final url = Uri.parse('$apiBaseUrl/api/notes?userId=$userIdInt');
  try {
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Note.fromJson(json)).toList();
    } else {
      print('Error fetching notes: ${response.statusCode}');
      throw Exception('Error loading notes');
    }
  } catch (e) {
    print('Fetch notes exception: $e');
    throw Exception('Error loading notes');
  }
}

Future<Note?> createNote(String userId, String title, String content, 
    {String? imagePath, String? category, String? color, bool isPinned = false}) async {
  final url = Uri.parse('$apiBaseUrl/api/notes');
  try {
    // Convert userId to integer for Spring Boot Long type
    final userIdInt = int.parse(userId);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userIdInt,
        'title': title,
        'content': content,
        'imagePath': imagePath,
        'category': category,
        'color': color,
        'isPinned': isPinned,
      }),
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Note created successfully!');
      return Note.fromJson(jsonData);
    } else {
      print('Create note error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Create note exception: $e');
    return null;
  }
}

Future<Note?> updateNote(String noteId, String title, String content, 
    {String? imagePath, String? category, String? color, bool isPinned = false}) async {
  final url = Uri.parse('$apiBaseUrl/api/notes/$noteId');
  try {
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'content': content,
        'imagePath': imagePath,
        'category': category,
        'color': color,
        'isPinned': isPinned,
      }),
    );
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Note updated successfully!');
      return Note.fromJson(jsonData);
    } else {
      print('Update note error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Update note exception: $e');
    return null;
  }
}

Future<bool> deleteNote(String noteId) async {
  final url = Uri.parse('$apiBaseUrl/api/notes/$noteId');
  try {
    final response = await http.delete(url);
    
    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Note deleted successfully!');
      return true;
    } else {
      print('Delete note error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Delete note exception: $e');
    return false;
  }
}
