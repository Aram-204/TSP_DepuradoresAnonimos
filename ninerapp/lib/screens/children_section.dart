import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ninerapp/models/child.dart';
import 'package:ninerapp/screens/form_child.dart';
import 'package:ninerapp/util/app_colors.dart';
import 'package:ninerapp/util/app_textstyles.dart';

class ChildrenSection extends StatefulWidget {
  const ChildrenSection({super.key});

  @override
  State<ChildrenSection> createState() => _ChildrenSectionState();
}

class _ChildrenSectionState extends State<ChildrenSection> {
  // Añadir un init para llamar luego a load children
  final List<String> _orderList = [
    'Ordenar por nombre (A-Z)',
    'Ordenar por nombre (Z-A)',
    'Ordenar por edad (menor-mayor)',
    'Ordenar por edad (mayor-menor)'
  ];
  String _orderBy = 'Ordenar por nombre (A-Z)';

  List<Child> childrenList = [
    Child(id: '1', name: 'Emmanuel Juan', lastName: 'Ortiz Juarez', birthdate: DateTime(2020, 1, 1), isFemale: false),
    Child(id: '2', name: 'Emmanuel Juan2', lastName: 'Ortiz Juarez2', birthdate: DateTime(2023, 1, 1), isFemale: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hijo(s)', style: AppTextstyles.appBarText),
        centerTitle: false,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 10),
            changeOrderContainer(),
            SizedBox(height: 10),
            if (childrenList.isEmpty) ...[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No tienes hijos registrados...", style: AppTextstyles.appBarText),
                  ],
                ),
              ),
            ] else ... [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // hacer tarjetas y añadir boton de añadir hijo
                      ...childrenList.map((child) => Text(child.name)),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 10),
            addChildButton(),
            SizedBox(height: 20),
          ],
        ),
      )
    );
  }

  ElevatedButton addChildButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const FormChildScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.seeBabysittersColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Añadir Hijo(a)', style: AppTextstyles.buttonText),
            SizedBox(width: 15),
            Icon(FontAwesomeIcons.plus, size: 16, color: AppColors.fontColor),
          ]
        ),
      )
    );
  }

  Row changeOrderContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: AppColors.settingsColor, borderRadius: BorderRadius.circular(10)),
          child: DropdownButton<String>(
            value: _orderBy,
            hint: const Text('Orden'),
            items: _orderList.map((orderOption) {
              return DropdownMenuItem(
                value: orderOption,
                child: Text(orderOption),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _orderBy = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }
}