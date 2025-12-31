import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_notes_app/models/Note.dart';
import 'package:smart_notes_app/services/noteService.dart' as noteService;

class NotesState {
  final List<Note> notes;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  NotesState({
    this.notes = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
  });

  List<Note> get filteredNotes {
    if (searchQuery.isEmpty) {
      return notes;
    }
    return notes.where((note) {
      return note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
             note.content.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  NotesState copyWith({
    List<Note>? notes,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    bool clearErrorMessage = false,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NotesNotifier extends Notifier<NotesState> {
  @override
  NotesState build() {
    return NotesState();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> loadNotes(String userId) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final fetchedNotes = await noteService.fetchNotes(userId);
      state = state.copyWith(notes: fetchedNotes, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to load notes: $e', isLoading: false);
    }
  }

  Future<bool> addNote(String userId, String title, String content, 
      {String? imagePath, String? category, String? color, bool isPinned = false}) async {
    state = state.copyWith(clearErrorMessage: true);
    
    try {
      final note = await noteService.createNote(userId, title, content, 
          imagePath: imagePath, category: category, color: color, isPinned: isPinned);
      if (note != null) {
        final newNotes = List<Note>.from(state.notes);
        if (isPinned) {
          newNotes.insert(0, note);
        } else {
          int firstNonPinnedIndex = newNotes.indexWhere((n) => !n.isPinned);
          if (firstNonPinnedIndex != -1) {
            newNotes.insert(firstNonPinnedIndex, note);
          } else {
            newNotes.add(note);
          }
        }
        state = state.copyWith(notes: newNotes);
        return true;
      }
      state = state.copyWith(errorMessage: 'Failed to create note');
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to create note: $e');
      return false;
    }
  }

  Future<bool> editNote(String noteId, String title, String content, 
      {String? imagePath, String? category, String? color, bool isPinned = false}) async {
    state = state.copyWith(clearErrorMessage: true);
    
    try {
      final updatedNote = await noteService.updateNote(noteId, title, content, 
          imagePath: imagePath, category: category, color: color, isPinned: isPinned);
      if (updatedNote != null) {
        final newNotes = List<Note>.from(state.notes);
        final index = newNotes.indexWhere((note) => note.id == noteId);
        if (index != -1) {
          newNotes.removeAt(index);
          if (updatedNote.isPinned) {
            newNotes.insert(0, updatedNote);
          } else {
            int firstNonPinnedIndex = newNotes.indexWhere((n) => !n.isPinned);
            if (firstNonPinnedIndex != -1) {
              newNotes.insert(firstNonPinnedIndex, updatedNote);
            } else {
              newNotes.add(updatedNote);
            }
          }
          state = state.copyWith(notes: newNotes);
        }
        return true;
      }
      state = state.copyWith(errorMessage: 'Failed to update note');
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update note: $e');
      return false;
    }
  }

  Future<bool> removeNote(String noteId) async {
    state = state.copyWith(clearErrorMessage: true);
    
    try {
      final success = await noteService.deleteNote(noteId);
      if (success) {
        final newNotes = state.notes.where((note) => note.id != noteId).toList();
        state = state.copyWith(notes: newNotes);
        return true;
      }
      state = state.copyWith(errorMessage: 'Failed to delete note');
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete note: $e');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }

  void clearNotes() {
    state = state.copyWith(notes: []);
  }
}

final notesProvider = NotifierProvider<NotesNotifier, NotesState>(() {
  return NotesNotifier();
});

