import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
// import 'package:screen_brightness/screen_brightness.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/encryption_service.dart';
import '../../../core/services/online_db_service.dart';

class JournalScannerPage extends StatefulWidget {
  const JournalScannerPage({super.key});

  @override
  State<JournalScannerPage> createState() => _JournalScannerPageState();
}

// Added SingleTickerProviderStateMixin for the laser animation
class _JournalScannerPageState extends State<JournalScannerPage> with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  bool _isTorchOn = false; // Track flashlight state

  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    autoStart: true,
  );

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // _boostBrightness();
    
    // Setup the animating laser line
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Bounces up and down
  }

  @override
  void dispose() {
    // _resetBrightness();
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Future<void> _boostBrightness() async {
  //   try { await ScreenBrightness().setScreenBrightness(0.8); } catch (_) {}
  // }

  // Future<void> _resetBrightness() async {
  //   try { await ScreenBrightness().resetScreenBrightness(); } catch (_) {}
  // }

  void _toggleTorch() {
    HapticFeedback.lightImpact();
    _controller.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  Future<void> _processSharedEntry(String rawData) async {
    if (_isProcessing) return;

    final parts = rawData.split('|');
    if (parts.length != 3) {
      // Not an Anchor QR code
      return; 
    }

    setState(() => _isProcessing = true);
    _controller.stop(); 
    HapticFeedback.heavyImpact();

    final String id = parts[0];
    final String entryId = parts[1];
    final String shareKey = parts[2];

    try {
      final sharedData = await OnlineDbService().getSharedEntry(id, entryId);
      if (sharedData == null) throw "Entry not found or expired.";

      final String plainTitle = EncryptionService().decryptWithCustomKey(sharedData['title'], shareKey);
      final String plainContent = EncryptionService().decryptWithCustomKey(sharedData['entry'], shareKey);
      print("Plain Title: $plainTitle");
      print("Plain Content: $plainContent");
      print("share key: $shareKey");
      print("shared id: $entryId");
      print("id: $id");

      final String finalTitle = EncryptionService().encryptData(plainTitle);
      final String finalContent = EncryptionService().encryptData(plainContent);
      print("final Title: $finalTitle");
      print("final Content: $finalContent");

      await OnlineDbService().createNewEntry(
        title: finalTitle,
        content: finalContent,
        category: "", 
      );

      if (mounted) _showSuccessDialog(plainTitle);
    } catch (e) {
      _showError(e.toString());
      _controller.start(); 
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double scanAreaSize = 260.0; 
    final scanWindow = Rect.fromCenter(
      center: Offset(screenWidth / 2, MediaQuery.of(context).size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. THE CAMERA FEED
          MobileScanner(
            controller: _controller,
            scanWindow: scanWindow,
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              if (barcode.rawValue != null) {
                _processSharedEntry(barcode.rawValue!);
              }
            },
          ),
          
          // 2. THE CUSTOM "HOLE PUNCH" OVERLAY
          CustomPaint(
            painter: ScannerOverlayPainter(scanWindow: scanWindow),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // 3. THE TARGETING BOX & LASER
          Center(
            child: SizedBox(
              width: scanAreaSize,
              height: scanAreaSize,
              child: Stack(
                children: [
                  // Stylized Corners
                  _buildCorner(top: 0, left: 0, angle: 0),
                  _buildCorner(top: 0, right: 0, angle: 90),
                  _buildCorner(bottom: 0, left: 0, angle: 270),
                  _buildCorner(bottom: 0, right: 0, angle: 180),

                  // Animated Laser Line
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Positioned(
                        top: _animationController.value * (scanAreaSize - 4),
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                         
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. INSTRUCTION TEXT
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Icon(Icons.qr_code_scanner, color: Colors.white54, size: 40),
                const SizedBox(height: 15),
                Text(
                  "ALIGN TICKET QR TO SYNC",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    letterSpacing: 3,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Establishing secure handshake...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // 5. TOP APP BAR (Back & Flashlight)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min, // <--- Only takes up needed space at the top
                children: [
                  
                  // A. THE BUTTONS ROW
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        
                        // Flashlight Toggle
                        Container(
                          decoration: BoxDecoration(
                            color: _isTorchOn ? AppTheme.fogWhite : Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isTorchOn ? Icons.flash_on : Icons.flash_off, 
                              color: _isTorchOn ? Colors.black : Colors.white
                            ),
                            onPressed: _toggleTorch,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // B. SPACING
                  const SizedBox(height: 10), 

                  // C. THE LOGO (Centered Automatically by Column)
                  Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    color: AppTheme.fogWhite,
                  ),
                ],
              ),
            ),
          ),

          // 6. LOADING SPINNER
          if (_isProcessing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Color(0xFFCD1C18)),
                    const SizedBox(height: 20),
                    Text("DECRYPTING VAULT...", style: GoogleFonts.antonio(color: Colors.white, letterSpacing: 2)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCorner({double? top, double? bottom, double? left, double? right, required double angle}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Transform.rotate(
        angle: angle * 3.14159 / 180,
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppTheme.fogWhite, width: 3),
              left: BorderSide(color: AppTheme.fogWhite, width: 3),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepTaupe,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 10),
            Text("SYNCHRONIZED", style: GoogleFonts.antonio(color: Colors.white)),
          ],
        ),
        content: Text("'$title' has been safely added to your vault.", style: GoogleFonts.robotoMono(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("DONE", style: GoogleFonts.antonio(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sync Error: $error"), backgroundColor: Colors.red),
    );
  }
}

// --- THE CUSTOM PAINTER FOR THE HOLE PUNCH EFFECT ---
class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;

  ScannerOverlayPainter({required this.scanWindow});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.85); // Very dark overlay

    // We create a path for the whole screen, and a path for the clear window
    final screenPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final windowPath = Path()..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(24)));

    // Subtract the window from the screen to punch a hole
    final overlayPath = Path.combine(PathOperation.difference, screenPath, windowPath);

    canvas.drawPath(overlayPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}