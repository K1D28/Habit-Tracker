import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _userName = '';
  String _profileImage = ''; // Store the image URL here

  // Predefined male and female cartoon image URLs
  final String maleAvatar =
      'https://www.w3schools.com/w3images/avatar2.png'; // Replace with actual URL
  final String femaleAvatar =
      'https://www.w3schools.com/w3images/avatar6.png'; // Replace with actual URL

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Load saved profile data
  }

  // Load saved profile name and image URL from SharedPreferences
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _profileImage = prefs.getString('userImage') ?? '';
      _nameController.text = _userName;
    });
  }

  // Save profile data (name and image) to SharedPreferences
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', _nameController.text); // Save the user name
    prefs.setString('userImage', _profileImage); // Save the selected avatar URL

    setState(() {
      _userName = _nameController.text; // Update the UI with the new name
    });
  }

  // Function to update the profile image (male or female avatar)
  void _updateProfileImage(String avatarUrl) {
    setState(() {
      _profileImage = avatarUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar image section (Choose between male/female)
            GestureDetector(
              onTap: () {
                // Show a dialog with options to select the male or female avatar
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Choose an Avatar'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Image.network(
                                maleAvatar,
                                width: 40,
                                height: 40,
                              ),
                              title: const Text('Male Avatar'),
                              onTap: () {
                                _updateProfileImage(maleAvatar);
                                Navigator.pop(context); // Close dialog
                              },
                            ),
                            ListTile(
                              leading: Image.network(
                                femaleAvatar,
                                width: 40,
                                height: 40,
                              ),
                              title: const Text('Female Avatar'),
                              onTap: () {
                                _updateProfileImage(femaleAvatar);
                                Navigator.pop(context); // Close dialog
                              },
                            ),
                          ],
                        ),
                      ),
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImage.isNotEmpty
                        ? NetworkImage(
                          _profileImage,
                        ) // Show selected avatar (network image)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider<
                              Object
                            >, // Default avatar if no selection
                child:
                    _profileImage.isEmpty
                        ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white,
                        )
                        : null, // Show camera icon if no image selected
              ),
            ),
            const SizedBox(height: 16),
            // User Name Text Field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            // Save Button
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
