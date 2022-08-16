import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_services.dart';
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
  FirestoreServices db = FirestoreServices();

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
                    const HeaderText(text: 'Upcoming appointments'),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View all',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ))
                  ],
                ),
              ),
              // const SizedBox(height: 10),
              const HomePageAppointmentCard(),

              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HeaderText(text: 'Top doctors'),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View all',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 240,
                width: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  clipBehavior: Clip.none,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 10),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/bruno-rodrigues-279xIHymPYY-unsplash.jpg'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              color: Colors.black.withOpacity(.15),
                              offset: const Offset(0, 10),
                            ),
                          ]),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        // height: 200,
                        // width: (kScreenWidth(context) / 2) - 34,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0),
                              Colors.black.withOpacity(.1),
                              Colors.black.withOpacity(.2),
                              Colors.black.withOpacity(.39),
                              Colors.black.withOpacity(.49),
                              Colors.black.withOpacity(.59),
                            ],
                          ),
                        ),
                        child: IconTheme(
                          data: const IconThemeData(size: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Dr Kwadwo Nkansah',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Cardiologist',
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.star, color: Colors.yellow),
                                  Flexible(
                                    child: Text(
                                      '4.5',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.fade,
                                      // maxLines: 3,
                                      // softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.location_pin, color: Colors.blue),
                                  Flexible(
                                    child: Text(
                                      'Tech Hospital, Kumasi',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                      // maxLines: 3,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HeaderText(text: 'New messages'),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View all',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ))
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(indent: 50);
                },
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/humberto-chavez-FVh_yqLR9eA-unsplash.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    title: Text('Dr Amanda Arthur'),
                    subtitle: Text('Great!'),
                    trailing: const CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        ...fancyAppBar(context, scrollController, 'Hello', [
          InkWell(
            onTap: (() async {
              showLoadingDialog(context);
              try {
                DocumentSnapshot<Map<String, dynamic>> result =
                    await db.patient;
                Patient patient =
                    Patient.fromFirestore(result.data()!, result.id);

                Navigator.pop(context);
                navigate(
                    context,
                    PatientProfileScreen(
                      patient: patient,
                    ));
              } catch (e) {
                Navigator.pop(context);
                showAlertDialog(context, message: 'Couldn\'t get profile info');
              }
            }),
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(.1),
                child: FutureBuilder<String>(
                  future: storage.profileImageUrl(auth.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Icon(
                        Icons.person,
                        color: Colors.grey,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  },
                ),
              ),
            ),
          ),
        ])
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
