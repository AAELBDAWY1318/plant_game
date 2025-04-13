import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_game/core/utils/size_config.dart';
import 'package:plant_game/core/dj/service_locator.dart';
import 'package:plant_game/features/home/presentation/cubit/cubit.dart';
import 'package:plant_game/features/home/presentation/cubit/state.dart';
import 'package:plant_game/features/my_plants/presentation/widgets/plant_card.dart';

import '../../../home/presentation/widgets/custom_typing_indicator.dart';
import '../widgets/custom_empty_plants.dart';
class MyPlantsView extends StatelessWidget {
  const MyPlantsView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Plants",
          style: TextStyle(
            color: Colors.brown,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            shadows: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10.0,
                offset: Offset(0, 10),
              )
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/plant.png",
            ),
            opacity: 0.2,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent,
              Colors.white,
            ],
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
                  return const CustomEmptyPlants();
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
