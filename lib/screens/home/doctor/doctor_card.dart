import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/utils/functions.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final EdgeInsetsGeometry padding;
  final bool showChevronRight;
  DoctorCard({
    Key? key,
    required this.doctor,
    this.padding = const EdgeInsets.symmetric(horizontal: 36),
    this.showChevronRight = true,
  }) : super(key: key);

  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(20),
          //   child: Container(
          //     height: 120,
          //     width: 110,
          //     alignment: Alignment.center,
          //     color: Colors.grey.withOpacity(.1),
          //     child: StatefulBuilder(builder: (context, setState) {
          //       return FutureBuilder<String>(
          //         future: storage.profileImageUrl(doctor.id!),
          //         builder: (context, snapshot) {
          //           if (snapshot.hasError) {
          //             return GestureDetector(
          //               onTap: () async {
          //                 setState(() {});
          //               },
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: const [
          //                   Text(
          //                     'Tap to reload',
          //                     style: TextStyle(color: Colors.grey),
          //                   ),
          //                   Icon(
          //                     Icons.refresh,
          //                     color: Colors.grey,
          //                   )
          //                 ],
          //               ),
          //             );
          //           }
          //           if (snapshot.connectionState == ConnectionState.done) {
          //             return Image.network(
          //               snapshot.data!,
          //               height: 120,
          //               width: 110,
          //               fit: BoxFit.cover,
          //             );
          //             // return const FlutterLogo();
          //           }
          //           return const CircularProgressIndicator.adaptive();
          //         },
          //       );
          //     }),
          //   ),
          // ),
          const SizedBox(width: 30),
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  doctor.mainSpecialty!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text(
                  doctor.currentLocation!.location!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(80, 252, 228, 6),
                    ),
                    Text(calculateRating(doctor.reviews).toStringAsFixed(2)),
                    const SizedBox(width: 10),
                    Text(
                      doctor.reviews == null
                          ? 'No reviews yet'
                          : '(${doctor.reviews!.length} reviews)',
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (showChevronRight) const Spacer(),
          if (showChevronRight)
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.withOpacity(.5),
              size: 40,
            )
        ],
      ),
    );
  }
}

List images = [
  'bruno-rodrigues-279xIHymPYY-unsplash.jpg',
  'humberto-chavez-FVh_yqLR9eA-unsplash.jpg',
  'usman-yousaf-pTrhfmj2jDA-unsplash.jpg',
];
