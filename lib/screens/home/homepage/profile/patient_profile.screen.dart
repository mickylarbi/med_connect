import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/patient/allergy.dart';
import 'package:med_connect/models/patient/family_medical_history_entry.dart';
import 'package:med_connect/models/patient/immunization.dart';
import 'package:med_connect/models/patient/medical_history_entry.dart';
import 'package:med_connect/models/patient/patient.dart';
import 'package:med_connect/models/patient/surgery.dart';
import 'package:med_connect/screens/home/homepage/profile/edit_allergy_screen.dart';
import 'package:med_connect/screens/home/homepage/profile/edit_family_medical_history.dart';
import 'package:med_connect/screens/home/homepage/profile/edit_immunization_screen.dart';
import 'package:med_connect/screens/home/homepage/profile/edit_medical_history_screen.dart';
import 'package:med_connect/screens/home/homepage/profile/edit_surgery_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';

class PatientProfileScreen extends StatefulWidget {
  final Patient? patient;
  const PatientProfileScreen({Key? key, this.patient}) : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  ValueNotifier<DateTime?> dateOfBirthNotifier = ValueNotifier<DateTime?>(null);
  ValueNotifier<String?> genderNotifier = ValueNotifier<String?>(null);
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  ValueNotifier<String?> bloodTypeNotifier = ValueNotifier<String?>(null);
  ValueNotifier<List<MedicalHistoryEntry>?> medicalHistoryNotifier =
      ValueNotifier<List<MedicalHistoryEntry>?>([]);
  ValueNotifier<List<Immunization>?> immunizationsNotifier =
      ValueNotifier<List<Immunization>?>([]);
  ValueNotifier<List<Allergy>?> allergiesNotifier =
      ValueNotifier<List<Allergy>?>([]);
  ValueNotifier<List<FamilyMedicalHistoryEntry>?> familyMedicalHistoryNotifier =
      ValueNotifier<List<FamilyMedicalHistoryEntry>?>([]);
  ValueNotifier<List<Surgery>?> surgeriesNotifier =
      ValueNotifier<List<Surgery>?>([]);

  @override
  void initState() {
    super.initState();

    if (widget.patient != null) {
      firstNameController.text = widget.patient!.firstName!;
      surnameController.text = widget.patient!.surname!;
      phoneController.text = widget.patient!.phone!;
      dateOfBirthNotifier.value = widget.patient!.dateOfBirth;
      genderNotifier.value = widget.patient!.gender;
      bloodTypeNotifier.value = widget.patient!.bloodType;

      if (widget.patient!.height != null) {
        heightController.text = widget.patient!.height.toString();
      }

      if (widget.patient!.weight != null) {
        weightController.text = widget.patient!.weight!.toString();
      }

      medicalHistoryNotifier.value = widget.patient!.medicalHistory ?? [];
      immunizationsNotifier.value = widget.patient!.immunizations ?? [];
      allergiesNotifier.value = widget.patient!.allergies ?? [];
      familyMedicalHistoryNotifier.value =
          widget.patient!.familyMedicalHistory ?? [];
      surgeriesNotifier.value = widget.patient!.surgeries ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    Patient newPatient = Patient();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 88),
                children: [
                  const SizedBox(height: 10),
                  const ProfileImage(),
                  const SizedBox(height: 30),
                  const Text(
                    'Personal info',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    hintText: 'First name',
                    controller: firstNameController,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    hintText: 'Last name',
                    textCapitalization: TextCapitalization.words,
                    controller: surnameController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                      hintText: 'Phone',
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      prefix: const Text('+233 ')),
                  const SizedBox(height: 20),
                  ValueListenableBuilder<DateTime?>(
                      valueListenable: dateOfBirthNotifier,
                      builder: (context, value, child) {
                        return Material(
                          color: Colors.blueGrey.withOpacity(.2),
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            onTap: () async {
                              var result = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now());

                              if (result != null) {
                                dateOfBirthNotifier.value = result;
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Date of birth',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  Text(
                                    value == null
                                        ? '-'
                                        : DateFormat.yMMMMd().format(value),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          child: ValueListenableBuilder(
                            valueListenable: genderNotifier,
                            builder: (BuildContext context, String? genderValue,
                                Widget? child) {
                              return DropdownButton<String?>(
                                value: genderValue,
                                items: const [
                                  DropdownMenuItem(
                                      child: Text('Male'), value: 'Male'),
                                  DropdownMenuItem(
                                      child: Text('Female'), value: 'Female'),
                                ],
                                onChanged: (val) {
                                  genderNotifier.value = val;
                                },
                                style: const TextStyle(color: Colors.blueGrey),
                                hint: const Text('Gender'),
                                borderRadius: BorderRadius.circular(20),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          child: ValueListenableBuilder(
                            valueListenable: bloodTypeNotifier,
                            builder: (BuildContext context,
                                String? bloodTypeValue, Widget? child) {
                              return DropdownButton<String?>(
                                value: bloodTypeValue,
                                items: const [
                                  DropdownMenuItem(
                                      child: Text('A+'), value: 'A+'),
                                  DropdownMenuItem(
                                      child: Text('A-'), value: 'A-'),
                                  DropdownMenuItem(
                                      child: Text('B+'), value: 'B+'),
                                  DropdownMenuItem(
                                      child: Text('B-'), value: 'B-'),
                                  DropdownMenuItem(
                                      child: Text('AB+'), value: 'AB+'),
                                  DropdownMenuItem(
                                      child: Text('AB-'), value: 'AB-'),
                                  DropdownMenuItem(
                                      child: Text('O+'), value: 'O+'),
                                  DropdownMenuItem(
                                      child: Text('O-'), value: 'O-'),
                                ],
                                onChanged: (val) {
                                  bloodTypeNotifier.value = val;
                                },
                                style: const TextStyle(color: Colors.blueGrey),
                                hint: const Text('Blood type'),
                                borderRadius: BorderRadius.circular(20),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          hintText: 'Height (cm)',
                          controller: heightController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          hintText: 'Weight (kg)',
                          controller: weightController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 70),
                  const Text(
                    'Medical history',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ValueListenableBuilder<List<MedicalHistoryEntry>?>(
                    valueListenable: medicalHistoryNotifier,
                    builder: (BuildContext context,
                        List<MedicalHistoryEntry>? value, Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value == null ? 0 : value.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                EditObject? result = await navigate(
                                    context,
                                    EditMedicalHistoryScreen(
                                        medicalHistoryEntry: value![index]));

                                if (result != null) {
                                  List<MedicalHistoryEntry>? temp = value;

                                  if (result.action == EditAction.edit) {
                                    temp[index] = result.object;
                                  } else if (result.action ==
                                      EditAction.delete) {
                                    temp.removeAt(index);
                                  }
                                  medicalHistoryNotifier.value = [...temp];
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value![index].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.edit)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        EditObject? result = await navigate(
                            context, const EditMedicalHistoryScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<MedicalHistoryEntry>? temp =
                              medicalHistoryNotifier.value!;
                          temp.add(result.object);
                          medicalHistoryNotifier.value = [...temp];
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 5),
                            Text(
                              'Add entry',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 70),
                  const Text(
                    'Immunizations',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ValueListenableBuilder<List<Immunization>?>(
                    valueListenable: immunizationsNotifier,
                    builder: (BuildContext context, List<Immunization>? value,
                        Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value == null ? 0 : value.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                EditObject? result = await navigate(
                                    context,
                                    EditImmunizationScreen(
                                        immunization: value![index]));

                                if (result != null) {
                                  List<Immunization>? temp = value;

                                  if (result.action == EditAction.edit) {
                                    temp[index] = result.object;
                                  } else if (result.action ==
                                      EditAction.delete) {
                                    temp.removeAt(index);
                                  }
                                  immunizationsNotifier.value = [...temp];
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value![index].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.edit)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        EditObject? result = await navigate(
                            context, const EditImmunizationScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<Immunization>? temp =
                              immunizationsNotifier.value!;
                          temp.add(result.object);
                          immunizationsNotifier.value = [...temp];
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 5),
                            Text(
                              'Add entry',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 70),
                  const Text(
                    'Allergies',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ValueListenableBuilder<List<Allergy>?>(
                    valueListenable: allergiesNotifier,
                    builder: (BuildContext context, List<Allergy>? value,
                        Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value == null ? 0 : value.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                EditObject? result = await navigate(context,
                                    EditAllergyScreen(allergy: value![index]));

                                if (result != null) {
                                  List<Allergy>? temp = value;

                                  if (result.action == EditAction.edit) {
                                    temp[index] = result.object;
                                  } else if (result.action ==
                                      EditAction.delete) {
                                    temp.removeAt(index);
                                  }
                                  allergiesNotifier.value = [...temp];
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value![index].allergy.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.edit)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        EditObject? result =
                            await navigate(context, const EditAllergyScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<Allergy>? temp = allergiesNotifier.value!;
                          temp.add(result.object);
                          allergiesNotifier.value = [...temp];
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 5),
                            Text(
                              'Add entry',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 70),
                  const Text(
                    'Family Medical History',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ValueListenableBuilder<List<FamilyMedicalHistoryEntry>?>(
                    valueListenable: familyMedicalHistoryNotifier,
                    builder: (BuildContext context,
                        List<FamilyMedicalHistoryEntry>? value, Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value!.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                EditObject? result = await navigate(
                                    context,
                                    EditFamilyMedicalHistoryScreen(
                                        entry: value[index]));

                                if (result != null) {
                                  List<FamilyMedicalHistoryEntry>? temp = value;

                                  if (result.action == EditAction.edit) {
                                    temp[index] = result.object;
                                  } else if (result.action ==
                                      EditAction.delete) {
                                    temp.removeAt(index);
                                  }
                                  familyMedicalHistoryNotifier.value = [
                                    ...temp
                                  ];
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value[index].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.edit)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        EditObject? result = await navigate(
                            context, const EditFamilyMedicalHistoryScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<FamilyMedicalHistoryEntry>? temp =
                              familyMedicalHistoryNotifier.value!;
                          temp.add(result.object);
                          familyMedicalHistoryNotifier.value = [...temp];
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 5),
                            Text(
                              'Add entry',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 70),
                  const Text(
                    'Surgeries',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ValueListenableBuilder<List<Surgery>?>(
                    valueListenable: surgeriesNotifier,
                    builder: (BuildContext context, List<Surgery>? value,
                        Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value == null ? 0 : value.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                EditObject? result = await navigate(context,
                                    EditSurgeryScreen(surgery: value![index]));

                                if (result != null) {
                                  List<Surgery>? temp = value;

                                  if (result.action == EditAction.edit) {
                                    temp[index] = result.object;
                                  } else if (result.action ==
                                      EditAction.delete) {
                                    temp.removeAt(index);
                                  }
                                  surgeriesNotifier.value = [...temp];
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value![index].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.edit)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        EditObject? result =
                            await navigate(context, const EditSurgeryScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<Surgery>? temp = surgeriesNotifier.value!;
                          temp.add(result.object);
                          surgeriesNotifier.value = [...temp];
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 5),
                            Text(
                              'Add entry',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 70),
                  CustomFlatButton(
                    child: const Text('Save changes'),
                    onPressed: () {
                      newPatient = Patient(
                        firstName: firstNameController.text.trim(),
                        surname: surnameController.text.trim(),
                        phone: phoneController.text.trim(),
                        dateOfBirth: dateOfBirthNotifier.value,
                        gender: genderNotifier.value,
                        height: double.tryParse(heightController.text.trim()),
                        weight: double.tryParse(weightController.text.trim()),
                        bloodType: bloodTypeNotifier.value,
                        medicalHistory: medicalHistoryNotifier.value,
                        immunizations: immunizationsNotifier.value,
                        allergies: allergiesNotifier.value,
                        familyMedicalHistory:
                            familyMedicalHistoryNotifier.value,
                        surgeries: surgeriesNotifier.value,
                      );
                      if ((firstNameController.text.trim().isNotEmpty &&
                              surnameController.text.trim().isNotEmpty &&
                              phoneController.text.trim().isNotEmpty &&
                              phoneController.text.trim().length == 9) ||
                          widget.patient != newPatient) {
                        showConfirmationDialog(context,
                            message: 'Save changes to profile?',
                            confirmFunction: () {
                          showLoadingDialog(context);
                          db.updatePatient(newPatient).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            showAlertDialog(context,
                                message: 'Error updating info');
                          });
                        });
                      }
                    },
                  )
                ],
              ),
              CustomAppBar(
                title: 'My Profile',
                actions: [
                  OutlineIconButton(
                    iconData: Icons.logout_rounded,
                    onPressed: () {
                      showConfirmationDialog(
                        context,
                        message: 'Sign out?',
                        confirmFunction: () {
                          auth.signOut(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    dateOfBirthNotifier.dispose();
    genderNotifier.dispose();
    heightController.dispose();
    weightController.dispose();
    bloodTypeNotifier.dispose();
    medicalHistoryNotifier.dispose();
    immunizationsNotifier.dispose();
    allergiesNotifier.dispose();
    familyMedicalHistoryNotifier.dispose();
    surgeriesNotifier.dispose();

    super.dispose();
  }
}

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  AuthService auth = AuthService();

  StorageService storage = StorageService();

  ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FutureBuilder<String>(
        future: storage.profileImageDownloadUrl(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator.adaptive(
                                value: downloadProgress.progress)),
                    errorWidget: (context, _, __) {
                      return const Center(
                        child: Icon(Icons.person),
                      );
                    },
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              if (snapshot.connectionState == ConnectionState.done)
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Material(
                    color: Colors.black.withOpacity(.3),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        if (snapshot.data != null) {
                          final ImagePicker picker = ImagePicker();

                          showCustomBottomSheet(context, [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Take a photo'),
                              onTap: () async {
                                picker
                                    .pickImage(source: ImageSource.camera)
                                    .then((value) {
                                  Navigator.pop(context);
                                  if (value != null) {
                                    showLoadingDialog(context);
                                    storage
                                        .uploadProfileImage(value)
                                        .timeout(const Duration(minutes: 2))
                                        .then((value) {
                                      Navigator.pop(context);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Profile image changed!')));
                                    }).onError((error, stackTrace) {
                                      Navigator.pop(context);
                                      log(error.toString());
                                      showAlertDialog(context,
                                          message: 'Couldn\'t upload image');
                                    });
                                  }
                                }).onError((error, stackTrace) {
                                  showAlertDialog(context);
                                });
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text('Choose from gallery'),
                              onTap: () async {
                                picker
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) {
                                  Navigator.pop(context);
                                  if (value != null) {
                                    showLoadingDialog(context);
                                    storage
                                        .uploadProfileImage(value)
                                        .timeout(const Duration(minutes: 5))
                                        .then((value) {
                                      Navigator.pop(context);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Profile image changed!')));
                                    }).onError((error, stackTrace) {
                                      Navigator.pop(context);
                                      log(error.toString());
                                      showAlertDialog(context,
                                          message: 'Couldn\'t upload image');
                                    });
                                  }
                                }).onError((error, stackTrace) {
                                  showAlertDialog(context);
                                });
                              },
                            ),
                          ]);
                        } else {
                          setState(() {});
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null)
                const Center(
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                ),

              ///

              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    pictureNotifier.dispose();
    super.dispose();
  }
}
