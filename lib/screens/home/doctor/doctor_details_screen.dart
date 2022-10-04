import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/doctor/doctor.dart';
import 'package:med_connect/models/review.dart';
import 'package:med_connect/screens/home/doctor/review_card.dart';
import 'package:med_connect/screens/home/doctor/reviews_list_screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Doctor doctor;
  final bool showButton;
  final bool fromSearch;
  final bool showContactButtons;

  const DoctorDetailsScreen({
    Key? key,
    required this.doctor,
    this.showButton = true,
    this.fromSearch = false,
    this.showContactButtons = false,
  }) : super(key: key);

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  StorageService storage = StorageService();
  FirestoreService db = FirestoreService();

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
                        child: StatefulBuilder(builder: (context, setState) {
                          return FutureBuilder<String>(
                            future: storage
                                .profileImageDownloadUrl(widget.doctor.id!),
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
                              return const Center(
                                  child: CircularProgressIndicator.adaptive());
                            },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Container(
                        height: 150,
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doctor.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.doctor.mainSpecialty!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.doctor.currentLocation!.location!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                if (widget.showContactButtons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          icon: const Icon(Icons.call),
                          label: const Text('Call doctor'),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blueGrey.withOpacity(.2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          onPressed: () async {
                            final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path: '+233${widget.doctor.phone}',
                            );

                            if (await canLaunchUrl(phoneUri)) {
                              launchUrl(phoneUri);
                            } else {
                              showAlertDialog(context);
                            }
                          }),
                      const SizedBox(width: 14),
                      TextButton.icon(
                        icon: const Icon(Icons.sms_rounded),
                        label: const Text('Send a text'),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey.withOpacity(.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14))),
                        onPressed: () {
                          showCustomBottomSheet(
                            context,
                            [
                              ListTile(
                                leading:
                                    const Icon(CupertinoIcons.chat_bubble_text),
                                title: const Text('SMS'),
                                onTap: () async {
                                  final Uri smsUri = Uri(
                                    scheme: 'sms',
                                    path: '+233${widget.doctor.phone}',
                                    queryParameters: <String, String>{
                                      'body': Uri.encodeComponent(
                                          'From MedConnect\n'),
                                    },
                                  );

                                  if (await canLaunchUrl(smsUri)) {
                                    launchUrl(smsUri);
                                  } else {
                                    showAlertDialog(context);
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading:
                                    const FaIcon(FontAwesomeIcons.whatsapp),
                                title: const Text('WhatsApp'),
                                onTap: () async {
                                  final Uri whatsAppUri = Uri.parse(
                                      'https://wa.me/233${widget.doctor.phone}?text=From MedConnect');

                                  if (await canLaunchUrl(whatsAppUri)) {
                                    launchUrl(whatsAppUri,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    showAlertDialog(context);
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      )
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
                                const CircleAvatar(radius: 2),
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

                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: db.instance
                        .collection('doctor_reviews')
                        .where('doctorId', isEqualTo: widget.doctor.id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {}

                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data == null ||
                            !snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const SizedBox();
                        }

                        List<Review> reviewsList = snapshot.data!.docs
                            .map(
                              (e) => Review.fromFirestore(e.data()),
                            )
                            .toList();

                        double totalRating = 0;
                        for (Review element in reviewsList) {
                          totalRating += element.rating!;
                        }
                        totalRating /= reviewsList.length;

                        return Column(
                          children: [
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const HeaderText(text: 'Reviews'),
                                TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 14))),
                                  onPressed: () {
                                    navigate(context,
                                        ReviewListScreen(reviews: reviewsList));
                                  },
                                  child: const Text('See all'),
                                ),
                              ],
                            ),
                            ReviewCard(
                              review: reviewsList
                                  .where((element) =>
                                      element.comment != null &&
                                      element.comment!.isNotEmpty)
                                  .toList()[0],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text('Total rating'),
                                const Spacer(),
                                const Icon(Icons.star, color: Colors.yellow),
                                HeaderText(
                                    text: totalRating.toStringAsFixed(1)),
                              ],
                            )
                          ],
                        );
                      }

                      return const SizedBox();
                    }),

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
                        if (widget.fromSearch) Navigator.pop(context);
                        Navigator.pop(context, widget.doctor.id);
                      },
                    ),
                  ),
                ),
              ),
            const CustomAppBar(title: 'Doctor info'),
          ],
        ),
      ),
    );
  }
}
