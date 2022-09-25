import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/doctor/doctor.dart';
import 'package:med_connect/models/doctor/appointment.dart';
import 'package:med_connect/screens/home/appointment/choose_doctor_screen.dart';
import 'package:med_connect/screens/home/appointment/map_screen.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/doctor_details_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;
  AppointmentDetailsScreen({Key? key, required this.appointment})
      : super(key: key);

  String? doctorIdNotifier;

  FirestoreService db = FirestoreService();
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    doctorIdNotifier = appointment.doctorId;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 88),
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(36, 20, 36, 150),
                        child: doctorIdNotifier == null
                            ? Material(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.blueGrey.withOpacity(.1),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () async {
                                    String? result = await navigate(
                                        context, const ChooseDoctorScreen());

                                    if (result != null) {
                                      doctorIdNotifier = result;
                                      setState(() {});
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    child: Text('Choose doctor'),
                                  ),
                                ),
                              )
                            : AppointmentsDetailsWidget(
                                doctorIdNotifier: doctorIdNotifier,
                                appointment: appointment,
                              ),
                      ),
                    ),
                  );
                },
              ),
              CustomAppBar(
                // title: 'Appointment',
                actions: [
                  if (appointment.status != null)
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream:
                            db.appointmentDocument(appointment.id!).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const SizedBox();
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator.adaptive();
                          }

                          Appointment currentAppointment =
                              Appointment.fromFirestore(
                                  snapshot.data!.data()!, snapshot.data!.id);

                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showAlertDialog(context,
                                      message: appointmentStatusMessage(
                                          currentAppointment.status!),
                                      icon: Icons.info_rounded,
                                      iconColor: Colors.blue);
                                },
                                child: CircleAvatar(
                                  backgroundColor: appointmentStatusColor(
                                      currentAppointment.status!),
                                  radius: 14,
                                  child: Icon(
                                    appointmentStatusIconData(
                                        currentAppointment.status!),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (currentAppointment.status ==
                                      AppointmentStatus.pending ||
                                  currentAppointment.status ==
                                      AppointmentStatus.confirmed)
                                const SizedBox(width: 20),
                              if (currentAppointment.status ==
                                      AppointmentStatus.pending ||
                                  currentAppointment.status ==
                                      AppointmentStatus.confirmed)
                                OutlineIconButton(
                                  iconData: Icons.more_horiz,
                                  onPressed: () {
                                    showCustomBottomSheet(
                                      context,
                                      [
                                        ListTile(
                                          leading: const Icon(Icons.delete),
                                          title:
                                              const Text('Cancel appointment'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            showConfirmationDialog(
                                              context,
                                              message:
                                                  'Cancel appointment?\nThis cannot be undone',
                                              confirmFunction: () {
                                                showLoadingDialog(context);
                                                db
                                                    .appointmentDocument(
                                                        appointment.id!)
                                                    .update({
                                                      'status':
                                                          AppointmentStatus
                                                              .canceled.index
                                                    })
                                                    .timeout(ktimeout)
                                                    .then((value) {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    })
                                                    .onError(
                                                        (error, stackTrace) {
                                                      Navigator.pop(context);
                                                      showAlertDialog(context,
                                                          message:
                                                              'Error canceling appointment');
                                                    });
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                            ],
                          );
                        }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentsDetailsWidget extends StatefulWidget {
  final String? doctorIdNotifier;
  final Appointment appointment;

  const AppointmentsDetailsWidget({
    Key? key,
    required this.doctorIdNotifier,
    required this.appointment,
  }) : super(key: key);

  @override
  State<AppointmentsDetailsWidget> createState() =>
      _AppointmentsDetailsWidgetState();
}

class _AppointmentsDetailsWidgetState extends State<AppointmentsDetailsWidget> {
  String? doctorId;

  DateTime? dateTime;

  String? service;

  String? venueString;

  LatLng? venueGeo;

  List<String>? symptoms;
  TextEditingController symptomsController = TextEditingController();

  List<String>? conditions;
  TextEditingController conditionsController = TextEditingController();

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    doctorId = widget.doctorIdNotifier;
    dateTime = widget.appointment.dateTime;
    service = widget.appointment.service;
    venueString = widget.appointment.venueString;
    venueGeo = widget.appointment.venueGeo;
    symptoms = widget.appointment.symptoms;
    conditions = widget.appointment.conditions;

    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: db.doctor(doctorId!),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Couldn\'t get doctor info');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Doctor doctor =
                Doctor.fromFireStore(snapshot.data!.data()!, snapshot.data!.id);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatefulBuilder(builder: (context, setState) {
                  return Center(
                    child: Material(
                      color: Colors.blueGrey.withOpacity(.1),
                      borderRadius: BorderRadius.circular(14),
                      textStyle: const TextStyle(color: Colors.blueGrey),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: dateTime ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100))
                              .then((date) {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        dateTime ?? DateTime.now()))
                                .then((time) {
                              dateTime ??= DateTime.now();
                              if (date != null && time != null) {
                                dateTime = DateTime(date.year, date.month,
                                    date.day, time.hour, time.minute);
                              } else if (time != null) {
                                dateTime = DateTime(
                                    dateTime!.year,
                                    dateTime!.month,
                                    dateTime!.day,
                                    time.hour,
                                    time.minute);
                              } else if (date != null) {
                                dateTime = DateTime(date.year, date.month,
                                    date.day, dateTime!.hour, dateTime!.minute);
                              }
                              setState(() {});
                            }).onError((error, stackTrace) {
                              showAlertDialog(context);
                            });
                          }).onError((error, stackTrace) {
                            showAlertDialog(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          child: dateTime == null
                              ? const Text('Choose date and time')
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat.yMMMMEEEEd().format(dateTime!),
                                    ),
                                    Text(
                                      DateFormat.jm().format(dateTime!),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                }),
                const Divider(height: 50),
                InkWell(
                  onTap: () {
                    navigate(
                        context,
                        DoctorDetailsScreen(
                          doctor: doctor,
                          showButton: false,
                        ));
                  },
                  child: DoctorCard(
                    doctor: Doctor.fromFireStore(
                        snapshot.data!.data()!, snapshot.data!.id),
                    padding: const EdgeInsets.all(0),
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        String? result =
                            await navigate(context, const ChooseDoctorScreen());

                        if (result != null) {
                          doctorId = result;
                          setState(() {});
                        }
                      },
                      child: const Text(
                        'Choose different doctor',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 50),
                const Text('What services would you want to patronize?'),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: doctor.services!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RadioListTile<String?>(
                          value: doctor.services![index],
                          groupValue: service,
                          onChanged: (radioValue) {
                            service = doctor.services![index];
                            setState(() {});
                          },
                          title: Text(doctor.services![index]),
                        );
                      },
                    );
                  },
                ),
                const Divider(height: 50),
                const Text('Where would you want to meet?'),
                const SizedBox(height: 20),
                CustomTextFormField(
                  hintText: 'Venue',
                  initialValue: venueString,
                  onChanged: (value) {
                    venueString = value;
                  },
                ),
                const SizedBox(height: 10),
                StatefulBuilder(builder: (context, setState) {
                  return Center(
                    child: Column(
                      children: [
                        TextButton(
                          child: Text(
                            venueGeo == null ? 'Choose on map' : 'View on map',
                            style: venueGeo == null
                                ? null
                                : const TextStyle(color: Colors.pink),
                          ),
                          style: TextButton.styleFrom(
                              fixedSize: venueGeo == null
                                  ? null
                                  : Size(kScreenWidth(context) - 72, 48),
                              backgroundColor: venueGeo == null
                                  ? null
                                  : Colors.pink.withOpacity(.1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          onPressed: () async {
                            LatLng? result = await navigate(context,
                                MapScreen(initialSelectedPostion: venueGeo));

                            if (result != null) {
                              venueGeo = result;
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        if (venueGeo != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                venueGeo = null;
                                setState(() {});
                              },
                              child: const Text(
                                'Clear geolocation',
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 50),
                const Text('What symptoms are you experiencing?'),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: symptoms == null ? 0 : symptoms!.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Material(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(14),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      symptoms![index],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        List<String> temp = symptoms!;
                                        temp.removeAt(index);
                                        symptoms = [...temp];
                                        setState(() {});
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                hintText: 'Add symptom',
                                controller: symptomsController,
                                onFieldSubmitted: (value) {
                                  onSymptomsFieldSubmitted(setState, context);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                onSymptomsFieldSubmitted(setState, context);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Colors.blueGrey.withOpacity(.2),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const Divider(height: 50),
                const Text('What underlying conditions do you have?'),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              conditions == null ? 0 : conditions!.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Material(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(14),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      conditions![index],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        List<String> temp = conditions!;
                                        temp.removeAt(index);
                                        conditions = [...temp];
                                        setState(() {});
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                hintText: 'Add condition',
                                controller: conditionsController,
                                onFieldSubmitted: (value) {
                                  onConditionsFieldSubmitted(setState, context);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                onConditionsFieldSubmitted(setState, context);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Colors.blueGrey.withOpacity(.2),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
                CustomFlatButton(
                  child: Text(widget.appointment.id == null
                      ? 'Add appointment'
                      : 'Update appointment'),
                  onPressed: () {
                    if (dateTime != null &&
                        venueString != null &&
                        venueGeo != null &&
                        service != null) {
                      showConfirmationDialog(
                        context,
                        message: widget.appointment.id == null
                            ? 'Add appointment'
                            : 'Update appointment?',
                        confirmFunction: () {
                          showLoadingDialog(context);

                          if (widget.appointment.id == null) {
                            db
                                .addAppointment(Appointment(
                                    doctorId: doctorId,
                                    doctorName: doctor.name,
                                    dateTime: dateTime,
                                    service: service,
                                    venueGeo: venueGeo,
                                    venueString: venueString,
                                    symptoms: symptoms,
                                    conditions: conditions))
                                .timeout(ktimeout)
                                .then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              showAlertDialog(context,
                                  message: 'Error adding appointment');
                            });
                          } else {
                            db
                                .updateAppointment(Appointment(
                                    id: widget.appointment.id,
                                    doctorId: doctorId,
                                    doctorName: doctor.name,
                                    dateTime: dateTime,
                                    service: service,
                                    venueGeo: venueGeo,
                                    venueString: venueString,
                                    symptoms: symptoms,
                                    conditions: conditions))
                                .timeout(ktimeout)
                                .then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              showAlertDialog(context,
                                  message:
                                      'Error updating appointment\n${error.toString()}');
                            });
                          }
                        },
                      );
                    } else {
                      if (dateTime == null) {
                        showAlertDialog(context,
                            message: 'Please choose a date and a time');
                      } else if (venueString == null) {
                        showAlertDialog(context,
                            message: 'Please type a venue');
                      } else if (venueGeo == null) {
                        showAlertDialog(context,
                            message: 'Please choose a venue on map');
                      } else if (service == null) {
                        showAlertDialog(context,
                            message: 'Please choose a service');
                      }
                    }
                  },
                )
              ],
            );
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      );
    });
  }

  void onConditionsFieldSubmitted(StateSetter setState, BuildContext context) {
    if (conditionsController.text.trim().isNotEmpty) {
      if (conditions == null) {
        conditions = [conditionsController.text.trim()];
        conditionsController.clear();
        setState(() {});
      } else if (!conditions!.contains(conditionsController.text.trim())) {
        List<String> temp = conditions!;
        temp.add(conditionsController.text.trim());
        conditions = [...temp];
        conditionsController.clear();
        setState(() {});
      } else {
        conditionsController.clear();
        showAlertDialog(context, message: 'Symptom has already been added');
      }
    } else {
      showAlertDialog(context, message: 'Textfield is empty');
    }
  }

  void onSymptomsFieldSubmitted(StateSetter setState, BuildContext context) {
    if (symptomsController.text.trim().isNotEmpty) {
      if (symptoms == null) {
        symptoms = [symptomsController.text.trim()];
        symptomsController.clear();
        setState(() {});
      } else if (!symptoms!.contains(symptomsController.text.trim())) {
        List<String> temp = symptoms!;
        temp.add(symptomsController.text.trim());
        symptoms = [...temp];
        symptomsController.clear();
        setState(() {});
      } else {
        symptomsController.clear();
        showAlertDialog(context, message: 'Symptom has already been added');
      }
    } else {
      showAlertDialog(context, message: 'Textfield is empty');
    }
  }

  @override
  void dispose() {
    symptomsController.dispose();
    conditionsController.dispose();

    super.dispose();
  }
}

Color appointmentStatusColor(AppointmentStatus appointmentStatus) {
  switch (appointmentStatus) {
    case AppointmentStatus.pending:
      return Colors.grey;
    case AppointmentStatus.confirmed:
      return Colors.green;
    case AppointmentStatus.completed:
      return Colors.green;
    case AppointmentStatus.canceled:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData appointmentStatusIconData(AppointmentStatus appointmentStatus) {
  switch (appointmentStatus) {
    case AppointmentStatus.pending:
      return Icons.more_horiz;
    case AppointmentStatus.confirmed:
      return Icons.done;
    case AppointmentStatus.completed:
      return Icons.done_all;
    case AppointmentStatus.canceled:
      return Icons.clear;
    default:
      return Icons.pending;
  }
}

String appointmentStatusMessage(AppointmentStatus appointmentStatus) {
  switch (appointmentStatus) {
    case AppointmentStatus.pending:
      return 'Appointment is pending confirmation';
    case AppointmentStatus.confirmed:
      return 'Appointment has been confirmed';
    case AppointmentStatus.completed:
      return 'Appointment has been completed';
    case AppointmentStatus.canceled:
      return 'Appointment has been canceled';
    default:
      return 'Appointment is pending';
  }
}
