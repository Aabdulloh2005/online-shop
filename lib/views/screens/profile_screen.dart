import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import 'package:online_shop_animation/services/user_auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  String username = '';
  String? photoUrl;

  final _authService = UserAuthService();
  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser != null) {
      DocumentSnapshot userProfile =
          await _authService.getUserProfile(_currentUser.uid);
      setState(() {
        username = userProfile['username'];
        photoUrl = userProfile['photoUrl'];
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_currentUser != null) {
      String? updatedPhotoUrl;
      if (image != null) {
        updatedPhotoUrl = await _uploadProfilePicture(image!);
      }
      await _authService.updateUserProfile(
          _currentUser.uid, username, updatedPhotoUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Malumotlar saqlandi"),
        ),
      );
    }
  }

  Future<String> _uploadProfilePicture(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${_currentUser!.uid}.jpg');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? data = await ImagePicker().pickImage(source: source);
    if (data != null) {
      setState(() {
        image = File(data.path);
      });
    }
  }

  void _showEditUsernameDialog() {
    final TextEditingController usernameController =
        TextEditingController(text: username);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Username"),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  username = usernameController.text;
                });
                _updateProfile();
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPress: () => _pickImage(ImageSource.camera),
              onTap: () => _pickImage(ImageSource.gallery),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: image != null
                    ? FileImage(image!)
                    : (photoUrl != null
                            ? NetworkImage(photoUrl!)
                            : const AssetImage("assets/icons/user.png"))
                        as ImageProvider,
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _showEditUsernameDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
