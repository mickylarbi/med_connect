import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/firestore_services.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/doctor_details_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/outline_icon_button.dart';
import 'package:med_connect/utils/functions.dart';

class ChooseDoctorScreen extends StatefulWidget {
  const ChooseDoctorScreen({Key? key}) : super(key: key);

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
          Padding(
            padding: const EdgeInsets.only(top: 88),
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: db.doctorsList,
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
                    return ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          navigate(
                            context,
                            DoctorDetailsScreen(
                              doctor: Doctor.fromFireStore(
                                  snapshot.data!.docs[index].data(),
                                  snapshot.data!.docs[index].id),
                            ),
                          );
                        },
                        child: DoctorCard(
                            doctor: Doctor.fromFireStore(
                                snapshot.data!.docs[index].data(),
                                snapshot.data!.docs[index].id)),
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        indent: 176,
                        endIndent: 36,
                        height: 0,
                      ),
                      itemCount: snapshot.data!.docs.length,
                    );
                  }
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }),
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
