import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/models/experience.dart';
import 'package:med_connect/models/review.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/doctor_details_screen.dart';
import 'package:med_connect/screens/home/homepage/home_page.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/functions.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({Key? key}) : super(key: key);

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: Column(
            children: [
              const SizedBox(height: 138),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: const DoctorsListView(),
                ),
              ),
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
  const DoctorsListView({Key? key}) : super(key: key);

  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  final FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
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
                height: 50,
              ),
              itemCount: snapshot.data!.docs.length,
            );
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }
}
