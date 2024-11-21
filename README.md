
# Maps App

A simple yet powerful application that leverages Google Maps to provide seamless navigation, enriched with Firebase integration and localization support.


## 📱 Features
- **Clean Architecture:** Adheres to modular and maintainable architecture practices.
- **Authentication:** Firebase OTP-based authentication for secure login and registration.
- **Data Storage:** Firebase Firestore for cloud data storage and Sqflite for local data persistence.
- **Localization:** Fully supports both English and Arabic languages.
- **Google Maps Integration:** Features include location detection, distance and time calculation, and marker placement using Google Maps API.



## 🛠️ Tech Stack
- **Frontend:** Flutter framework
- **State Management:** Bloc (Cubit)
- **Backend Services:** Firebase (Auth, Firestore)
- **Networking:** Dio for HTTP requests
- **Database:** Sqflite for local storage
- **Localization:** Multilingual support for English and Arabic

## ⚙️ Installation and Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/AbdoWa7eed/maps_app.git
   ```

2. Navigate to the project directory:
   ```bash
   cd maps_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Set up API Keys:
   -  Add your Google Maps API key in AndroidManifest.xml:
   
     ```xml
             <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="your-api-key"/>
     ```

5. Configure Firebase:
   - Link the app to your Firebase project for authentication and Firestore.

6. Run the app:
   ```bash
   flutter run
   ```


## 🤝 Contribution
We welcome contributions! Fork the repository, make your changes, and submit a pull request.

## 📬 Contact
For any inquiries, please reach out to [Abdelrahman Waheed](https://github.com/AbdoWa7eed).
## 📹 Demo 

https://github.com/user-attachments/assets/847c0a82-711a-46bf-afab-e82f5eab6464



