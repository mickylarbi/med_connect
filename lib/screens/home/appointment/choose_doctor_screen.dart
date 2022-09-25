import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/doctor/doctor.dart';
import 'package:med_connect/screens/home/appointment/doctor_search_delegate.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/doctor_details_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/functions.dart';

class ChooseDoctorScreen extends StatefulWidget {
  const ChooseDoctorScreen({Key? key}) : super(key: key);

  @override
  State<ChooseDoctorScreen> createState() => _ChooseDoctorScreenState();
}

class _ChooseDoctorScreenState extends State<ChooseDoctorScreen> {
  FirestoreService db = FirestoreService();
  List<Doctor> doctorsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 88),
            child: doctorsListView(),
          ),
          CustomAppBar(
            title: 'Choose doctor',
            actions: [
              OutlineIconButton(
                iconData: Icons.search,
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: DoctorSearchDelegate(doctorsList));
                },
              )
            ],
          ),
        ],
      )),
    );
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> doctorsListView() {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: db.doctorsCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  const Text('Something went wrong. Tap to reload'),
                  IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            doctorsList = snapshot.data!.docs
                .map((e) => Doctor.fromFireStore(e.data(), e.id))
                .toList();

            doctorsList.sort((a, b) => '${a.firstName!}${a.surname!}'
                .compareTo('${b.firstName!}${b.surname!}'));

            return ListView.separated(
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  navigate(
                    context,
                    DoctorDetailsScreen(
                      doctor: doctorsList[index],
                    ),
                  );
                },
                child: DoctorCard(doctor: doctorsList[index]),
              ),
              separatorBuilder: (context, index) => const Divider(
                indent: 176,
                endIndent: 36,
                height: 50,
              ),
              itemCount: doctorsList.length,
            );
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }
}
