import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

// Ensure this path matches where you saved your product_model.dart
import '../../auth/domain/product_model.dart';

/// THE ARTISAN UPLOAD TERMINAL
/// Engineered to push new 3D collections to Cloudinary and Firestore atomically.
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'RINGS';
  final List<String> _categories = ['RINGS', 'NECKLACES', 'BRACELETS', 'EARRINGS', 'ESTATE'];

  bool _isLoading = false;
  String? _selectedImagePath;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// CLOUDINARY UPLOAD PIPELINE
  Future<String?> _uploadToCloudinary(String imagePath) async {
    // ⚠️ REPLACE WITH YOUR ACTUAL PRESET NAME FROM CLOUDINARY
    const String cloudName = 'dtmpvbon0';
    const String uploadPreset = 'jewelsmart_preset';

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final jsonMap = jsonDecode(String.fromCharCodes(responseData));
      return jsonMap['secure_url']; // The global CDN link
    } else {
      debugPrint('Cloudinary Error: ${response.statusCode}');
      return null;
    }
  }

  /// MASTER SYNC PROTOCOL
  Future<void> _processUpload() async {
    if (_selectedImagePath == null || _titleController.text.trim().isEmpty || _priceController.text.trim().isEmpty) {
      _showErrorSnackBar("COLLECTION DATA OR ASSET MISSING");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Beam Asset to Cloudinary
      final String? imageUrl = await _uploadToCloudinary(_selectedImagePath!);

      if (imageUrl == null) {
        throw Exception("CDN Transmission Failed");
      }

      // 2. Generate Product Blueprint
      final docRef = FirebaseFirestore.instance.collection('products').doc();
      final newProduct = Product(
        id: docRef.id,
        title: _titleController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        imageUrl: imageUrl,
        stock: 1,
        createdAt: DateTime.now(),
      );

      // 3. Inject to Firestore Vault
      await docRef.set(newProduct.toMap());

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pop(context); // Return to Dashboard on Success
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showErrorSnackBar("SYNC FAILED: CHECK CONNECTION");
      debugPrint("Upload Error: $e");
    }
  }

  /// DEVICE GALLERY ACCESS
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Optimizes the image for faster cloud transit
    );

    if (pickedFile != null) {
      setState(() => _selectedImagePath = pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          _buildAmbientGlow(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildInputTerminal(),
                  const SizedBox(height: 40),
                  _buildPrimaryAction(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          if (_isLoading) _buildGlobalLoader(),
        ],
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      top: -100,
      right: -50,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              luxuryGold.withValues(alpha: 0.1),
              Colors.black.withValues(alpha: 0.0),
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.2, 1.2),
          duration: 6.seconds),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("INVENTORY EXPANSION",
            style: TextStyle(
                color: Colors.white38,
                fontSize: 8,
                letterSpacing: 6,
                fontWeight: FontWeight.bold))
            .animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 10),
        Text("INTRODUCE\nCOLLECTION",
            style: TextStyle(
                color: luxuryGold,
                fontSize: 32,
                height: 1.1,
                letterSpacing: 2,
                fontWeight: FontWeight.w100))
            .animate().fadeIn(duration: 800.ms, delay: 200.ms).slideX(begin: -0.1, end: 0),
      ],
    );
  }

  Widget _buildInputTerminal() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSelector(),
              const SizedBox(height: 40),
              _buildEditorialField("COLLECTION TITLE", Icons.diamond_outlined, _titleController),
              const SizedBox(height: 30),
              _buildEditorialField("VAULT VALUE (USD)", Icons.attach_money_rounded, _priceController, isNumber: true),
              const SizedBox(height: 30),
              _buildCategoryDropdown(),
              const SizedBox(height: 30),
              _buildEditorialField("LORE & DESCRIPTION", Icons.subject_rounded, _descriptionController, maxLines: 3),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildImageSelector() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
          image: _selectedImagePath != null
              ? DecorationImage(
            image: FileImage(File(_selectedImagePath!)),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.3), BlendMode.darken),
          )
              : null,
        ),
        child: _selectedImagePath == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: luxuryGold.withValues(alpha: 0.8), size: 30),
            const SizedBox(height: 15),
            const Text("ACQUIRE HIGH-RES ASSET", style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
          ],
        )
            : Center(
          child: Icon(Icons.check_circle_outline, color: luxuryGold.withValues(alpha: 0.9), size: 40),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CLASSIFICATION",
            style: TextStyle(color: Colors.white38, fontSize: 7, letterSpacing: 5, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              dropdownColor: Colors.grey[900],
              icon: Icon(Icons.arrow_drop_down, color: luxuryGold.withValues(alpha: 0.6)),
              style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w300),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedCategory = newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditorialField(String label, IconData icon, TextEditingController controller, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 7, letterSpacing: 5, fontWeight: FontWeight.w900)),
        TextField(
          controller: controller,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.w300),
          cursorColor: luxuryGold,
          decoration: InputDecoration(
            prefixIcon: maxLines == 1 ? Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(icon, color: luxuryGold.withValues(alpha: 0.6), size: 18),
            ) : null,
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 1)),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryAction() {
    return GestureDetector(
      onTap: _processUpload,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: luxuryGold.withValues(alpha: 0.9),
          border: Border.all(color: luxuryGold, width: 1),
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.2), blurRadius: 30, offset: const Offset(0, 10))
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text("SECURE IN VAULT",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 10)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0.0), Colors.white.withValues(alpha: 0.4), Colors.white.withValues(alpha: 0.0)],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: false))
                  .slideX(begin: -2.0, end: 2.0, duration: 3.seconds, curve: Curves.easeInOutSine),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 0.5),
              ),
              child: Text(message.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalLoader() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          color: Colors.black.withValues(alpha: 0.85),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(color: luxuryGold.withValues(alpha: 0.2), strokeWidth: 1, value: 1.0),
                      CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5),
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat())
                    .scale(duration: 1.5.seconds, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), curve: Curves.easeInOutSine),
                const SizedBox(height: 40),
                const Text("TRANSMITTING TO CLOUD",
                    style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.w900)
                ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 1.seconds),
              ],
            ),
          ),
        ),
      ),
    );
  }
}