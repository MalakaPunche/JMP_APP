import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class ApplicationState extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  ApplicationState() {
    FirebaseAuth.instance.userChanges().listen((user) {
      _loggedIn = user != null;
      notifyListeners();
    });
  }

  Future<void> addPost(String description, Uint8List imageBytes, String imageName) async {
    if (!_loggedIn) throw Exception('Must be logged in');
    
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final imageUrl = await _uploadImage(imageBytes, imageName);

      // Get user's data from freelancers collection
      final userDoc = await FirebaseFirestore.instance
          .collection('freelancers')
          .doc(user.uid)
          .get();
      
      final userData = userDoc.data();
      final userName = userData?['name'] ?? 'Anonymous';
      final profilePicture = userData?['profilePicture'];
      
      print('Adding post with profile picture: $profilePicture'); // Debug print

      // Create post with profilePicture field
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid,
        'username': userName,
        'profilePicture': profilePicture,  // Add this field to posts
        'description': description,
        'mediaUrl': imageUrl,
        'likes': 0,
        'comments': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      notifyListeners();
    } catch (e) {
      print('Error adding post: $e');
      rethrow;
    }
  }

  Future<String> _uploadImage(Uint8List imageBytes, String imageName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Must be logged in to upload an image');

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('post_images/${DateTime.now().toIso8601String()}_$imageName');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public, max-age=31536000',
        customMetadata: {
          'Access-Control-Allow-Origin': '*',
        },
      );
      
      final uploadTask = ref.putData(imageBytes, metadata);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Upload successful. Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<String> uploadProfilePicture(Uint8List imageBytes, String imageName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Must be logged in to upload profile picture');

    try {
      // Create a reference specifically for profile pictures
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');

      // Upload the file
      await storageRef.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Get the download URL
      final downloadUrl = await storageRef.getDownloadURL();
      
      // Update the user's profile picture URL in Firestore
      await FirebaseFirestore.instance
          .collection('freelancers')
          .doc(user.uid)
          .update({
        'profilePicture': downloadUrl,  // Changed back to profilePicture
      });

      print('Profile picture URL updated: $downloadUrl'); // Debug print
      notifyListeners();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      rethrow;
    }
  }
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR-WEB-API-KEY',
    appId: 'YOUR-WEB-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    authDomain: 'YOUR-AUTH-DOMAIN',
    storageBucket: 'YOUR-STORAGE-BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR-ANDROID-API-KEY',
    appId: 'YOUR-ANDROID-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    storageBucket: 'YOUR-STORAGE-BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR-IOS-API-KEY',
    appId: 'YOUR-IOS-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    storageBucket: 'YOUR-STORAGE-BUCKET',
    iosClientId: 'YOUR-IOS-CLIENT-ID',
    iosBundleId: 'YOUR-IOS-BUNDLE-ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR-MACOS-API-KEY',
    appId: 'YOUR-MACOS-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    storageBucket: 'YOUR-STORAGE-BUCKET',
    iosClientId: 'YOUR-MACOS-CLIENT-ID',
    iosBundleId: 'YOUR-MACOS-BUNDLE-ID',
  );
}
