# 📱 Yalla Talk App

A real-time **chat application** built with **Flutter**, integrating **Firebase** and **Supabase** to provide authentication, messaging, group chats, and more.  
This project was developed as a learning challenge over 2 months to explore how chat apps like WhatsApp & Telegram handle messaging, authentication, and state management. 🚀

---

## ✨ Features

- 🔐 **Authentication**
  - Login / Signup with email & password
  - Form validation & error handling
  - User profile with name, bio, and avatar

- 💬 **Chat System**
  - 1-to-1 private messaging
  - Group chat support
  - Online / last seen status
  - Read receipts

- 🖼 **Media**
  - Profile & group images stored in **Supabase Storage**
  - Cached image loading

- ⚙️ **User Experience**
  - Dark & light themes
  - Editable profile (name, about, email)
  - Custom snackbars & dialogs

---

## 🛠 Tech Stack

- **Frontend:** Flutter (Material Design, Provider, Bloc)
- **Backend:**
  - Firebase Authentication (login/signup + email verification)
  - Firebase Firestore (real-time database for chats & groups)
  - Supabase (authentication, database, storage for images/files)
- **Packages Used:**
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `supabase_flutter`
  - `provider`
  - `uuid`
  - `cached_network_image`
  - `flutter_native_splash`
  - `photo_view`

---

## 📸 Screenshots

<p align="center">
  <img src="assets/Screenshots/3.png" alt="Screenshot 1" width="250"/>
  <img src="assets/Screenshots/4.png" alt="Screenshot 2" width="250"/>
  <img src="assets/Screenshots/5.png" alt="Screenshot 3" width="250"/>
  <img src="assets/Screenshots/6.png" alt="Screenshot 4" width="250"/>
  <img src="assets/Screenshots/7.png" alt="Screenshot 5" width="250"/>
  <img src="assets/Screenshots/aaa.png" alt="Screenshot 6" width="250"/>
  <img src="assets/Screenshots/Untitled design (29).png" alt="Screenshot 7" width="250"/>
</p>

---

## 🚀 Getting Started

### Prerequisites
- Install [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- Setup a Firebase project & Supabase project  
- Configure your `google-services.json` and `supabase` credentials  

### Installation
```bash
# Clone the repository
git clone https://github.com/your-username/yalla_talk_app.git

# Navigate to project
cd yalla_talk_app

# Install dependencies
flutter pub get

# Run the app
flutter run
