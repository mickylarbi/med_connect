import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/appointment.dart';
import 'package:med_connect/screens/shared/header_text.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final EdgeInsetsGeometry padding;
  const AppointmentCard(
      {Key? key,
      required this.appointment,
      this.padding = const EdgeInsets.symmetric(horizontal: 36)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Row(
          children: [
            Container(
              height: 100,
              width: 90,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat.d().format(DateTime.now()),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    DateFormat.MMM().format(DateTime.now()),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(width: 30),
            Container(
              height: 130,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderText(text: 'Consult'),
                  Text('Dr Amanda Arthur'),
                  Text('Home')
                ],
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.withOpacity(.5),
              size: 40,
            )
          ],
        ));
  }
}
