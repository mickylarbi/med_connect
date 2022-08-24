import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/patient.dart';
import 'package:med_connect/screens/home/homepage/patient_profile.screen.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/utils/dialogs.dart';
import 'package:med_connect/utils/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  StorageService storage = StorageService();
  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            controller: scrollController,
            children: [
              const SizedBox(
                height: 138,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HeaderText(text: 'Today\'s appointments'),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View all',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: db.patientDocument.snapshots(),
          builder: (context, snapshot) {
            return SizedBox(
              height: 138,
              child: Stack(
                children: fancyAppBar(
                  context,
                  scrollController,
                  snapshot.hasError ||
                          snapshot.data == null ||
                          snapshot.data!.data() == null ||
                          snapshot.connectionState == ConnectionState.waiting
                      ? 'Hi'
                      : 'Hi ${snapshot.data!.data()!['firstName']}',
                  [
                    StatefulBuilder(
                      builder: (context, setState) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () async {
                              if (snapshot.data!.data() != null) {
                                await navigate(
                                    context,
                                    PatientProfileScreen(
                                        patient: Patient.fromFirestore(
                                            snapshot.data!.data()!,
                                            snapshot.data!.id)));

                                setState(() {});
                              }
                            },
                            child: FutureBuilder<String>(
                              future: storage.profileImageDownloadUrl(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Icon(Icons.person));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return CachedNetworkImage(
                                    imageUrl: snapshot.data,
                                    height: 44,
                                    width: 44,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator.adaptive(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.person)),
                                  );
                                }

                                return const Center(
                                    child:
                                        CircularProgressIndicator.adaptive());
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose;
    super.dispose();
  }
}

int _selectedIndex = 3;

List _categories = [
  'Pulmonology',
  'Orthopaedics',
  'Cardiology',
  'Dentistry',
  'Urology',
  'Neurosurgery',
  'Pediatrics',
  'Obstetrics and Gynecology',
  'Dermatology',
  'Oncology',
  'Optometry'
];

class HomePageAppointmentCard extends StatelessWidget {
  const HomePageAppointmentCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              color: Colors.black.withOpacity(.15),
              offset: const Offset(0, 10),
            ),
          ]),
      child: Column(children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/usman-yousaf-pTrhfmj2jDA-unsplash.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              children: const [
                Text(
                  'Dr Silas Antwi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Neurosurgeon',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.3),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  Text(
                    'Mon, Jan 24 2022',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(
                    Icons.watch,
                    color: Colors.white,
                  ),
                  Text(
                    '10:00 am',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10)
      ]),
    );
  }
}

class CategoriesCarousel extends StatefulWidget {
  const CategoriesCarousel({Key? key}) : super(key: key);

  @override
  State<CategoriesCarousel> createState() => _CategoriesCarouselState();
}

class _CategoriesCarouselState extends State<CategoriesCarousel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (_selectedIndex != index) {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: _selectedIndex == index
                  ? const EdgeInsets.symmetric(horizontal: 14)
                  : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _selectedIndex == index ? Colors.blue : null,
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: _selectedIndex == index ? Colors.white : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
      ),
    );
  }
}

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Center(child: Text('Sliver Persistent Header'));
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 200;

  @override
  // TODO: implement minExtent
  double get minExtent => 180;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
