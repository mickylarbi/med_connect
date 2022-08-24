import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/doctor_appointment.dart';
import 'package:med_connect/screens/home/appointment/appointment_card.dart';
import 'package:med_connect/screens/home/appointment/appointment_details_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/functions.dart';

class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  ScrollController _scrollController = ScrollController();

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
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              const SizedBox(height: 138),
              FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: db.appointmentsList,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something went wrong'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<DoctorAppointment> appointmentsList = snapshot
                          .data!.docs
                          .map(
                            (e) =>
                                DoctorAppointment.fromFirestore(e.data(), e.id),
                          )
                          .toList();
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appointmentsList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 0,
                            indent: 126,
                            endIndent: 36,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return AppointmentCard(
                              appointment: appointmentsList[index]);
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }),
            ],
          ),
        ),
        ...fancyAppBar(
          context,
          _scrollController,
          'Appointments',
          [
            OutlineIconButton(
              iconData: Icons.filter_alt,
              onPressed: () {},
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FloatingActionButton(
              onPressed: () {
                navigate(context,
                    AppointmentDetailsScreen(appointment: DoctorAppointment()));
              },
              child: const Icon(Icons.add),
            ),
          ),
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
