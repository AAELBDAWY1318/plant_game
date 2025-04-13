import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlantCard extends StatefulWidget {
  final Map<String, dynamic> plant;
  final VoidCallback onDelete;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onDelete,
  });

  @override
  _PlantCardState createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.plant['image_file']?.toString() ?? '';

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.green.shade200, width: 1),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: imagePath.isNotEmpty
                      ? Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                  )
                      : _buildImagePlaceholder(),
                ),
              ),
              const SizedBox(width: 12),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plant['plant_name'] as String,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    if (widget.plant['scientific_name'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          widget.plant['scientific_name'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Delete Button
              IconButton(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.rotationZ(0.1)..rotateZ(-0.1),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
                onPressed: widget.onDelete,
                tooltip: 'Delete Plant',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.green.shade100,
      highlightColor: Colors.green.shade50,
      child: Center(
        child: Icon(
          Icons.local_florist,
          size: 40,
          color: Colors.green.shade400,
        ),
      ),
    );
  }
}