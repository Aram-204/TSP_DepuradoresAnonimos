import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ninerapp/presentation/screens/babysitters_section.dart';
import 'package:ninerapp/presentation/screens/children_section.dart';
import 'package:ninerapp/presentation/screens/requests_section.dart';
import 'package:ninerapp/presentation/screens/home_section.dart';
import 'package:ninerapp/presentation/screens/options_section.dart';
import 'package:ninerapp/core/constants/app_colors.dart';
import 'package:ninerapp/core/constants/app_textstyles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // HACER hay que hacer un callback para enviar a homesection para que al presionar los botones del inicio se vaya tambien a las diferentes secciones de la app
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
        'Solicitudes' => RequestsSection(),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            footerIcon('Inicio', FontAwesomeIcons.solidHouse),
            footerIcon('Hijo(s)', FontAwesomeIcons.baby),
            footerIcon('Niñeros', FontAwesomeIcons.personBreastfeeding),
            footerIcon('Solicitudes', FontAwesomeIcons.personCircleQuestion),
            footerIcon('Opciones', FontAwesomeIcons.gear),
          ]
        ),
      ),
    );
  }

  Expanded footerIcon(String sectionName, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: (){
          setState(() {
            currentSection = sectionName;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: currentSection == sectionName ? AppColors.currentSectionColor : AppColors.fontColor, size: 20),
            Text(sectionName, style: AppTextstyles.footerText.copyWith(color: currentSection == sectionName ? AppColors.currentSectionColor : AppColors.fontColor)),
          ],
        ),
      ),
    );
  }
}