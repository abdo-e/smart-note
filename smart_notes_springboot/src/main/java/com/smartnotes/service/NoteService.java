package com.smartnotes.service;

import com.smartnotes.dto.NoteRequest;
import com.smartnotes.dto.NoteResponse;
import com.smartnotes.entity.Note;
import com.smartnotes.repository.NoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class NoteService {

    @Autowired
    private NoteRepository noteRepository;

    public List<NoteResponse> getNotesByUserId(Long userId) {
        List<Note> notes = noteRepository.findByUserIdOrderByIsPinnedDescUpdatedAtDesc(userId);
        return notes.stream()
                .map(NoteResponse::new)
                .collect(Collectors.toList());
    }

    public NoteResponse createNote(NoteRequest request) {
        Note note = new Note();
        note.setUserId(request.getUserId());
        note.setTitle(request.getTitle());
        note.setContent(request.getContent());
        note.setImagePath(request.getImagePath());
        note.setCategory(request.getCategory());
        note.setColor(request.getColor());
        note.setPinned(request.isPinned());

        Note savedNote = noteRepository.save(note);
        return new NoteResponse(savedNote);
    }

    public NoteResponse updateNote(Long id, NoteRequest request) {
        Note note = noteRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Note not found"));

        note.setTitle(request.getTitle());
        note.setContent(request.getContent());
        note.setImagePath(request.getImagePath());
        note.setCategory(request.getCategory());
        note.setColor(request.getColor());
        note.setPinned(request.isPinned());

        Note updatedNote = noteRepository.save(note);
        return new NoteResponse(updatedNote);
    }

    public void deleteNote(Long id) {
        if (!noteRepository.existsById(id)) {
            throw new RuntimeException("Note not found");
        }
        noteRepository.deleteById(id);
    }
}
