import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/firestore_services.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/doctor_details_screen.dart';
import 'package:med_connect/screens/home/doctor/doctors_list_page.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/functions.dart';

class ChooseDoctorScreen extends StatefulWidget {
  final bool isFromAppointment;
  const ChooseDoctorScreen({Key? key, this.isFromAppointment = false})
      : super(key: key);

  @override
  State<ChooseDoctorScreen> createState() => _ChooseDoctorScreenState();
}

class _ChooseDoctorScreenState extends State<ChooseDoctorScreen> {
  FirestoreServices db = FirestoreServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 88),
            child: DoctorsListView(isFromAppointment: true),
          ),
          CustomAppBar(
            title: 'Choose doctor',
            actions: [
              OutlineIconButton(
                  iconData: Icons.filter_list_alt, onPressed: () {})
            ],
          ),
        ],
      )),
    );
  }
}
