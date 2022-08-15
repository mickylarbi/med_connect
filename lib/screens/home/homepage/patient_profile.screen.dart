import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_services.dart';
import 'package:med_connect/models/allergy.dart';
import 'package:med_connect/models/family_medical_history_entry.dart';
import 'package:med_connect/models/immunization.dart';
import 'package:med_connect/models/medical_history_entry.dart';
import 'package:med_connect/models/patient.dart';
import 'package:med_connect/models/surgery.dart';
import 'package:med_connect/screens/home/homepage/edit_allergy_screen.dart';
import 'package:med_connect/screens/home/homepage/edit_family_medical_history.dart';
import 'package:med_connect/screens/home/homepage/edit_immunization_screen.dart';
import 'package:med_connect/screens/home/homepage/edit_medical_history_screen.dart';
import 'package:med_connect/screens/home/homepage/edit_surgery_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';

class PatientProfileScreen extends StatefulWidget {
  final Patient patient;
  const PatientProfileScreen({Key? key, required this.patient})
      : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  AuthService auth = AuthService();
  FirestoreServices db = FirestoreServices();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  ValueNotifier<DateTime?> dateOfBirthNotifier = ValueNotifier<DateTime?>(null);
  ValueNotifier<String?> genderNotifier = ValueNotifier<String?>(null);
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  ValueNotifier<String?> bloodTypeNotifier = ValueNotifier<String?>(null);
  ValueNotifier<List<MedicalHistoryEntry>> medicalHistoryNotifier =
      ValueNotifier<List<MedicalHistoryEntry>>([]);
  ValueNotifier<List<Immunization>> immunizationsNotifier =
      ValueNotifier<List<Immunization>>([]);
  ValueNotifier<List<Allergy>> allergiesNotifier =
      ValueNotifier<List<Allergy>>([]);
  ValueNotifier<List<FamilyMedicalHistoryEntry>> familyMedicalHistoryNotifier =
      ValueNotifier<List<FamilyMedicalHistoryEntry>>([]);
  ValueNotifier<List<Map>> lifestyleNotifier = ValueNotifier<List<Map>>([]);
  ValueNotifier<List<Surgery>> surgeriesNotifier =
      ValueNotifier<List<Surgery>>([]);

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.patient.firstName!;
    surnameController.text = widget.patient.surname!;
    phoneController.text = widget.patient.phone!;
    dateOfBirthNotifier.value = widget.patient.dateOfBirth;
    genderNotifier.value = widget.patient.gender;
    bloodTypeNotifier.value = widget.patient.bloodType;
    heightController.text = widget.patient.height.toString();
    weightController.text = widget.patient.weight!.toString();

    medicalHistoryNotifier.value = widget.patient.medicalHistory ?? [];
    immunizationsNotifier.value = widget.patient.immunizations ?? [];
    allergiesNotifier.value = widget.patient.allergies ?? [];
    familyMedicalHistoryNotifier.value =
        widget.patient.familyMedicalHistory ?? [];
    surgeriesNotifier.value = widget.patient.surgeries ?? [];
  }

  @override
  Widget build(BuildContext context) {
    //TODO:
    Patient newPatient = Patient(
      firstName: firstNameController.text.trim(),
      surname: surnameController.text.trim(),
      phone: phoneController.text.trim(),
      dateOfBirth: dateOfBirthNotifier.value,
      gender: genderNotifier.value,
      height: double.parse(heightController.text.trim()),
      weight: double.parse(weightController.text.trim()),
      bloodType: bloodTypeNotifier.value,
      medicalHistory: medicalHistoryNotifier.value,
      immunizations: immunizationsNotifier.value,
      allergies: allergiesNotifier.value,
      familyMedicalHistory: familyMedicalHistoryNotifier.value,
      surgeries: surgeriesNotifier.value,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/usman-yousaf-pTrhfmj2jDA-unsplash.jpg',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Material(
                              color: Colors.black.withOpacity(.3),
                              child: InkWell(
                                onTap: () {
                                  //TODO: bottom sheet things
                                },
                                child: const Center(
                                  child: Icon(
                                    Icons.photo_camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  ),
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
                          hintText: 'Weidht (kg)',
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
                  ValueListenableBuilder<List<MedicalHistoryEntry>>(
                    valueListenable: medicalHistoryNotifier,
                    builder: (BuildContext context,
                        List<MedicalHistoryEntry> value, Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.length,
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
                                        medicalHistoryEntry: value[index]));

                                if (result != null) {
                                  List<MedicalHistoryEntry> temp = value;

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
                            context, const EditMedicalHistoryScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<MedicalHistoryEntry> temp =
                              medicalHistoryNotifier.value;
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
                  ValueListenableBuilder<List<Immunization>>(
                    valueListenable: immunizationsNotifier,
                    builder: (BuildContext context, List<Immunization> value,
                        Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.length,
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
                                        immunization: value[index]));

                                if (result != null) {
                                  List<Immunization> temp = value;

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
                            context, const EditMedicalHistoryScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<Immunization> temp = immunizationsNotifier.value;
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
                  ValueListenableBuilder<List<Allergy>>(
                    valueListenable: allergiesNotifier,
                    builder: (BuildContext context, List<Allergy> value,
                        Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.length,
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
                                    EditAllergyScreen(allergy: value[index]));

                                if (result != null) {
                                  List<Allergy> temp = value;

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
                        EditObject? result =
                            await navigate(context, const EditAllergyScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<Allergy> temp = allergiesNotifier.value;
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
                  ValueListenableBuilder<List<FamilyMedicalHistoryEntry>>(
                    valueListenable: familyMedicalHistoryNotifier,
                    builder: (BuildContext context,
                        List<FamilyMedicalHistoryEntry> value, Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.length,
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
                                  List<FamilyMedicalHistoryEntry> temp = value;

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
                          List<FamilyMedicalHistoryEntry> temp =
                              familyMedicalHistoryNotifier.value;
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
                  ValueListenableBuilder<List<Surgery>>(
                    valueListenable: surgeriesNotifier,
                    builder: (BuildContext context, List<Surgery> value,
                        Widget? child) {
                      return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.length,
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
                                    EditSurgeryScreen(surgery: value[index]));

                                if (result != null) {
                                  List<Surgery> temp = value;

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
                        EditObject? result =
                            await navigate(context, const EditSurgeryScreen());

                        if (result != null &&
                            result.action == EditAction.edit) {
                          List<Surgery> temp = surgeriesNotifier.value;
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
                      if (firstNameController.text.trim().isNotEmpty &&
                          surnameController.text.trim().isNotEmpty &&
                          phoneController.text.trim().isNotEmpty &&
                          widget.patient != newPatient) {
                        showConfirmationDialog(context,message: 'Save changes to profile?', confirmFunction: () {
                          db.updatePatient(context, newPatient);
                        });
                      }
                    },
                  )
                ],
              ),
              CustomAppBar(
                title: 'My Profile',
                onPressedLeading: () {
                  // if()
                },
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
    lifestyleNotifier.dispose();
    surgeriesNotifier.dispose();

    super.dispose();
  }
}
