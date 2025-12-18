# Smart Notes Spring Boot Backend

Backend REST API for the Smart Notes Flutter application using Spring Boot and MariaDB.

## Features

- User authentication (register/login) with BCrypt password hashing
- Notes CRUD operations (Create, Read, Update, Delete)
- RESTful API endpoints
- MariaDB database with JPA/Hibernate
- CORS enabled for Flutter app
- Input validation
- Error handling

## Prerequisites

- Java JDK 17 or higher
- Maven 3.6+
- MariaDB 10.3+ (running on port 3307)
- Database `smart_notes` created
- Database user `smartnotes` with password `smartnotes123`

## Installation

1. **Clone/Navigate to project:**
   ```bash
   cd c:\Users\abdo4\OneDrive\Desktop\flutter\smart_notes_springboot
   ```

2. **Configure database** (if needed):
   Edit `src/main/resources/application.properties`:
   ```properties
   spring.datasource.url=jdbc:mariadb://localhost:3307/smart_notes
   spring.datasource.username=smartnotes
   spring.datasource.password=smartnotes123
   ```

3. **Build the project:**
   ```bash
   mvn clean install
   ```

## Running the Server

```bash
mvn spring-boot:run
```

The server will start on `http://localhost:8080`

## API Endpoints

### Authentication

- **POST** `/api/auth/register` - Register new user
  - Body: `{ "name": "string", "email": "string", "password": "string" }`
  - Response: User object

- **POST** `/api/auth/login` - Login user
  - Body: `{ "email": "string", "password": "string" }`
  - Response: User object

### Notes

- **GET** `/api/notes?userId={userId}` - Get all notes for user
  - Response: Array of notes

- **POST** `/api/notes` - Create new note
  - Body: `{ "userId": number, "title": "string", "content": "string" }`
  - Response: Created note object

- **PUT** `/api/notes/{id}` - Update note
  - Body: `{ "title": "string", "content": "string" }`
  - Response: Updated note object

- **DELETE** `/api/notes/{id}` - Delete note
  - Response: Success message

## Database Schema

Tables are auto-created by Hibernate from entities:

### Users Table
- id (Long, auto-increment)
- name (String)
- email (String, unique)
- password (String, hashed)
- created_at (LocalDateTime)

### Notes Table
- id (Long, auto-increment)
- user_id (Long, foreign key)
- title (String)
- content (Text)
- created_at (LocalDateTime)
- updated_at (LocalDateTime)

## Security

- Passwords hashed with BCrypt
- Input validation on all endpoints
- CORS configured for Flutter app
- SQL injection protection via JPA

## Connecting Flutter App

No changes needed! The API endpoints match the Node.js version.

Just ensure `apiConfig.dart` points to:
```dart
const String apiBaseUrl = 'http://localhost:8080';
```

## Troubleshooting

**Build fails:**
- Ensure Java 17+ is installed: `java -version`
- Ensure Maven is installed: `mvn -version`

**Database connection fails:**
- Verify MariaDB is running
- Check credentials in `application.properties`
- Ensure database `smart_notes` exists
- Ensure user `smartnotes` has permissions

**Port 8080 in use:**
- Change port in `application.properties`: `server.port=3000`
- Update Flutter app `apiConfig.dart` accordingly

## License

ISC
