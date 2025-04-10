import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_game/core/dj/service_locator.dart';
import 'package:plant_game/core/utils/size_config.dart';
import 'package:plant_game/features/home/presentation/widgets/plant_info_screen.dart';

class CustomScannerButton extends StatefulWidget {
  final Function(File)? onImageSelected;

  const CustomScannerButton({super.key, this.onImageSelected});

  @override
  State<CustomScannerButton> createState() => _CustomScannerButtonState();
}

class _CustomScannerButtonState extends State<CustomScannerButton> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && context.mounted) {
        final File imageFile = File(pickedFile.path);
        log("Image picked: ${pickedFile.path}");
        // استدعاء PlantInfoScreen مع تمرير الصورة
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantInfoScreen(imageFile: imageFile),
          ),
        );
      } else {
        log("No image selected");
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    sl<SizeConfig>().init(context);
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        width: sl<SizeConfig>().screenWidth! * 0.6,
        height: sl<SizeConfig>().screenWidth! * 0.6,
        padding: EdgeInsets.symmetric(
          vertical: sl<SizeConfig>().screenHeight! * 0.08,
        ),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.brown,
              blurRadius: 10.0,
              offset: Offset(-10, 0),
            ),
            BoxShadow(
              color: Colors.greenAccent,
              blurRadius: 10.0,
              offset: Offset(10, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Start Scan",
                style: TextStyle(
                  fontSize: sl<SizeConfig>().screenWidth! * 0.065,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Expanded(
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}