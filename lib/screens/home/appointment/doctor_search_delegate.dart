import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_connect/models/doctor/doctor.dart';
import 'package:med_connect/screens/home/doctor/doctor_card.dart';
import 'package:med_connect/screens/home/doctor/doctor_details_screen.dart';
import 'package:med_connect/utils/functions.dart';

class DoctorSearchDelegate extends SearchDelegate {
  List<Doctor> doctorsList;
  DoctorSearchDelegate(this.doctorsList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        textTheme: GoogleFonts.openSansTextTheme(
          const TextTheme(
            bodyText2: TextStyle(color: Colors.blueGrey, letterSpacing: .2),
          ),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Colors.blueGrey),
          elevation: 0,
          backgroundColor: Colors.grey[50],
        ));
  }

  @override
  String? get searchFieldLabel => 'Search by name';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Opacity(
        opacity: query.isEmpty ? 0 : 1,
        child: IconButton(
          onPressed: () {
            query = '';
          },
          icon: CircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 10,
            child: const Center(
              child: Icon(
                Icons.clear,
                size: 14,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return body;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return body;
  }

  Widget get body {
    List<Doctor> searchHits = doctorsList
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: [
        const SizedBox(height: 30),
        ListView.separated(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              navigate(
                context,
                DoctorDetailsScreen(
                  doctor: searchHits[index],
                  fromSearch: true,
                ),
              );
            },
            child: DoctorCard(doctor: searchHits[index]),
          ),
          separatorBuilder: (context, index) => const Divider(
            indent: 176,
            endIndent: 36,
            height: 50,
          ),
          itemCount: searchHits.length,
        ),
      ],
    );
  }
}
