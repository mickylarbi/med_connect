import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_services.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/models/doctor_appointment.dart';
import 'package:med_connect/screens/home/appointment/choose_doctor_screen.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/screens/shared/outline_icon_button.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final DoctorAppointment appointment;
  const AppointmentDetailsScreen({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  ValueNotifier<String?> doctorIdNotifier = ValueNotifier<String?>(null);
  ValueNotifier<DateTime> dateTimeNotifier = ValueNotifier<DateTime>(DateTime.now());

  ValueNotifier<String?> servicesGroupValue = ValueNotifier<String?>(null);

  ValueNotifier<List<String>> symptomsNotifier =
      ValueNotifier<List<String>>([]);
  TextEditingController symptomsController = TextEditingController();

  ValueNotifier<List<String>> conditionsNotifier =
      ValueNotifier<List<String>>([]);
  TextEditingController conditionsController = TextEditingController();

  FirestoreServices db = FirestoreServices();
  AuthService auth = AuthService();

  DoctorAppointment newAppointment = DoctorAppointment();

  @override
  void initState() {
    super.initState();

    if (widget.appointment.id != null) {
      doctorIdNotifier.value = widget.appointment.doctorId;
      dateTimeNotifier.value = widget.appointment.dateTime!;
      servicesGroupValue.value = widget.appointment.service;
      //TODO: add location
      symptomsNotifier.value = widget.appointment.symptoms!;
      conditionsNotifier.value = widget.appointment.conditions!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (widget.appointment == newAppointment) return true;

        // showConfirmationDialog(
        //   context,
        //   message: 'Save changes to appointment?',
        //   confirmFunction: () async {
        //     await db.updateAppointment(context, newAppointment);
        //   },
        // );

        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                ValueListenableBuilder<String?>(
                    valueListenable: doctorIdNotifier,
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 88),
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(36, 20, 36, 36),
                            child: value == null
                                ? Material(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.blueGrey.withOpacity(.1),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(14),
                                      onTap: () async {
                                        String? result = await navigate(
                                            context,
                                            const ChooseDoctorScreen(
                                              isFromAppointment: true,
                                            ));

                                        if (result != null) {
                                          doctorIdNotifier.value = result;
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 14),
                                        child: Text('Choose doctor'),
                                      ),
                                    ),
                                  )
                                : FutureBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                    future: db.doctor(value),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Couldn\'t get doctor info');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Doctor doctor = Doctor.fromFireStore(
                                            snapshot.data!.data()!,
                                            snapshot.data!.id);

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ValueListenableBuilder<DateTime?>(
                                                valueListenable:
                                                    dateTimeNotifier,
                                                builder: (context, doctorValue,
                                                    child) {
                                                  return Material(
                                                    color: Colors.blueGrey
                                                        .withOpacity(.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    textStyle: const TextStyle(
                                                        color: Colors.blueGrey),
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      onTap: () {
                                                        showCustomBottomSheet(
                                                          context,
                                                          [
                                                            ListTile(
                                                              leading: const Icon(
                                                                  Icons
                                                                      .calendar_today_rounded),
                                                              title: const Text(
                                                                  'Change date'),
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                DateTime? result = await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        doctorValue ??
                                                                            DateTime
                                                                                .now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                            1950),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2100));

                                                                if (result !=
                                                                    null) {
                                                                  dateTimeNotifier
                                                                          .value =
                                                                      result;
                                                                }
                                                              },
                                                            ),
                                                            const Divider(
                                                                height: 10),
                                                            ListTile(
                                                              leading: const Icon(
                                                                  Icons
                                                                      .timer_outlined),
                                                              title: const Text(
                                                                  'Change time'),
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                TimeOfDay? result = await showTimePicker(
                                                                    context:
                                                                        context,
                                                                    initialTime:
                                                                        TimeOfDay.fromDateTime(doctorValue ??
                                                                            DateTime.now()));

                                                                if (result !=
                                                                    null) {
                                                                  DateTime
                                                                      temp =
                                                                      doctorValue ??
                                                                          DateTime
                                                                              .now();
                                                                  dateTimeNotifier.value = DateTime(
                                                                      temp.year,
                                                                      temp
                                                                          .month,
                                                                      temp.day,
                                                                      result
                                                                          .hour,
                                                                      result
                                                                          .minute);
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 24,
                                                                vertical: 16),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              DateFormat
                                                                      .yMMMMEEEEd()
                                                                  .format(dateTimeNotifier
                                                                          .value),
                                                            ),
                                                            Text(
                                                              DateFormat.jm().format(
                                                                  dateTimeNotifier
                                                                      .value),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                            const Divider(height: 50),
                                            InkWell(
                                              onTap: () async {
                                                String? result = await navigate(
                                                    context,
                                                    const ChooseDoctorScreen(
                                                      isFromAppointment: true,
                                                    ));

                                                if (result != null) {
                                                  doctorIdNotifier.value =
                                                      result;
                                                }
                                              },
                                              child: DoctorCard(
                                                doctor: Doctor.fromFireStore(
                                                    snapshot.data!.data()!,
                                                    snapshot.data!.id),
                                                padding:
                                                    const EdgeInsets.all(0),
                                              ),
                                            ),
                                            const Divider(height: 50),
                                            const Text(
                                                'What services would you want to patronize?'),
                                            const SizedBox(height: 10),
                                            ValueListenableBuilder<String?>(
                                              valueListenable:
                                                  servicesGroupValue,
                                              builder: (BuildContext context,
                                                  String? serviceValue,
                                                  Widget? child) {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      doctor.services!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return RadioListTile<
                                                        String?>(
                                                      value: serviceValue,
                                                      groupValue:
                                                          servicesGroupValue
                                                              .value,
                                                      onChanged: (radioValue) {
                                                        servicesGroupValue
                                                                .value =
                                                            serviceValue;
                                                      },
                                                      title: Text(doctor
                                                          .services![index]),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            const Divider(height: 50),
                                            const Text(
                                                'Where would you want to meet?'),
                                            const SizedBox(height: 10),
                                            Container(
                                                color:
                                                    Colors.pink.withOpacity(.1),
                                                padding:
                                                    const EdgeInsets.all(36),
                                                child: const Text(
                                                    'some implementation of google maps will go on here')),
                                            const Divider(height: 50),
                                            const Text(
                                                'What symptoms are you experiencing?'),
                                            const SizedBox(height: 10),
                                            ValueListenableBuilder(
                                              valueListenable: symptomsNotifier,
                                              builder: (BuildContext context,
                                                  List<String> value,
                                                  Widget? child) {
                                                return ListView.separated(
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: value.length,
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return const SizedBox(
                                                        height: 10);
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Material(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 36,
                                                                vertical: 14),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(value[index]),
                                                            InkWell(
                                                              onTap: () {
                                                                List<String>
                                                                    temp =
                                                                    value;
                                                                temp.removeAt(
                                                                    index);
                                                                symptomsNotifier
                                                                    .value = [
                                                                  ...temp
                                                                ];
                                                              },
                                                              child: const Icon(
                                                                  Icons.clear),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            CustomTextFormField(
                                              hintText: 'Add symptom',
                                              controller: symptomsController,
                                              onFieldSubmitted: (value) {
                                                if (!symptomsNotifier.value
                                                        .contains(
                                                            symptomsController
                                                                .text
                                                                .trim()) &&
                                                    symptomsController.text
                                                        .trim()
                                                        .isNotEmpty) {
                                                  List<String> temp =
                                                      symptomsNotifier.value;
                                                  temp.add(symptomsController
                                                      .text
                                                      .trim());
                                                  symptomsNotifier.value = [
                                                    ...temp
                                                  ];
                                                  symptomsController.clear();
                                                } else {
                                                  showAlertDialog(context,
                                                      message: symptomsController
                                                              .text
                                                              .trim()
                                                              .isEmpty
                                                          ? 'Textfield is empty'
                                                          : 'Symptom has already been added');
                                                }
                                              },
                                            ),
                                            const Divider(height: 50),
                                            const Text(
                                                'What underlying conditions do you have?'),
                                            const SizedBox(height: 10),
                                            ValueListenableBuilder(
                                              valueListenable:
                                                  conditionsNotifier,
                                              builder: (BuildContext context,
                                                  List<String> value,
                                                  Widget? child) {
                                                return ListView.separated(
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: value.length,
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return const SizedBox(
                                                        height: 10);
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Material(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 36,
                                                                vertical: 14),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(value[index]),
                                                            InkWell(
                                                              onTap: () {
                                                                List<String>
                                                                    temp =
                                                                    value;
                                                                temp.removeAt(
                                                                    index);
                                                                conditionsNotifier
                                                                    .value = [
                                                                  ...temp
                                                                ];
                                                              },
                                                              child: const Icon(
                                                                  Icons.clear),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            CustomTextFormField(
                                              hintText: 'Add condition',
                                              controller: conditionsController,
                                              onFieldSubmitted: (value) {
                                                if (!conditionsNotifier.value
                                                        .contains(
                                                            conditionsController
                                                                .text
                                                                .trim()) &&
                                                    conditionsController.text
                                                        .trim()
                                                        .isNotEmpty) {
                                                  List<String> temp =
                                                      conditionsNotifier.value;
                                                  temp.add(conditionsController
                                                      .text
                                                      .trim());
                                                  conditionsNotifier.value = [
                                                    ...temp
                                                  ];
                                                  conditionsController.clear();
                                                } else {
                                                  showAlertDialog(context,
                                                      message: conditionsController
                                                              .text
                                                              .trim()
                                                              .isEmpty
                                                          ? 'Textfield is empty'
                                                          : 'Symptom has already been added');
                                                }
                                              },
                                            )
                                          ],
                                        );
                                      }

                                      return const Center(
                                          child: CircularProgressIndicator
                                              .adaptive());
                                    },
                                  ),
                          ),
                        ),
                      );
                    }),
                CustomAppBar(
                  title: '',
                  actions: [
                    OutlineIconButton(
                      iconData: Icons.more_horiz,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    dateTimeNotifier.dispose();

    doctorIdNotifier.dispose();

    servicesGroupValue.dispose();

    symptomsNotifier.dispose();
    symptomsController.dispose();

    conditionsNotifier.dispose();
    conditionsController.dispose();

    super.dispose();
  }
}




//CONTACT
  // Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
                              //     Material(
                              //       color: Colors.blueGrey.withOpacity(.1),
                              //       borderRadius: BorderRadius.circular(20),
                              //       child: InkWell(
                              //         onTap: () {
                              //           db.addAppointment(
                              //               context,
                              //               DoctorAppointment(
                              //                   conditions: [
                              //                     'Multiple sclerosis'
                              //                   ],
                              //                   dateTime: DateTime.now(),
                              //                   doctorId:
                              //                       '6Y6tq6WafEgPEldbrcehbxEm4203',
                              //                   location: 'Tech Hospital',
                              //                   patientId: auth.uid,
                              //                   service: 'Consult',
                              //                   symptoms: [
                              //                     'Headache',
                              //                     'Nausea'
                              //                   ]));
                              //         },
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 24, vertical: 14),
                              //           child: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             children: const [
                              //               Icon(Icons.call),
                              //               SizedBox(width: 5),
                              //               Text('Call'),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     const SizedBox(width: 10),
                              //     Material(
                              //       color: Colors.blueGrey.withOpacity(.1),
                              //       borderRadius: BorderRadius.circular(20),
                              //       child: Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 24, vertical: 14),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: const [
                              //             Icon(Icons.chat_bubble),
                              //             SizedBox(width: 5),
                              //             Text('Message'),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),