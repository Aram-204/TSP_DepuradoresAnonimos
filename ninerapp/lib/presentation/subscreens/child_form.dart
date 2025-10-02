import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ninerapp/core/constants/app_colors.dart';
import 'package:ninerapp/core/constants/app_shadows.dart';
import 'package:ninerapp/core/constants/app_textstyles.dart';
import 'package:ninerapp/dependency_inyection.dart';
import 'package:ninerapp/domain/entities/child.dart';
import 'package:ninerapp/domain/repositories/ichild_repository.dart';

class ChildFormScreen extends StatefulWidget {
  final VoidCallback onSave;

  const ChildFormScreen({
    super.key,
    required this.onSave,
  });

  @override
  State<ChildFormScreen> createState() => _ChildFormScreenState();
}

class _ChildFormScreenState extends State<ChildFormScreen> {
  // HACER luego poner para que se pueda usar para editar y obtener datos de parametros
  final IChildRepository _childRepository = getIt<IChildRepository>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _otherDisabilityController = TextEditingController();

  String? _selectedGender = 'Mujer';
  bool _disabilityFisica = false;
  bool _disabilityAuditiva = false;
  bool _disabilityVisual = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _birthdateController.dispose();
    _otherDisabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Hijo(a)', style: AppTextstyles.appBarText),
        centerTitle: false,
        backgroundColor: AppColors.primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre(s):", style: AppTextstyles.bodyText),
            const SizedBox(height: 8),
            _buildTextField(_nameController, "Ingresar nombre(s)"),
            const SizedBox(height: 20),

            Text("Apellido(s):", style: AppTextstyles.bodyText),
            const SizedBox(height: 8),
            _buildTextField(_lastNameController, "Ingresar apellido(s)"),
            const SizedBox(height: 20),

            Text("Fecha de nacimiento:", style: AppTextstyles.bodyText),
            const SizedBox(height: 8),
            GestureDetector( // Con esto se puede hacer que se abra un cuadro para la fecha
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField(_birthdateController, "Ingresar fecha de nacimiento"),
              ),
            ),
            const SizedBox(height: 20),

            Text("Sexo:", style: AppTextstyles.bodyText),
            Row(
              children: [
                Expanded(
                  child: RadioGroup<String>(
                    groupValue: _selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Radio<String>(value: 'Mujer'),
                            Text('Mujer', style: AppTextstyles.bodyText),
                          ],
                        ),
                        Row(
                        children: [
                            Radio<String>(value: 'Hombre'),
                            Text('Hombre', style: AppTextstyles.bodyText),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text("Discapacidades:", style: AppTextstyles.bodyText),
            _buildCheckboxListTile('Física', _disabilityFisica, (bool? value) {
              setState(() {
                _disabilityFisica = value!;
              });
            }),
            _buildCheckboxListTile('Auditiva', _disabilityAuditiva, (bool? value) {
              setState(() {
                _disabilityAuditiva = value!;
              });
            }),
            _buildCheckboxListTile('Visual', _disabilityVisual, (bool? value) {
              setState(() {
                _disabilityVisual = value!;
              });
            }),
            const SizedBox(height: 10),

            Text("Otra(s):", style: AppTextstyles.bodyText),
            const SizedBox(height: 8),
            _buildTextField(_otherDisabilityController, "Ingresar otra(s) discapacidad(es)"),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                cancelButton(),
                saveChildButton()
              ]
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  ElevatedButton cancelButton() {
    return ElevatedButton(
      onPressed: () {
        if (!mounted) return;
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Cancelar', style: AppTextstyles.buttonText.copyWith(color: AppColors.white)),
            const SizedBox(width: 15),
            const Icon(FontAwesomeIcons.xmark, size: 16, color: AppColors.white),
          ]
        ),
      )
    );
  }

  ElevatedButton saveChildButton() {
    return ElevatedButton(
      onPressed: () async {
        final String newName = _nameController.text.trim();
        final String newLastName = _lastNameController.text.trim();
        final DateTime newBirthdate = DateFormat('dd-MM-yyyy').parse(_birthdateController.text.trim());
        final bool newIsFemale = _selectedGender == 'Mujer';
        final bool newDisabilityFisica = _disabilityFisica;
        final bool newDisabilityAuditiva = _disabilityAuditiva;
        final bool newDisabilityVisual = _disabilityVisual;
        final String? newOtherDisability = _otherDisabilityController.text.trim().isEmpty ? null : _otherDisabilityController.text.trim();

        await _childRepository.addChild(
          Child(
            name: newName,
            lastName: newLastName,
            birthdate: newBirthdate,
            isFemale: newIsFemale,
            disabilityFisica: newDisabilityFisica,
            disabilityAuditiva: newDisabilityAuditiva,
            disabilityVisual: newDisabilityVisual,
            otherDisabilities: newOtherDisability,
          )
        );

        if (!mounted) return;
        widget.onSave();
        Navigator.of(context).pop();
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
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Guardar', style: AppTextstyles.buttonText),
            SizedBox(width: 15),
            Icon(FontAwesomeIcons.plus, size: 16, color: AppColors.fontColor),
          ]
        ),
      )
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [AppShadows.inputShadow],
      ),
      child: TextField(
        controller: controller,
        style: AppTextstyles.bodyText,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintText: hintText,
          hintStyle: AppTextstyles.bodyText.copyWith(color: AppColors.grey),
        ),
      ),
    );
  }

  Widget _buildCheckboxListTile(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.currentSectionColor,
        ),
        Text(title, style: AppTextstyles.bodyText),
      ],
    );
  }
}