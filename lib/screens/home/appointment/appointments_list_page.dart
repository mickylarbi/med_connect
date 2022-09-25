import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/doctor/appointment.dart';
import 'package:med_connect/screens/home/appointment/appointment_card.dart';
import 'package:med_connect/screens/home/appointment/appointment_details_screen.dart';
import 'package:med_connect/screens/home/appointment/appointments_history_screen.dart';
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
  final ScrollController _scrollController = ScrollController();

  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  ValueNotifier<List<Appointment>> appointmentsListNotifier =
      ValueNotifier<List<Appointment>>([]);

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
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: db.myAppointments.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  appointmentsListNotifier.value = [
                    ...snapshot.data!.docs
                        .map(
                          (e) => Appointment.fromFirestore(e.data(), e.id),
                        )
                        .toList()
                  ];

                  appointmentsListNotifier.value.sort((a, b) =>
                      a.dateTime!.millisecondsSinceEpoch.toString().compareTo(
                          b.dateTime!.millisecondsSinceEpoch.toString()));

                  appointmentsListNotifier.value =
                      appointmentsListNotifier.value.reversed.toList();

                  List<Appointment> currentAppointmentsList =
                      appointmentsListNotifier.value
                          .where((element) =>
                              element.status == AppointmentStatus.pending ||
                              element.status == AppointmentStatus.confirmed)
                          .toList();

                  return ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentAppointmentsList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 0,
                        indent: 126,
                        endIndent: 36,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return AppointmentCard(
                          appointment: currentAppointmentsList[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        ...fancyAppBar(
          context,
          _scrollController,
          'Appointments',
          [
            OutlineIconButton(
              iconData: Icons.history,
              onPressed: () {
                navigate(
                  context,
                  AppointmentHistoryScreen(
                    appointmentsList: appointmentsListNotifier.value
                        .where((element) =>
                            element.status == AppointmentStatus.canceled ||
                            element.status == AppointmentStatus.completed)
                        .toList(),
                  ),
                );
              },
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FloatingActionButton(
              onPressed: () {
                navigate(context,
                    AppointmentDetailsScreen(appointment: Appointment()));
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
    appointmentsListNotifier.dispose();
    super.dispose();
  }
}
