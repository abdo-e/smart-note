# Smart Notes

A comprehensive note-taking application featuring a Flutter mobile frontend and a Spring Boot backend.

## Project Structure

The project is divided into two main components:

- **smart_notes_app**: A Flutter-based mobile application.
- **smart_notes_springboot**: A Spring Boot REST API backed by MariaDB.

## Prerequisites

- **Flutter SDK**: [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Java JDK 17+**: [Install Java](https://www.oracle.com/java/technologies/downloads/)
- **MariaDB**: [Install MariaDB](https://mariadb.org/download/)

## Setup Instructions

### Backend (Smart Notes API)

1.  Navigate to the backend directory:
    ```bash
    cd smart_notes_springboot
    ```
2.  Configure your database settings in `src/main/resources/application.properties` (ensure you create a database named `smart_notes` or similar as per your config).
3.  Run the application:
    ```bash
    ./mvnw spring-boot:run
    ```

### Frontend (Smart Notes App)

1.  Navigate to the app directory:
    ```bash
    cd smart_notes_app
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the application:
    ```bash
    flutter run
    ```

## Features

- User Authentication (Login/Register)
- Create, Read, Update, and Delete Notes
- Cross-platform support via Flutter
