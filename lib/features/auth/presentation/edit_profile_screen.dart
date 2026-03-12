import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final TextEditingController _nameController = TextEditingController(text: "PRASHANT");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("EDIT LEGACY PROFILE",
            style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 3)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField("FULL NAME", _nameController),
            const SizedBox(height: 30),
            _buildInputField("EMAIL ADDRESS", TextEditingController(text: "prashant@example.com")),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: luxuryGold,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("SAVE CHANGES",
                    style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 2)),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          cursorColor: luxuryGold,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: luxuryGold)),
          ),
        ),
      ],
    );
  }
}