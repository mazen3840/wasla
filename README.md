# AffiliatePro SaaS Mobile App (Full Source Code)

This is the official Flutter source code for the AffiliatePro mobile application.  
You can customize the app with your own domain and license key, and build your own APK to install or publish.

## 🔧 Step-by-Step Setup Instructions

### 1. Edit Your API Domain and License Key
Open the file:
assets/config.json

Update it with your information:
{
  "base_url": "https://yourdomain.com/",
  "license_key": "YOUR-LICENSE-KEY-HERE"
}

⚠️ Make sure:

- `base_url` starts with `https://`
- `base_url` ends with `/`
- Example: `https://affiliate.yoursite.com/`

### 2. Get Flutter Packages
Open a terminal inside the project folder and run:
flutter pub get

### 3. Build the APK
To generate the release APK file:
flutter build apk --release

The built APK will be located here:
build/app/outputs/flutter-apk/app-release.apk
You can install it on your device or upload it to the Google Play Console.

### 🚀 Optional: Debug Run (for testing)
To test the app on an emulator or USB-connected device:
flutter run

## 📁 Project Structure Overview

affiliatepro_app/
├── assets/
│   └── config.json       # Your API URL + license key
├── lib/                  # Main Flutter source code
├── android/              # Android platform files
├── pubspec.yaml          # Flutter config & dependencies
├── README.md             # This file
└── ...                   # Other project files

## 💼 Need Help?
If you'd like us to generate the APK for you or help with publishing on Google Play, contact us — we’ll be happy to assist.