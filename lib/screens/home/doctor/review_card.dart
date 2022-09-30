import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/patient/patient.dart';
import 'package:med_connect/models/review.dart';
import 'package:med_connect/screens/home/tab_view.dart';
import 'package:med_connect/screens/shared/header_text.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileImageWidget(height: 40, width: 40),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: db.patientDocument.get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {}
                      if (snapshot.connectionState == ConnectionState.done) {
                        Patient patient = Patient.fromFirestore(
                            snapshot.data!.data()!, snapshot.data!.id);

                        return HeaderText(text: patient.name);
                      }

                      return const SizedBox();
                    }),
                Text(
                  DateFormat.yMd().add_jm().format(review.dateTime!),
                  style: const TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.star, color: Colors.yellow),
            HeaderText(text: review.rating!.toStringAsFixed(1)),
          ],
        ),
        const SizedBox(height: 10),
        Text(review.comment!),
      ],
    );
  }
}
