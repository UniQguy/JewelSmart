import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';

/// THE SECURE ADDRESS VAULT
/// Engineered with the "Pincode Hack" for frictionless, zero-cost location mapping.
class SecureAddressScreen extends StatefulWidget {
  const SecureAddressScreen({super.key});

  @override
  State<SecureAddressScreen> createState() => _SecureAddressScreenState();
}

class _SecureAddressScreenState extends State<SecureAddressScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  bool _isFetchingLocation = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _streetController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  // --- THE MAGIC PINCODE ENGINE ---
  Future<void> _fetchLocationDetails(String pincode) async {
    if (pincode.length != 6) return; // Only trigger when 6 digits are typed

    setState(() => _isFetchingLocation = true);
    HapticFeedback.lightImpact();

    try {
      // Free Indian Government Postal API
      final response = await http.get(Uri.parse('https://api.postalpincode.in/pincode/$pincode'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty && data[0]['Status'] == 'Success') {
          final postOfficeData = data[0]['PostOffice'][0];

          setState(() {
            _cityController.text = postOfficeData['District'] ?? '';
            _stateController.text = postOfficeData['State'] ?? '';
          });

          HapticFeedback.mediumImpact(); // Confirm to the user it was found
        } else {
          _showNotification("INVALID PINCODE DETECTED", isError: true);
          setState(() {
            _cityController.clear();
            _stateController.clear();
          });
        }
      }
    } catch (e) {
      debugPrint("API Error: $e");
      _showNotification("NETWORK ERROR. ENTER MANUALLY.", isError: true);
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  void _saveAddress() async {
    if (_streetController.text.isEmpty || _pincodeController.text.isEmpty || _cityController.text.isEmpty) {
      _showNotification("INCOMPLETE ADDRESS PROTOCOL", isError: true);
      return;
    }

    setState(() => _isSaving = true);
    HapticFeedback.heavyImpact();

    // TODO: Here you will save it to Firebase under the user's document
    await Future.delayed(const Duration(seconds: 2)); // Simulating DB save

    if (mounted) {
      setState(() => _isSaving = false);
      _showNotification("SECURE ADDRESS VAULTED", isError: false);
      Navigator.pop(context);
    }
  }

  void _showNotification(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isError ? Colors.redAccent.withValues(alpha: 0.1) : luxuryGold.withValues(alpha: 0.1),
                    border: Border.all(color: isError ? Colors.redAccent.withValues(alpha: 0.5) : luxuryGold.withValues(alpha: 0.5), width: 0.5),
                  ),
                  child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildLiquidAppBar(),
      body: Stack(
        children: [
          _buildAmbientBackground(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("LOGISTICS PROTOCOL", style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 8, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("VAULT ADDRESS", style: TextStyle(color: luxuryGold, fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.w100)),
                      const SizedBox(height: 40),

                      _buildInputField("STREET & RESIDENCE", "e.g., 404 Safal Profitaire, Prahlad Nagar", _streetController, false, 2),
                      const SizedBox(height: 30),

                      // THE PINCODE FIELD (With Live Listener)
                      _buildPincodeField(),

                      const SizedBox(height: 30),

                      // AUTO-FILLED FIELDS
                      Row(
                        children: [
                          Expanded(child: _buildInputField("DISTRICT / CITY", "Auto-filled", _cityController, true, 1)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildInputField("STATE", "Auto-filled", _stateController, true, 1)),
                        ],
                      ),

                      const SizedBox(height: 60),
                      _buildSubmitButton(),
                    ],
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildLiquidAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.maybePop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.5,
            colors: [luxuryGold.withValues(alpha: 0.08), Colors.black],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, bool readOnly, int maxLines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              maxLines: maxLines,
              style: TextStyle(
                  color: readOnly ? luxuryGold : Colors.white,
                  fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w300
              ),
              cursorColor: luxuryGold,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.1), fontSize: 10, letterSpacing: 2),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.02),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 0.5)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 1)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPincodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("POSTAL CODE (PINCODE)", style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
            if (_isFetchingLocation)
              SizedBox(width: 10, height: 10, child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5)),
          ],
        ),
        const SizedBox(height: 15),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextField(
              controller: _pincodeController,
              keyboardType: TextInputType.number,
              maxLength: 6, // Enforce 6 digits
              onChanged: _fetchLocationDetails, // The Magic Trigger
              style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 6, fontWeight: FontWeight.w300),
              cursorColor: luxuryGold,
              decoration: InputDecoration(
                counterText: "", // Hide the 0/6 counter
                hintText: "380006",
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.1), fontSize: 14, letterSpacing: 6),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.02),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 0.5)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 1)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: luxuryGold, width: 0.5),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: luxuryGold.withValues(alpha: 0.05),
        ),
        onPressed: _isSaving ? null : _saveAddress,
        child: _isSaving
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5))
            : const Text("SEAL INTO VAULT", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 6, fontWeight: FontWeight.bold)),
      ),
    );
  }
}