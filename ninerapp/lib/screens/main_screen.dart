import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ninerapp/screens/babysitters_section.dart';
import 'package:ninerapp/screens/children_section.dart';
import 'package:ninerapp/screens/home_section.dart';
import 'package:ninerapp/screens/options_section.dart';
import 'package:ninerapp/util/app_colors.dart';
import 'package:ninerapp/util/app_textstyles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentSection = 'Inicio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          mainContent(),
          footer(),
        ],
      ),
    );
  }

  Expanded mainContent() {
    return Expanded(
      child: switch (currentSection) {
        'Inicio' => HomeSection(),
        'Hijo(s)' => ChildrenSection(),
        'Niñeros' => BabysittersSection(),
        'Opciones' => OptionsSection(),
        _ => HomeSection(),
      },
    );
  }

  Container footer() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.secondary,
      ),
      // Fila donde van icono y nombre
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            footerIcon('Inicio', FontAwesomeIcons.house),
            footerIcon('Hijo(s)', FontAwesomeIcons.baby),
            footerIcon('Niñeros', FontAwesomeIcons.personBreastfeeding),
            footerIcon('Opciones', FontAwesomeIcons.gear),
          ]
        ),
      ),
    );
  }

  InkWell footerIcon(String sectionName, IconData icon) {
    return InkWell(
      onTap: (){
        setState(() {
          currentSection = sectionName;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.only(right: 2), child: Icon(icon, color: currentSection == sectionName ? AppColors.currentSectionColor : AppColors.fontColor, size: 20)),
          Text(sectionName, style: AppTextstyles.footerText.copyWith(color: currentSection == sectionName ? AppColors.currentSectionColor : AppColors.fontColor)),
        ],
      ),
    );
  }
}