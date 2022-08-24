import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/patient.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/dialogs.dart';

class PatientInfoScreen extends StatefulWidget {
  const PatientInfoScreen({Key? key}) : super(key: key);

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 36),
                children: [
                  ValueListenableBuilder<XFile?>(
                      valueListenable: pictureNotifier,
                      builder: (context, value, child) {
                        final ImagePicker picker = ImagePicker();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (value != null)
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    File(value.path),
                                    height: 250,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  showCustomBottomSheet(
                                    context,
                                    [
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Take a photo'),
                                        onTap: () async {
                                          picker
                                              .pickImage(
                                                  source: ImageSource.camera)
                                              .then((value) {
                                            Navigator.pop(context);
                                            if (value != null) {
                                              pictureNotifier.value = value;
                                            }
                                          }).onError((error, stackTrace) {
                                            showAlertDialog(context);
                                          });
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.photo),
                                        title:
                                            const Text('Choose from gallery'),
                                        onTap: () async {
                                          picker
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .then((value) {
                                            Navigator.pop(context);
                                            if (value != null) {
                                              pictureNotifier.value = value;
                                            }
                                          }).onError((error, stackTrace) {
                                            showAlertDialog(context);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  backgroundColor:
                                      Colors.blueGrey.withOpacity(.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(value == null
                                    ? 'Choose photo'
                                    : 'Change photo'),
                              ),
                            ),
                          ],
                        );
                      }),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 30),
                  CustomFlatButton(
                    onPressed: () {
                      if (pictureNotifier.value != null &&
                          firstNameController.text.trim().isNotEmpty &&
                          surnameController.text.trim().isNotEmpty &&
                          phoneController.text.trim().isNotEmpty) {
                        FirestoreService db = FirestoreService();
                        StorageService storage = StorageService();

                        storage
                            .uploadProfileImage(pictureNotifier.value!)
                            .then((p0) {
                          db
                              .addPatient(
                            Patient(
                              firstName: firstNameController.text.trim(),
                              surname: surnameController.text.trim(),
                              phone: phoneController.text.trim(),
                            ),
                          )
                              .then((value) {
                            AuthService auth = AuthService();

                            auth.authFuction(context);
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            showAlertDialog(context,
                                message: 'Error uploading info');
                          });
                        }).onError((error, stackTrace) {
                          Navigator.pop(context);
                          showAlertDialog(context,
                              message: 'Error uploading info');
                        });
                      }
                    },
                    child: const Text('Upload info'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageViewHeaderText extends StatelessWidget {
  final String text;
  const PageViewHeaderText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
