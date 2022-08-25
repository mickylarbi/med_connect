import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/doctor_appointment.dart';
import 'package:med_connect/models/patient.dart';
import 'package:med_connect/screens/home/appointment/appointment_card.dart';
import 'package:med_connect/screens/home/homepage/profile/patient_profile.screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  StorageService storage = StorageService();
  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            controller: scrollController,
            children: [
              const SizedBox(height: 138),
              const Padding(
                padding: EdgeInsets.fromLTRB(36, 36, 36, 24),
                child: Text(
                  'Today\'s appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: StatefulBuilder(builder: (context, setState) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: db.myAppointments.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Something went wrong'),
                                IconButton(
                                    onPressed: () {
                                      setState(
                                        () {},
                                      );
                                    },
                                    icon: const Icon(Icons.refresh))
                              ],
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        List<DoctorAppointment> appointmentsList = snapshot
                            .data!.docs
                            .map((e) =>
                                DoctorAppointment.fromFirestore(e.data(), e.id))
                            .toList()
                            .where((element) =>
                                element.dateTime!.year == DateTime.now().year &&
                                element.dateTime!.month ==
                                    DateTime.now().month &&
                                element.dateTime!.day == DateTime.now().day)
                            .toList();
                        return appointmentsList.isEmpty
                            ? const Center(
                                child:
                                    Text('No appointments scheduled for today'),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 36),
                                itemCount: appointmentsList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(width: 24);
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  DoctorAppointment appointment =
                                      appointmentsList[index];

                                  return DoctorAppointmentTodayCard(
                                      appointment: appointment);
                                },
                              );
                      });
                }),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: db.patientDocument.snapshots(),
          builder: (context, snapshot) {
            return SizedBox(
              height: 138,
              child: Stack(
                children: fancyAppBar(
                  context,
                  scrollController,
                  snapshot.hasError ||
                          snapshot.data == null ||
                          snapshot.data!.data() == null ||
                          snapshot.connectionState == ConnectionState.waiting
                      ? 'Hi'
                      : 'Hi ${snapshot.data!.data()!['firstName']}',
                  [
                    StatefulBuilder(
                      builder: (context, setState) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () async {
                              if (snapshot.data!.data() != null) {
                                await navigate(
                                    context,
                                    PatientProfileScreen(
                                        patient: Patient.fromFirestore(
                                            snapshot.data!.data()!,
                                            snapshot.data!.id)));

                                setState(() {});
                              }
                            },
                            child: FutureBuilder<String>(
                              future: storage.profileImageDownloadUrl(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Icon(Icons.person));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return CachedNetworkImage(
                                    imageUrl: snapshot.data,
                                    height: 44,
                                    width: 44,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator.adaptive(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.person)),
                                  );
                                }

                                return const Center(
                                    child:
                                        CircularProgressIndicator.adaptive());
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose;
    super.dispose();
  }
}
