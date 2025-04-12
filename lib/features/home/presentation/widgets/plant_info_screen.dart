import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_game/features/home/presentation/cubit/cubit.dart';
import 'package:plant_game/features/home/presentation/cubit/state.dart';
import 'package:plant_game/features/home/presentation/widgets/custom_error_message.dart';
import 'package:plant_game/features/home/presentation/widgets/custom_typing_indicator.dart';
import 'package:plant_game/features/home/presentation/widgets/image_info.dart';

class PlantInfoScreen extends StatelessWidget {
  final File imageFile;

  const PlantInfoScreen({super.key, required this.imageFile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Plant Info",
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
          create: (context) => ScanPlantCubit()..getPlantInfo(imageFile),
          child: BlocBuilder<ScanPlantCubit, ScanPlatState>(
            builder: (context, state) {
              if (state is ScanImageSuccess) {
                return Center(
                  child: ImageInfoShower(
                    imageFile: imageFile,
                    plantName: state.plantModel.plantName,
                    scientificName: state.plantModel.scientificName,
                  ),
                );
              } else if (state is ScanImageFailure) {
                return Center(
                  child: CustomErrorMessage(errorMessage: state.errorMessage),
                );
              } else {
                return const Center(
                  child: TypingIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
