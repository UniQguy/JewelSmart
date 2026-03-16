import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// NOTE: Make sure this path points to where you created the new provider
import '../providers/active_try_on_provider.dart';

/// THE VIRTUAL ATELIER (AR TRY-ON)
/// Dynamically renders transparent PNGs, supporting both Network and Asset images.
class TryOnPage extends ConsumerStatefulWidget {
  const TryOnPage({super.key});

  @override
  ConsumerState<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends ConsumerState<TryOnPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;

  int _cameraIndex = 0;
  bool _isFrontCamera = true;

  // AR State Management
  double _jewelryX = 0.0;
  double _jewelryY = 0.0;
  double _jewelryScale = 1.0;

  double _baseScale = 1.0;
  Offset _startingFocalPoint = Offset.zero;
  Offset _startingPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_jewelryX == 0.0 && _jewelryY == 0.0) {
      final size = MediaQuery.of(context).size;
      _jewelryX = (size.width / 2) - 100;
      _jewelryY = (size.height / 2) - 200;
    }
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _isFrontCamera = _cameras[_cameraIndex].lensDirection == CameraLensDirection.front;
        _startCamera();
      }
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _startCamera() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  void _flipCamera() async {
    if (_cameras.length < 2) return;
    setState(() {
      _isCameraInitialized = false;
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
      _isFrontCamera = _cameras[_cameraIndex].lensDirection == CameraLensDirection.front;
    });
    await _controller?.dispose();
    _startCamera();
  }

  void _showPermissionDeniedDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(side: BorderSide(color: luxuryGold, width: 0.5)),
        title: Text("STUDIO ACCESS REQUIRED", style: TextStyle(color: luxuryGold, fontSize: 12, letterSpacing: 4)),
        content: const Text("Camera access is required to enter the Virtual Atelier.", style: TextStyle(color: Colors.white70, fontSize: 10)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text("ENABLE", style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // READ THE IMAGE URL FROM THE SECURE PROVIDER
    final productImageUrl = ref.watch(activeTryOnImageProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. LIVE CAMERA FEED
          if (_isCameraInitialized && _controller != null)
            Transform.scale(
              scale: _controller!.value.aspectRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1 / _controller!.value.aspectRatio,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: _isFrontCamera ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
            )
          else
            _buildLoadingState(),

          // 2. FULL-SCREEN GESTURE CATCHER & OVERLAY
          // FIXED: Removed HitTestBehavior.opaque so it doesn't block buttons underneath it
          if (_isCameraInitialized)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent, // Allows taps to pass through if not on the image
                onScaleStart: (details) {
                  _baseScale = _jewelryScale;
                  _startingFocalPoint = details.focalPoint;
                  _startingPosition = Offset(_jewelryX, _jewelryY);
                },
                onScaleUpdate: (details) {
                  setState(() {
                    _jewelryScale = (_baseScale * details.scale).clamp(0.4, 3.5);
                    final offsetDelta = details.focalPoint - _startingFocalPoint;
                    _jewelryX = _startingPosition.dx + offsetDelta.dx;
                    _jewelryY = _startingPosition.dy + offsetDelta.dy;
                  });
                },
                child: Stack(
                  children: [
                    Positioned(
                      left: _jewelryX,
                      top: _jewelryY,
                      child: Transform.scale(
                        scale: _jewelryScale,
                        child: Hero(
                          tag: 'ar_jewelry_piece',
                          child: _buildDynamicImage(productImageUrl),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 3. MINIMALIST AR CONTROLS (Now wrapped in SafeAreas and placed at the absolute top of the Stack)
          if (_isCameraInitialized) ...[
            _buildTopActions(),
            _buildBottomControls(),
          ],
        ],
      ),
    );
  }

  Widget _buildTopActions() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _blurActionBtn(Icons.close_rounded, () => Navigator.pop(context)),
              const Text(
                "VIRTUAL ATELIER",
                style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 8, fontWeight: FontWeight.w900, shadows: [Shadow(blurRadius: 10, color: Colors.black)]),
              ),
              _blurActionBtn(Icons.flip_camera_ios_outlined, _flipCamera),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.5, end: 0);
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Instruction Text
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24, width: 0.5),
            ),
            child: const Text(
              "PINCH TO SCALE • DRAG TO POSITION",
              style: TextStyle(color: Colors.white, fontSize: 7, letterSpacing: 3, fontWeight: FontWeight.bold),
            ),
          ).animate().fadeIn(delay: 500.ms),

          // Action Panel
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statusIcon(Icons.photo_library_outlined, "GALLERY", () {}),
                    _captureBtn(),
                    _statusIcon(Icons.ios_share_rounded, "SHARE", () {}),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.5, end: 0),
        ],
      ),
    );
  }

  Widget _buildDynamicImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.5), size: 100);
    }

    final bool isNetworkImage = imageUrl.startsWith('http');

    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        width: 200,
        height: 200,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: 200, height: 200,
            child: Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5)),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 50),
      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 4.seconds, color: Colors.white.withValues(alpha: 0.3), angle: 45);
    } else {
      return Image.asset(
        imageUrl,
        width: 200,
        height: 200,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 50),
      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 4.seconds, color: Colors.white.withValues(alpha: 0.3), angle: 45);
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40, height: 40,
            child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1),
          ),
          const SizedBox(height: 20),
          Text(
            "INITIALIZING STUDIO...",
            style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 5, fontWeight: FontWeight.w600),
          ).animate().fadeIn().shimmer(duration: 2.seconds),
        ],
      ),
    );
  }

  Widget _captureBtn() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: luxuryGold,
              content: const Text("CAPTURING FRAME...", style: TextStyle(color: Colors.black, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
              duration: const Duration(seconds: 1),
            )
        );
      },
      child: Container(
        height: 75,
        width: 75,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: luxuryGold.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: luxuryGold.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)
              ]
          ),
          child: const Center(
            child: Icon(Icons.camera, color: Colors.black, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _statusIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _blurActionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 0.5),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}