import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_game/core/utils/size_config.dart';
import 'package:plant_game/core/dj/service_locator.dart';
import 'package:plant_game/features/home/presentation/cubit/cubit.dart';
import 'package:plant_game/features/home/presentation/cubit/state.dart';
import 'package:shimmer/shimmer.dart';

import '../../../home/presentation/widgets/custom_typing_indicator.dart';
class MyPlantsView extends StatelessWidget {
  const MyPlantsView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocProvider(
          create: (context)=>ScanPlantCubit()..getPlants(),
          child: BlocConsumer<ScanPlantCubit, ScanPlatState>(
            listener: (context, state) {
              if (state is PlantOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is PlantError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is PlantLoading) {
                return const Center(
                  child: TypingIndicator(
                    dotSize: 12.0,
                    dotColor: Colors.green,
                  ),
                );
              } else if (state is PlantLoaded) {
                if (state.plants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_florist,
                          size: 80,
                          color: Colors.green.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No plants yet. Add some!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(sl<SizeConfig>().screenWidth! * 0.04),
                  itemCount: state.plants.length,
                  itemBuilder: (context, index) {
                    final plant = state.plants[index];
                    return PlantCard(
                      plant: plant,
                      onDelete: () {
                        _showDeleteConfirmation(context, plant);
                      },
                    );
                  },
                );
              }
              return Center(
                child: Text(
                  'Something went wrong. Try again.',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> plant) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.green.shade50,
          title: Text(
            'Remove ${plant['plant_name']}',
            style: TextStyle(color: Colors.green.shade700),
          ),
          content: const Text('Are you sure you want to delete this plant?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ScanPlantCubit>().deletePlant(
                  where: 'id = ?',
                  whereArgs: [plant['id']],
                );
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

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