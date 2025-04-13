import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_game/core/utils/size_config.dart';
import 'package:plant_game/features/home/presentation/cubit/cubit.dart';
import 'package:plant_game/features/home/presentation/cubit/state.dart';
import 'package:plant_game/features/home/presentation/widgets/custom_typing_indicator.dart';
import '../../../../core/dj/service_locator.dart';

class CustomSaveButton extends StatelessWidget {
  final String plantName;
  final String scientificName;
  final File?
      imageFile; // Made nullable to handle cases where no image is provided

  const CustomSaveButton({
    super.key,
    required this.plantName,
    required this.scientificName,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanPlantCubit(),
      child: BlocConsumer<ScanPlantCubit, ScanPlatState>(
        listener: (context, state) {
          if (state is PlantError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Saving plant Error")),
            );
          }else if(state is PlantOperationSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Center(child: Text("Saved Successfully"))),
            );
          }
        },
        builder: (context, state) => state is PlantLoading
            ? const TypingIndicator()
            : GestureDetector(
                onTap: () {
                  if (plantName.isNotEmpty) {
                    // Only save if plantName is not empty
                    context.read<ScanPlantCubit>().addPlant(
                          plantName: plantName,
                          scientificName:
                              scientificName.isNotEmpty ? scientificName : null,
                          imageFile: imageFile,
                        );
                  } else {
                    // Optionally show a snackbar or emit an error state
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Plant name is required')),
                    );
                  }
                },
                child: Container(
                  width: sl<SizeConfig>().screenWidth! * 0.5,
                  height: sl<SizeConfig>().screenHeight! * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
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
                  child: const Center(
                    child: Text(
                      "Save Plant",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
