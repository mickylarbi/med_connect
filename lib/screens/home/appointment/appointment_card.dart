import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/doctor/appointment.dart';
import 'package:med_connect/screens/home/appointment/appointment_details_screen.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/utils/functions.dart';

class AppointmentTodayCard extends StatelessWidget {
  AppointmentTodayCard({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(
          context,
          AppointmentDetailsScreen(
            appointment: appointment,
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
        width: 200,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(.1),
                    child: StatefulBuilder(builder: (context, setState) {
                      return FutureBuilder<String>(
                        future: storage
                            .profileImageDownloadUrl(appointment.doctorId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return GestureDetector(
                              onTap: () async {
                                setState(() {});
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Tap to reload',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Icon(
                                    Icons.refresh,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator.adaptive(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.person)),
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        },
                      );
                    }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blueGrey.withOpacity(.15)),
                  child: Text(
                    DateFormat.jm().format(appointment.dateTime!),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              appointment.doctorName!,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appointment.service!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: appointmentStatusColor(appointment.status!),
                  radius: 10,
                  child: Icon(
                    appointmentStatusIconData(appointment.status!),
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    return InkWell(
      onTap: () {
        navigate(context, AppointmentDetailsScreen(appointment: appointment));
      },
      child: Padding(
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
                      DateFormat.d().format(appointment.dateTime!),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormat.MMM().format(appointment.dateTime!),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  height: 130,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(text: appointment.service!),
                      Text(
                        appointment.doctorName!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateFormat.jm().format(appointment.dateTime!),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              CircleAvatar(
                backgroundColor: appointmentStatusColor(appointment.status!),
                radius: 10,
                child: Icon(
                  appointmentStatusIconData(appointment.status!),
                  size: 10,
                  color: Colors.white,
                ),
              )
            ],
          )),
    );
  }
}
