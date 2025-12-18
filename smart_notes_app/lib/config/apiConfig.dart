// API Configuration for Smart Notes App
// Update this file to point to your backend server

// Choose the appropriate URL based on your environment:

// For local development with backend running on your computer:
const String apiBaseUrl = 'http://localhost:8080';

// For Android Emulator (use this if testing on Android emulator):
// const String apiBaseUrl = 'http://10.0.2.2:8080';

// For iOS Simulator (use localhost):
// const String apiBaseUrl = 'http://localhost:8080';

// For Physical Device (replace with your computer's IP address):
// const String apiBaseUrl = 'http://192.168.1.100:8080';
// To find your IP: Windows (ipconfig), Mac/Linux (ifconfig)

// For Production (replace with your deployed backend URL):
// const String apiBaseUrl = 'https://your-domain.com';

// Export the base URL
String getApiBaseUrl() {
  return apiBaseUrl;
}
