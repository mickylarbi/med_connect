import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/models/doctor_appointment.dart';
import 'package:med_connect/models/review.dart';
import 'package:med_connect/screens/home/appointment/appointment_details_screen.dart';
import 'package:med_connect/screens/home/appointment/edit_appointment_screen.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/review_card.dart';
import 'package:med_connect/screens/home/doctor/reviews_list_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Doctor doctor;
  final bool showButton;
  const DoctorDetailsScreen({
    Key? key,
    required this.doctor,
    this.showButton = true,
  }) : super(key: key);

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(36, 88, 38, 36),
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 120,
                        width: 110,
                        alignment: Alignment.center,
                        color: Colors.grey.withOpacity(.1),
                        child: FutureBuilder<String>(
                          future: storage
                              .profileImageDownloadUrl(widget.doctor.id!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return GestureDetector(
                                onTap: () async {
                                  // print(await ref.getDownloadURL());
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
                                height: 120,
                                width: 110,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator.adaptive(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.person)),
                              );
                            }
                            return const CircularProgressIndicator.adaptive();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doctor.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.doctor.mainSpecialty!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Text(
                            widget.doctor.currentLocation!.location!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color.fromARGB(80, 252, 228, 6),
                              ),
                              Text(calculateRating(widget.doctor.reviews)
                                  .toStringAsFixed(2)),
                              const SizedBox(width: 10),
                              Text(
                                widget.doctor.reviews == null
                                    ? 'No reviews yet'
                                    : '(${widget.doctor.reviews!.length} reviews)',
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SolidIconButton(
                        iconData: Icons.call,
                        onPressed: () async {
                          final Uri phoneUri = Uri(
                            scheme: 'tel',
                            path: widget.doctor.phone,
                          );

                          if (await canLaunchUrl(phoneUri)) {
                            launchUrl(phoneUri);
                          } else {
                            showAlertDialog(context);
                          }
                        }),
                    const SizedBox(width: 14),
                    SolidIconButton(
                        iconData: Icons.sms_rounded,
                        onPressed: () async {
                          final Uri smsUri = Uri(
                            scheme: 'sms',
                            path: widget.doctor.phone,
                            queryParameters: <String, String>{
                              'body': Uri.encodeComponent('From MedConnect\n'),
                            },
                          );

                          if (await canLaunchUrl(smsUri)) {
                            launchUrl(smsUri);
                          } else {
                            showAlertDialog(context);
                          }
                        })
                  ],
                ),

                if (widget.doctor.bio != null && widget.doctor.bio!.isNotEmpty)
                  const SizedBox(height: 30),

                if (widget.doctor.bio != null && widget.doctor.bio!.isNotEmpty)
                  const HeaderText(text: 'Bio'),

                if (widget.doctor.bio != null && widget.doctor.bio!.isNotEmpty)
                  Text(widget.doctor.bio!),

                const Divider(height: 50),

                ///OTHER SPECIALTIES

                if (widget.doctor.otherSpecialties != null &&
                    widget.doctor.otherSpecialties!.isNotEmpty)
                  const SizedBox(height: 30),
                if (widget.doctor.otherSpecialties != null &&
                    widget.doctor.otherSpecialties!.isNotEmpty)
                  const HeaderText(text: 'Other specialties'),
                if (widget.doctor.otherSpecialties != null &&
                    widget.doctor.otherSpecialties!.isNotEmpty)
                  ...widget.doctor.otherSpecialties!
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.5),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 2,
                                  backgroundColor: Colors.blueGrey,
                                ),
                                const SizedBox(width: 10),
                                Text(e)
                              ],
                            ),
                          ))
                      .toList(),

                ///EXPERIENCE

                if (widget.doctor.experiences != null &&
                    widget.doctor.experiences!.isNotEmpty)
                  const SizedBox(height: 30),
                if (widget.doctor.experiences != null &&
                    widget.doctor.experiences!.isNotEmpty)
                  const HeaderText(text: 'Experience'),
                if (widget.doctor.experiences != null &&
                    widget.doctor.experiences!.isNotEmpty)
                  ...widget.doctor.experiences!
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 2,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    e.toString(),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),

                ///SERVICES

                if (widget.doctor.services != null &&
                    widget.doctor.services!.isNotEmpty)
                  const SizedBox(height: 30),
                if (widget.doctor.services != null &&
                    widget.doctor.services!.isNotEmpty)
                  const HeaderText(text: 'Services Offered'),
                if (widget.doctor.services != null &&
                    widget.doctor.services!.isNotEmpty)
                  ...widget.doctor.services!
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.5),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 2,
                                  backgroundColor: Colors.blueGrey,
                                ),
                                const SizedBox(width: 10),
                                Text(e)
                              ],
                            ),
                          ))
                      .toList(),

                ///REVIEWS

                if (widget.doctor.reviews != null &&
                    widget.doctor.reviews!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const HeaderText(text: 'Reviews'),
                      TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 14))),
                        onPressed: () {
                          navigate(
                              context,
                              ReviewListScreen(
                                  reviews: widget.doctor.reviews!));
                        },
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                if (widget.doctor.reviews != null &&
                    widget.doctor.reviews!.isNotEmpty)
                  ReviewCard(
                    review: widget.doctor.reviews!
                        .where((element) =>
                            element.comment != null &&
                            element.comment!.isNotEmpty)
                        .toList()[0],
                  ),

                ///BUTTON

                const SizedBox(height: 50),
              ],
            ),
            if (widget.showButton)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 52 + 80,
                  child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: CustomFlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text('Book an appointment'),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_right)
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, widget.doctor.id);
                      },
                    ),
                  ),
                ),
              ),
            CustomAppBar(
              title: 'Doctor info',
              actions: [
                OutlineIconButton(
                  iconData: Icons.more_horiz,
                  onPressed: () {},
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
