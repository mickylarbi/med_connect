import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/models/doctor/appointment.dart';
import 'package:med_connect/models/review.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';

class SandBox extends StatefulWidget {
  const SandBox({Key? key}) : super(key: key);

  @override
  State<SandBox> createState() => _SandBoxState();
}

class _SandBoxState extends State<SandBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Add'),
          onPressed: () async {
            showLoadingDialog(context);
            FirebaseFirestore db = FirebaseFirestore.instance;

            for (int i = 0; i < 50; i++) {
              await db
                  .collection('appointments')
                  .add(Appointment().toMap()); //TODO:
            }
          },
        ),
      ),
    );
  }
}

void uploadDoctors = (BuildContext context, FirebaseFirestore db) async {
  await db
      .collection('doctors')
      .add({
        'name':
            '${firstNames[Random().nextInt(firstNames.length)]} ${lastNames[Random().nextInt(firstNames.length)]}',
        'mainSpecialty': '${specialties[Random().nextInt(specialties.length)]}',
        'otherSpecialties': List.generate(
          Random().nextInt(2),
          (index) => '${specialties[Random().nextInt(specialties.length)]}',
        ),
        // 'experiences': List.generate(
        //   Random().nextInt(5),
        //   (index) => Experience(
        //     generateRandomString(Random().nextInt(15)),
        //     DateTime(2000 + Random().nextInt(2010 - 2000),
        //         1 + Random().nextInt(11), 1 + Random().nextInt(28)),
        //     DateTime(2010 + Random().nextInt(2020 - 2010),
        //         1 + Random().nextInt(11), 1 + Random().nextInt(28)),
        //   ).toMap(),
        // ),
        'reviews': List.generate(
          Random().nextInt(15),
          (index) => Review(
            rating: Random().nextDouble() * 5,
            userId: 'userId',
            comment: generateRandomString(50),
            dateTime: DateTime.now(),
          ).toMap(),
        ),
        'bio': generateRandomString(50),
        'currentLocation': generateRandomString(20),
        'services': List.generate(
          Random().nextInt(5),
          (index) => generateRandomString(10),
        ),
      })
      .timeout(ktimeout)
      .then((value) {
        Navigator.pop(context);
        showAlertDialog(
          context,
          message: 'Upload successful',
          icon: Icons.done_rounded,
          iconColor: Colors.green,
        );
      })
      .catchError((error) {
        Navigator.pop(context);
        showAlertDialog(
          context,
          message: 'Something went wrong\n$error',
        );
      });
};

List firstNames = [
  'Michael',
  'Silas',
  'Eric',
  'Ebenezer',
  'Davis',
  'David',
];

List lastNames = [
  'Larbi',
  'Offei-Darko',
  'Mensah-Nmai',
  'Ayittey',
  'Atsu',
  'Appiah'
];

List specialties = [
  'Allergist',
  'Immunologist',
  'Anesthesiologist',
  'Cardiologist',
  'Colon and Rectal Surgeon',
  'Critical Care Medicine Specialist',
  'Dermatologist',
  'Endocrinologist',
  'Emergency Medicine Specialist',
  'Family Physician',
  'Gastroenterologist',
  'Geriatric Medicine Specialist',
  'Hematologist',
  'Hospice and Palliative Medicine Specialists',
  'Infectious Disease Specialists',
  'Internists',
  'Medical Geneticists',
  'Nephrologists',
  'Neurologists',
  'Obstetricians and Gynecologists',
  'Oncologists',
  'Ophthalmologists',
  'Osteopaths',
  'Otolaryngologists',
  'Pathologists',
  'Pediatricians',
  'Physiatrists',
  'Plastic Surgeons',
  'Podiatrists',
  'Preventive Medicine Specialists',
  'Psychiatrists',
  'Pulmonologists',
  'Radiologists',
  'Rheumatologists',
  'Sleep Medicine Specialists',
  'Sports Medicine Specialists',
  'General Surgeons',
  'Urologists'
];

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
