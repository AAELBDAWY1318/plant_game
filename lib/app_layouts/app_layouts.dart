import 'package:flutter/material.dart';
import 'package:plant_game/features/guess/presentation/view/guess_view.dart';
import 'package:plant_game/features/home/presentation/view/home.dart';
import 'package:plant_game/features/my_plants/presentation/view/my_plants_view.dart';
import 'package:plant_game/features/tip/presentation/view/tip_view.dart';

import '../core/models/navigatiion_bar_model.dart';

class AppLayouts extends StatefulWidget {
  const AppLayouts({super.key});

  @override
  State<AppLayouts> createState() => _AppLayoutsState();
}

class _AppLayoutsState extends State<AppLayouts> {
  List<SampleListModel> pages = [
    SampleListModel(
      title: "Home",
      launchWidget: const Text("Home View",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      icon: Icons.home,
      colors: Colors.greenAccent,
      screen: const HomeView(),
    ),
    SampleListModel(
      title: "My Plants",
      launchWidget: const Text("My Plants",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      icon: Icons.my_library_books_rounded,
      colors: Colors.greenAccent,
      screen: const MyPlantsView(),
    ),
    SampleListModel(
      title: "Guess",
      launchWidget: const Text("Guess",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      icon: Icons.games,
      colors: Colors.greenAccent,
      screen: const GuessView(),
    ),
    SampleListModel(
      title: "Tip",
      launchWidget: const Text("Tip",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      icon: Icons.tips_and_updates,
      colors: Colors.greenAccent,
      screen: const TipView(),
    ),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex].screen,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            pages.length,
            (i) {
              SampleListModel data = pages[i];

              return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  height: 40,
                  decoration: BoxDecoration(
                      color: i == selectedIndex
                          ? data.colors!.withAlpha(100)
                          : Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0))),
                  child: i == selectedIndex
                      ? Center(
                          child: Text(data.title ?? "",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16)))
                      : GestureDetector(
                          child: Icon(
                            data.icon,
                            size: 30,
                            color: Colors.greenAccent,
                          ),
                          onTap: () {
                            selectedIndex = i;
                            setState(() {});
                          },
                        ));
            },
          ),
        ),
      ),
    );
  }
}
