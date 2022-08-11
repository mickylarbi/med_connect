import 'package:flutter/material.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';

class EditAppointmentScreen extends StatefulWidget {
  const EditAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Stack(children: [CustomAppBar()])),
    );
  }
}
