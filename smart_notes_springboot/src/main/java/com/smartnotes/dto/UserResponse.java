package com.smartnotes.dto;

public class UserResponse {
    private String id;
    private String name;
    private String email;
    private String password; // Empty string for compatibility with Flutter app

    public UserResponse(Long id, String name, String email) {
        this.id = id.toString();
        this.name = name;
        this.email = email;
        this.password = ""; // Never send actual password
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
