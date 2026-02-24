import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart'; //

class TryOnPage extends StatefulWidget {
  const TryOnPage({super.key});

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  CameraController? _controller;
  bool _isCameraInitialized = false;

  // AR State Management
  double _jewelryX = 150.0;
  double _jewelryY = 300.0;
  double _jewelryScale = 1.2;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras.last, ResolutionPreset.high);
        await _controller!.initialize();
        if (mounted) setState(() => _isCameraInitialized = true);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. LIVE CAMERA FEED
          _isCameraInitialized
              ? Positioned.fill(child: CameraPreview(_controller!))
              : const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),

          // 2. THE HYPER-REALISTIC OVERLAY
          Positioned(
            left: _jewelryX,
            top: _jewelryY,
            child: GestureDetector(
              onScaleUpdate: (details) => setState(() => _jewelryScale = details.scale.clamp(0.5, 3.0)),
              onPanUpdate: (details) {
                setState(() {
                  _jewelryX += details.delta.dx;
                  _jewelryY += details.delta.dy;
                });
              },
              child: Transform.scale(
                scale: _jewelryScale,
                child: Hero(
                  tag: 'ar_jewelry_piece',
                  child: Image.asset(
                    'assets/images/login_bg.jpg', // Replace with transparent PNG
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                    duration: 2.seconds,
                    color: Colors.white.withOpacity(0.5),
                    angle: 45,
                  ), // Simulates light catching the stone
                ),
              ),
            ),
          ),

          // 3. MINIMALIST AR CONTROLS
          _buildARUI(),
        ],
      ),
    );
  }

  Widget _buildARUI() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _blurActionBtn(Icons.close_rounded, () => Navigator.pop(context)),
                const Text("VIRTUAL ATELIER",
                    style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 6, fontWeight: FontWeight.bold)),
                _blurActionBtn(Icons.auto_awesome_outlined, () {}),
              ],
            ),
          ),
          const Spacer(),
          _buildBottomActionPanel(),
        ],
      ),
    );
  }

  Widget _buildBottomActionPanel() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: const Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusIcon(Icons.photo_outlined, "GALLERY"),
              _captureBtn(),
              _statusIcon(Icons.share_outlined, "SEND"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _captureBtn() {
    return Container(
      height: 80,
      width: 80,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: luxuryGold.withOpacity(0.3)),
      ),
      child: Container(
        decoration: BoxDecoration(color: luxuryGold, shape: BoxShape.circle),
        child: const Icon(Icons.camera_alt, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _statusIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 2)),
      ],
    );
  }

  Widget _blurActionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}