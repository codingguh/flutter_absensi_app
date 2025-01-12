import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi_app/core/core.dart';

class RegisterFaceAttendancePage extends StatefulWidget {
  const RegisterFaceAttendancePage({super.key});

  @override
  State<RegisterFaceAttendancePage> createState() =>
      _RegisterFaceAttendancePageState();
}

class _RegisterFaceAttendancePageState
    extends State<RegisterFaceAttendancePage> {
  List<CameraDescription>? _availableCameras;
  CameraController? _controller;
  CameraLensDirection _currentLensDirection = CameraLensDirection.front;
  late Size size;
  bool register = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _availableCameras = await availableCameras();
      final selectedCamera = _availableCameras!.firstWhere(
        (camera) => camera.lensDirection == _currentLensDirection,
      );
      _controller = CameraController(selectedCamera, ResolutionPreset.high);

      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> _reverseCamera() async {
    if (_availableCameras == null) return;

    setState(() {
      _currentLensDirection = _currentLensDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;
    });

    await _initializeCamera();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final picture = await _controller!.takePicture();
      debugPrint("Picture taken: ${picture.path}");
      if (mounted) {
        setState(() {
          register = true;
        });
      }
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
            ),
            Positioned(
              bottom: 5.0,
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: _reverseCamera,
                          icon: Assets.icons.reverse.svg(width: 40.0),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _takePicture,
                          icon: const Icon(Icons.circle, size: 70),
                          color: AppColors.red,
                        ),
                        const Spacer(),
                        const SpaceWidth(48.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
