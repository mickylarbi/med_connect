import 'dart:math';

import 'package:flutter/material.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/models/review.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/doctor_details_screen.dart';
import 'package:med_connect/screens/home/homepage/homepage.dart';
import 'package:med_connect/screens/shared/header_text.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({Key? key}) : super(key: key);

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  Doctor doctor = Doctor(
    bio:
        'This is the bioThis is the bioThis is the bioThis is the bioThis is the bio\nThis is the bioThis is the bioThis is the bio\nThis is the bioThis is the bio\nThis is the bioThis is the bioThis is the bioThis is the bioThis is the bio',
    currentLocation: 'Cape Coast Teaching Hospital',
    experiences: [],
    mainSpecialty: 'Oncology',
    name: 'Michael Larbi',
    reviews:
        List.generate(5, (index) => Review(rating: Random().nextDouble() * 5)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          height: 100,
          color: Colors.green,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [DoctorCard()],
        )
      ]),
    );
  }
}

class OldScrollView extends StatelessWidget {
  const OldScrollView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: const HeaderText(
            text: 'Doctors',
            isLarge: true,
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 20),
            const CategoriesCarousel(),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              // crossAxisSpacing: 4,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              children: List.generate(
                10,
                (index) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorDetailsScreen()));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/bruno-rodrigues-279xIHymPYY-unsplash.jpg'),
                            fit: BoxFit.cover),
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
                              style: TextStyle(color: Colors.white),
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
                  ),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
