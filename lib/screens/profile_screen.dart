import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _profileImage = ''; // To store the image URL

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Load profile data from SharedPreferences
  }

  // Load saved profile name and image URL from SharedPreferences
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _profileImage = prefs.getString('userImage') ?? ''; // Load the image URL
    });
  }

  // Function to clear profile data (name and image)
  Future<void> _clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userName');
    prefs.remove('userImage');

    setState(() {
      _userName = 'User'; // Reset name
      _profileImage = ''; // Reset image
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile data cleared!')));
  }

  // Function to update profile image (select new avatar)
  void _updateProfileImage(String newImage) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'userImage',
      newImage,
    ); // Save the selected avatar image URL

    setState(() {
      _profileImage = newImage;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile image updated!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Center the entire content vertically and horizontally
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              // Profile image section
              GestureDetector(
                onTap: () {
                  // Show dialog to change avatar
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text('Choose Avatar'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Image.network(
                                  'https://www.w3schools.com/w3images/avatar2.png',
                                  width: 40,
                                  height: 40,
                                ),
                                title: const Text('Male Avatar'),
                                onTap: () {
                                  _updateProfileImage(
                                    'https://www.w3schools.com/w3images/avatar2.png',
                                  );
                                  Navigator.pop(context); // Close dialog
                                },
                              ),
                              ListTile(
                                leading: Image.network(
                                  'https://www.w3schools.com/w3images/avatar6.png',
                                  width: 40,
                                  height: 40,
                                ),
                                title: const Text('Female Avatar'),
                                onTap: () {
                                  _updateProfileImage(
                                    'https://www.w3schools.com/w3images/avatar6.png',
                                  );
                                  Navigator.pop(context); // Close dialog
                                },
                              ),
                            ],
                          ),
                        ),
                  );
                },
                child: CircleAvatar(
                  radius: 60, // Increased size for better visibility
                  backgroundImage:
                      _profileImage.isNotEmpty
                          ? NetworkImage(_profileImage) // Show selected avatar
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
              const SizedBox(height: 24),
              // Display the user's name
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              // Button to edit the profile name
              ElevatedButton(
                onPressed: () async {
                  // Allow user to change their name
                  final newName = await _showNameChangeDialog(context);
                  if (newName != null && newName.isNotEmpty) {
                    setState(() {
                      _userName = newName;
                    });

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('userName', newName);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile name updated!')),
                    );
                  }
                },
                child: const Text('Edit Name'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded button
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Button to clear profile data
              ElevatedButton(
                onPressed: _clearProfile,
                child: const Text('Clear Profile Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded button
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show a dialog for changing the name
  Future<String?> _showNameChangeDialog(BuildContext context) async {
    TextEditingController _nameController = TextEditingController(
      text: _userName,
    );

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed:
                  () => Navigator.pop(context), // Close dialog without saving
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _nameController.text); // Save new name
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
