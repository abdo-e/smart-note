import 'package:flutter/material.dart';
import 'package:smart_notes_app/models/Note.dart';
import 'package:smart_notes_app/services/noteService.dart' as noteService;

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotes(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await noteService.fetchNotes(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load notes: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addNote(String userId, String title, String content, [String? imagePath]) async {
    _errorMessage = null;
    
    try {
      final note = await noteService.createNote(userId, title, content, imagePath);
      if (note != null) {
        _notes.insert(0, note);
        notifyListeners();
        return true;
      }
      _errorMessage = 'Failed to create note';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to create note: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> editNote(String noteId, String title, String content, [String? imagePath]) async {
    _errorMessage = null;
    
    try {
      final updatedNote = await noteService.updateNote(noteId, title, content, imagePath);
      if (updatedNote != null) {
        final index = _notes.indexWhere((note) => note.id == noteId);
        if (index != -1) {
          _notes[index] = updatedNote;
          notifyListeners();
        }
        return true;
      }
      _errorMessage = 'Failed to update note';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update note: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeNote(String noteId) async {
    _errorMessage = null;
    
    try {
      final success = await noteService.deleteNote(noteId);
      if (success) {
        _notes.removeWhere((note) => note.id == noteId);
        notifyListeners();
        return true;
      }
      _errorMessage = 'Failed to delete note';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete note: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearNotes() {
    _notes = [];
    notifyListeners();
  }
}

