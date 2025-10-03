import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ninerapp/core/constants/app_colors.dart';
import 'package:ninerapp/core/constants/app_shadows.dart';
import 'package:ninerapp/core/constants/app_textstyles.dart';
import 'package:ninerapp/dependency_inyection.dart';
import 'package:ninerapp/domain/entities/babysitter.dart';
import 'package:ninerapp/domain/repositories/ibabysitter_repository.dart';
import 'package:ninerapp/domain/repositories/ichild_repository.dart';

class RequestBabysitterScreen extends StatefulWidget {
  final Babysitter babysitter;

  const RequestBabysitterScreen({
    super.key,
    required this.babysitter,
  });

  @override
  State<RequestBabysitterScreen> createState() => _RequestBabysitterScreenState();
}

class _RequestBabysitterScreenState extends State<RequestBabysitterScreen> {
  final IBabysitterRepository _babysitterRepository = getIt<IBabysitterRepository>();
  final IChildRepository _childRepository = getIt<IChildRepository>();
  final TextEditingController _serviceDateController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  String? _selectedPaymentMethod = 'Tarjeta';

  @override
  void dispose() {
    _serviceDateController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitar niñero", style: AppTextstyles.appBarText),
        centerTitle: false,
        backgroundColor: AppColors.primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            babysitterInfo(),
            const SizedBox(height: 8),

            Text("Instrucciones adicionales:", style: AppTextstyles.bodyText),
            const SizedBox(height: 8),
            _buildTextField(_instructionsController, "Instrucciones especiales"),
            const SizedBox(height: 20),

            Row(
              children: [
                Column(
                  children: [
                    Text("Horas:", style: AppTextstyles.bodyText),
                    const SizedBox(height: 8),
                    _buildTextField(_hoursController, "Horas"),
                  ],
                ),
                Column(
                  children: [
                    Text("Minutos:", style: AppTextstyles.bodyText),
                    const SizedBox(height: 8),
                    _buildTextField(_minutesController, "Minutos"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),




            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                backButton(),
                requestService()
              ]
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _serviceDateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Row babysitterInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/img/babysitter.png'), // HACER poner imagen respectiva del niñero real guardada en supabase
        ),
        Expanded(
          child: Column(
            children: [
              Text("${widget.babysitter.name} ${widget.babysitter.lastName}", style: AppTextstyles.childCardText),
              SizedBox(width: 15),
              Text("\$${widget.babysitter.pricePerHour.toStringAsFixed(2)} mxn por hora", style: AppTextstyles.childCardText.copyWith(color: AppColors.green)),
            ],
          ),
        ),
      ],
    );
  }

  ElevatedButton backButton() {
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
            Text('Volver', style: AppTextstyles.buttonText.copyWith(color: AppColors.white)),
            const SizedBox(width: 15),
            const Icon(FontAwesomeIcons.arrowLeft, size: 16, color: AppColors.white),
          ]
        ),
      )
    );
  }

  ElevatedButton requestService() {
    return ElevatedButton(
      onPressed: () async {
        // HACER QUE SE ABRA UN MODAL O VENTANA NUEVA PARA HACER EL PAGO
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.currentSectionColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contratar', style: AppTextstyles.buttonText.copyWith(color: AppColors.white)),
            SizedBox(width: 15),
            Icon(FontAwesomeIcons.personCircleQuestion, size: 16, color: AppColors.white),
          ]
        ),
      )
    );
  }
}