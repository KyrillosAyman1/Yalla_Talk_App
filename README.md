# 📱 Yalla Talk App

A real-time **chat application** built with **Flutter**, integrating **Firebase** and **Supabase** to deliver a seamless messaging experience similar to WhatsApp & Telegram.

This project was developed over 2 months as a learning journey to master real-time systems, authentication, and scalable app architecture. 🚀

---

# 📸 App Screenshots

| Login | Chat | Profile |
|------|------|--------|
| ![1](assets/Screenshots/3.png) | ![2](assets/Screenshots/4.png) | ![3](assets/Screenshots/5.png) |

| Groups | Contacts | Settings |
|------|----------|----------|
| ![4](assets/Screenshots/6.png) | ![5](assets/Screenshots/7.png) | ![6](assets/Screenshots/aaa.png) |

---

# ✨ Features

## 🔐 Authentication
- Signup / Login with Email & Password
- Email verification
- Form validation & error handling

## 👤 User Profile
- Edit name, bio, profile image
- Last seen status
- Profile customization

## 💬 Chat System
- Real-time private messaging
- Group chats with admins
- Read receipts
- Online / last seen indicators
- Delete messages (soft delete UI)

## 👥 Groups
- Create groups
- Add / remove members
- Promote / demote admins

## 🖼 Media Support
- Send & receive images
- Supabase Storage integration
- Cached image loading

## ⚙️ UI/UX
- Dark & Light themes
- Clean Material Design UI
- Custom dialogs & snackbars
- Smooth navigation

---

# 🛠 Tech Stack

## Frontend
- Flutter (Dart)
- Provider / Bloc
- Material Design

## Backend & Services
- Firebase Authentication
- Firebase Firestore (Realtime Database)
- Supabase (Storage + Database utilities)

## Packages Used
- firebase_core
- firebase_auth
- cloud_firestore
- supabase_flutter
- provider
- uuid
- cached_network_image
- flutter_native_splash
- photo_view

---

# 🧱 Project Architecture

```bash
lib/
│
├── cubit/ or provider/
├── models/
├── services/
├── screens/
│   ├── auth/
│   ├── chat/
│   ├── groups/
│   ├── profile/
│   └── home/
│
├── widgets/
├── helper/
└── main.dart
```

---

# 🚀 Getting Started

## Prerequisites
- Flutter SDK installed  
- Firebase project setup  
- Supabase project setup  
- Android Studio / VS Code  

---

## Installation

### 1️⃣ Clone the repository

```bash
git clone https://github.com/your-username/yalla_talk_app.git
```

### 2️⃣ Navigate to project

```bash
cd yalla_talk_app
```

### 3️⃣ Install dependencies

```bash
flutter pub get
```

### 4️⃣ Run the app

```bash
flutter run
```

---

# 💡 What I Learned

This project helped me understand:

- Real-time database systems (Firestore)
- Authentication flows
- Scalable Flutter architecture
- State management in large apps
- Backend integration (Firebase + Supabase)
- Building production-level chat apps

---

# 🔮 Future Improvements

- 🔔 Push Notifications
- 🎤 Voice & Video Calls
- 🧠 AI chat assistant
- ☁️ Full cloud sync optimization
- 📊 Admin dashboard for chats
- 🔒 End-to-end encryption

---

# 👨‍💻 Developer

## Kyrillos Ayman

Flutter Developer passionate about building real-time scalable mobile applications.

---

# ⭐ Support

If you like this project, don't forget to give it a ⭐ on GitHub!
