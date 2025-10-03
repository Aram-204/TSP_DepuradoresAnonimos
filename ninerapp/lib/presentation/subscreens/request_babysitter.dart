import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ninerapp/core/constants/app_colors.dart';
import 'package:ninerapp/core/constants/app_shadows.dart';
import 'package:ninerapp/core/constants/app_textstyles.dart';
import 'package:ninerapp/core/util/time_number_format.dart';
import 'package:ninerapp/dependency_inyection.dart';
import 'package:ninerapp/domain/entities/babysitter.dart';
import 'package:ninerapp/domain/entities/child.dart';
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

  List<Child> childrenList = [];

  String _serviceDateText = "";
  String? _selectedPaymentMethod = 'Tarjeta';
  bool _childrenAreLoading = true;
  String? _childrenErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    setState(() {
      _childrenAreLoading = true;
      _childrenErrorMessage = null;
    });

    try {
      final childrenRes = await _childRepository.getChildrenByOrder('Ordenar por edad (menor-mayor)');
      setState(() {
        childrenList = childrenRes;

        _childrenAreLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          if (e.toString().contains("SocketException")) {
            _childrenErrorMessage = 'No hay conexión a internet. Favor de verificar la red o intentar de nuevo más tarde.';
          } else {
            _childrenErrorMessage = 'Error al cargar los hijos: ${e.toString()}';
          }
          _childrenAreLoading = false;
        });
      }
    }
  }

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
            const SizedBox(height: 30),

            Text("Día y hora del servicio:", style: AppTextstyles.bodyText),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField(_serviceDateController, "Ingresar día y hora del servicio"),
              ),
            ),
            const SizedBox(height: 20),

            timeRequestedForms(),
            const SizedBox(height: 20),
            
            Text("Instrucciones adicionales:", style: AppTextstyles.bodyText),
            const SizedBox(height: 8),
            _buildTextField(_instructionsController, "Instrucciones especiales"),
            const SizedBox(height: 20),

            Text("Niños a cuidar:", style: AppTextstyles.bodyText),
            // añadir checkbox con los nombres de los niños
            const SizedBox(height: 8),
            if (_childrenAreLoading) ...[
              Center(child: CircularProgressIndicator(color: AppColors.primary)),
            ] else if (_childrenErrorMessage != null) ...[
              Center(child: Text(_childrenErrorMessage!, style: AppTextstyles.bodyText)),
            ] else if (childrenList.isEmpty) ...[
              Center(child: Text("No tienes hijos registrados...", style: AppTextstyles.bodyText)),
            ] else ...[
              ...childrenList.map((child) {
                return Row(
                  children: [
                    Text(child.name, style: AppTextstyles.bodyText),
                    const SizedBox(width: 15),
                  ],
                );
              }),
            ],
            const SizedBox(height: 20),

            // Aqui hay que cargar los nombres de los niños con un checkbox

            Text("Pago:", style: AppTextstyles.bodyText),
            Row(
              children: [
                Expanded(
                  child: RadioGroup<String>(
                    groupValue: _selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Radio<String>(value: 'Tarjeta'),
                            Expanded(child: Text('Pago con tarjeta ahora', style: AppTextstyles.bodyText)),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(value: 'Efectivo'),
                            Expanded(child: Text('Pago en efectivo al niñero después del servicio', style: AppTextstyles.bodyText, overflow: TextOverflow.ellipsis, maxLines: 2)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text("Seleccionar ubicación donde se cuidará a sus hijos:", style: AppTextstyles.bodyText),
            const SizedBox(height: 8),
            // Aqui hay que cargar el mapa

            if (_serviceDateText.isNotEmpty && _hoursController.text.isNotEmpty && _minutesController.text.isNotEmpty) ...[
              Center(child: Text("Total a pagar: \$${(widget.babysitter.pricePerHour * (int.parse(_hoursController.text) + (int.parse(_minutesController.text)/60))).toStringAsFixed(2)} mxn por ${_hoursController.text} horas con ${_minutesController.text} minutos", style: AppTextstyles.bodyText)),
            ],

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

  Row timeRequestedForms() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Horas:", style: AppTextstyles.bodyText),
              const SizedBox(height: 8),
              _buildTextField(_hoursController, "Horas"),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Minutos:", style: AppTextstyles.bodyText),
              const SizedBox(height: 8),
              _buildTextField(_minutesController, "Minutos"),
            ],
          ),
        ),
      ],
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    // Se muestra el selector de hora si es que el usuario selecciona una fecha
    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );

      // Si el usuario selecciona una hora
      if (pickedTime != null) {
        // Aqui se junta la fecha y la hora en un solo objeto DateTime
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _serviceDateController.text = "${TimeNumberFormat.formatTwoDigits(finalDateTime.day)}-${TimeNumberFormat.getMonthName(finalDateTime.month)}-${finalDateTime.year} ${TimeNumberFormat.formatTwoDigits(finalDateTime.hour)}:${TimeNumberFormat.formatTwoDigits(finalDateTime.minute)}";
          _serviceDateText = "${finalDateTime.day}-${finalDateTime.month}-${finalDateTime.year} ${finalDateTime.hour}:${finalDateTime.minute}";
        });
      }
    }
  }

  Padding babysitterInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/img/babysitter.png'), // HACER poner imagen respectiva del niñero real guardada en supabase
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.babysitter.name} ${widget.babysitter.lastName}", style: AppTextstyles.bodyText, overflow: TextOverflow.ellipsis, maxLines: 2),
                SizedBox(width: 15),
                Text("\$${widget.babysitter.pricePerHour.toStringAsFixed(2)} mxn por hora", style: AppTextstyles.bodyText.copyWith(color: AppColors.green)),
              ],
            ),
          ),
        ],
      ),
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