import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/firestore_services.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/models/experience.dart';
import 'package:med_connect/models/review.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/doctor_details_screen.dart';
import 'package:med_connect/screens/home/homepage/homepage.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/functions.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({Key? key}) : super(key: key);

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final ScrollController _scrollController = ScrollController();

  Doctor doctor = Doctor(
      bio:
          'This is the bioThis is the bioThis is the bioThis is the bioThis is the bio\nThis is the bioThis is the bioThis is the bio\nThis is the bioThis is the bio\nThis is the bioThis is the bioThis is the bioThis is the bioThis is the bio',
      currentLocation: Experience(
          location: 'Cape Coast Teaching Hospital',
          dateTimeRange:
              DateTimeRange(start: DateTime.now(), end: DateTime.now())),
      experiences: [
        Experience(
            location: 'UCC Hospital',
            dateTimeRange:
                DateTimeRange(start: DateTime.now(), end: DateTime.now())),
      ],
      mainSpecialty: 'Oncology',
      firstName: 'Michael',
      surname: 'Larbi',
      reviews: List.generate(
          5,
          (index) => Review(
                rating: Random().nextDouble() * 5,
                dateTime: DateTime.now(),
                userId: 'humberto-chavez-FVh_yqLR9eA-unsplash.jpg',
                comment: 'Great doctor!\nPatient and attentive',
              )),
      otherSpecialties: [
        '',
        '',
      ],
      services: [
        '',
        '',
        '',
        '',
        '',
      ]);

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {//TODO: come back to this
    //   if (_scrollController.offset < 25 && _scrollController.offset > 0) {
    //     _scrollController.animateTo(0,
    //         duration: const Duration(seconds: 1), curve: Curves.easeOutQuint);
    //   } else if (_scrollController.offset >= 25 &&
    //       _scrollController.offset < 50) {
    //     _scrollController.animateTo(50,
    //         duration: const Duration(seconds: 1), curve: Curves.easeOutQuint);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 138),
              DoctorsListView(),
            ],
          ),
        ),
        ...fancyAppBar(
          context,
          _scrollController,
          'Doctors',
          [
            OutlineIconButton(
              iconData: Icons.filter_alt,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class DoctorsListView extends StatefulWidget {
  final bool isFromAppointment;
  const DoctorsListView({Key? key, this.isFromAppointment = false})
      : super(key: key);

  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  final FirestoreServices db = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                      isFromAppointment: widget.isFromAppointment,
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
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }
}
