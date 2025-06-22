# Firebase Setup Guide

This guide will help you set up Firebase for the JMP app after cloning the repository.

## Prerequisites

1. A Google account
2. Flutter SDK installed
3. FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)

## Setup Steps

### 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter a project name (e.g., "jmp-app-yourname")
4. Enable Google Analytics if desired
5. Choose or create a Google Analytics account
6. Click "Create project"

### 2. Configure Firebase for Flutter

1. Open a terminal in the project root directory
2. Run the FlutterFire configuration command:
   ```bash
   flutterfire configure
   ```
3. Select your Firebase project from the list
4. Select the platforms you want to support (Android, iOS, Web, etc.)
5. The CLI will automatically generate the configuration files

### 3. Manual Configuration (Alternative)

If you prefer to configure manually or encounter issues with the CLI:

#### For Android:
1. In Firebase Console, go to Project Settings > General
2. Click "Add app" and select Android
3. Enter the package name: `com.jmp`
4. Download the `google-services.json` file
5. Place it in `jmp/android/app/google-services.json`

#### For iOS:
1. In Firebase Console, click "Add app" and select iOS
2. Enter the bundle ID: `com.jmp`
3. Download the `GoogleService-Info.plist` file
4. Add it to your iOS project in Xcode

#### For Web:
1. In Firebase Console, click "Add app" and select Web
2. Enter an app nickname
3. Copy the configuration object

### 4. Update Configuration Files

If configuring manually, update the template files:

1. Copy `jmp/lib/firebase_options.dart.template` to `jmp/lib/firebase_options.dart`
2. Copy `jmp/android/app/google-services.json.template` to `jmp/android/app/google-services.json`
3. Replace all placeholder values with your actual Firebase configuration

### 5. Enable Firebase Services

In the Firebase Console, enable the following services:

1. **Authentication**:
   - Go to Authentication > Sign-in method
   - Enable Email/Password authentication

2. **Firestore Database**:
   - Go to Firestore Database
   - Create database in production mode
   - Set up security rules as needed

3. **Storage** (if using file uploads):
   - Go to Storage
   - Get started with default rules

### 6. Install Dependencies

Run the following commands in the `jmp` directory:

```bash
flutter pub get
```

### 7. Test the Setup

1. Run the app: `flutter run`
2. Try creating an account or logging in
3. Check the Firebase Console to see if users are being created

## Troubleshooting

### Common Issues:

1. **Build errors related to Firebase**:
   - Make sure all configuration files are in the correct locations
   - Run `flutter clean` and `flutter pub get`

2. **Authentication not working**:
   - Check that Email/Password is enabled in Firebase Console
   - Verify the configuration files have the correct project ID

3. **iOS build issues**:
   - Make sure `GoogleService-Info.plist` is added to the iOS project in Xcode
   - Check that the bundle ID matches your Firebase configuration

## Security Notes

- Never commit actual Firebase configuration files to public repositories
- Use Firebase Security Rules to protect your data
- Consider using different Firebase projects for development and production

## Need Help?

If you encounter issues:
1. Check the [FlutterFire documentation](https://firebase.flutter.dev/)
2. Review the [Firebase documentation](https://firebase.google.com/docs)
3. Open an issue in this repository with details about your problem 