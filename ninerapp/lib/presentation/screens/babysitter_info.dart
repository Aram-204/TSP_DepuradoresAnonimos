import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ninerapp/core/constants/app_colors.dart';
import 'package:ninerapp/core/constants/app_textstyles.dart';
import 'package:ninerapp/domain/entities/babysitter.dart';

class BabysitterInfoScreen extends StatefulWidget {
  final Babysitter babysitter;

  const BabysitterInfoScreen({
    super.key,
    required this.babysitter,
  });

  @override
  State<BabysitterInfoScreen> createState() => _BabysitterInfoScreenState();
}

class _BabysitterInfoScreenState extends State<BabysitterInfoScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de ${widget.babysitter.name}", style: AppTextstyles.appBarText),
        centerTitle: false,
        backgroundColor: AppColors.primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre:", style: AppTextstyles.bodyText),
            Text("${widget.babysitter.name} ${widget.babysitter.lastName}", style: AppTextstyles.childCardText),
            const SizedBox(height: 8),

            if (widget.babysitter.expPhisicalDisability || widget.babysitter.expHearingDisability || widget.babysitter.expVisualDisability || (widget.babysitter.expOtherDisabilities != null && widget.babysitter.expOtherDisabilities!.isNotEmpty)) ...[
              Text("Experiencia en las siguientes discapacidades:", style: AppTextstyles.bodyText),
              if (widget.babysitter.expPhisicalDisability) Text(" - Física", style: AppTextstyles.childCardText),
              if (widget.babysitter.expHearingDisability) Text(" - Auditiva", style: AppTextstyles.childCardText),
              if (widget.babysitter.expVisualDisability) Text(" - Visual", style: AppTextstyles.childCardText),
            ],
            if (widget.babysitter.expOtherDisabilities != null && widget.babysitter.expOtherDisabilities!.isNotEmpty) ...[
              Text("Otra(s):", style: AppTextstyles.childCardText),
              Text(" - ${widget.babysitter.expOtherDisabilities!}", style: AppTextstyles.childCardText),
            ],
            const SizedBox(height: 30),
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
            Text('Cancelar', style: AppTextstyles.buttonText.copyWith(color: AppColors.white)),
            const SizedBox(width: 15),
            const Icon(FontAwesomeIcons.xmark, size: 16, color: AppColors.white),
          ]
        ),
      )
    );
  }

  ElevatedButton requestService() {
    return ElevatedButton(
      onPressed: () async {
        // TODO abrir ventana de solicitud de servicio
        // hacer widget de boton para no repetir codigo
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