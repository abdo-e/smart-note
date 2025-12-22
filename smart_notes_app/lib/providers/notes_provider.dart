import 'package:flutter/material.dart';
import 'package:smart_notes_app/models/Note.dart';
import 'package:smart_notes_app/services/noteService.dart' as noteService;

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<Note> get notes {
    if (_searchQuery.isEmpty) {
      return _notes;
    }
    return _notes.where((note) {
      return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             note.content.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

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

  Future<bool> addNote(String userId, String title, String content, 
      {String? imagePath, String? category, String? color, bool isPinned = false}) async {
    _errorMessage = null;
    
    try {
      final note = await noteService.createNote(userId, title, content, 
          imagePath: imagePath, category: category, color: color, isPinned: isPinned);
      if (note != null) {
        if (isPinned) {
          _notes.insert(0, note);
        } else {
          // Insert after pinned notes or at end if no pinned notes
          int firstNonPinnedIndex = _notes.indexWhere((n) => !n.isPinned);
          if (firstNonPinnedIndex != -1) {
            _notes.insert(firstNonPinnedIndex, note);
          } else {
            _notes.add(note);
          }
        }
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

  Future<bool> editNote(String noteId, String title, String content, 
      {String? imagePath, String? category, String? color, bool isPinned = false}) async {
    _errorMessage = null;
    
    try {
      final updatedNote = await noteService.updateNote(noteId, title, content, 
          imagePath: imagePath, category: category, color: color, isPinned: isPinned);
      if (updatedNote != null) {
        final index = _notes.indexWhere((note) => note.id == noteId);
        if (index != -1) {
          _notes.removeAt(index);
          // Re-insert to maintain sorting: Pinned first, then by update time (backend handles sorting on fetch)
          // For local updates, we'll just insert based on pinning
          if (updatedNote.isPinned) {
            _notes.insert(0, updatedNote);
          } else {
            int firstNonPinnedIndex = _notes.indexWhere((n) => !n.isPinned);
            if (firstNonPinnedIndex != -1) {
              _notes.insert(firstNonPinnedIndex, updatedNote);
            } else {
              _notes.add(updatedNote);
            }
          }
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

