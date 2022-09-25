import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_connect/models/pharmacy/drug.dart';
import 'package:med_connect/screens/home/pharmacy/drug_details_screen.dart';
import 'package:med_connect/screens/home/pharmacy/pharmacy_page.dart';
import 'package:med_connect/utils/constants.dart';
import 'package:med_connect/utils/functions.dart';

class DrugSearchDelegate extends SearchDelegate {
  List<Drug> drugsList;
  List<String> groups;
  DrugSearchDelegate(this.drugsList, this.groups);

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
  String? get searchFieldLabel => 'Search by brand or generic name';

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

  // @override
  // PreferredSizeWidget? buildBottom(BuildContext context) {
  //   return PreferredSize(
  //     child: ListView.separated(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 20,
  //       itemBuilder: (context, index) => Card(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //         elevation: 0,
  //       ),
  //       separatorBuilder: (context, index) => Container(),
  //     ),
  //     preferredSize: Size(kScreenWidth(context), 100),
  //   );
  // }

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
    List<Drug> searchHits = [];
    List<Drug> temp = drugsList
        .where((element) =>
            element.brandName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.brandName!.compareTo(b.brandName!));
    searchHits.addAll(temp);

    temp = drugsList
        .where((element) =>
            element.genericName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.genericName!.compareTo(b.genericName!));
    searchHits.addAll(temp.where((element) => !drugsList.contains(element)));

    temp = drugsList
        .where((element) =>
            element.group!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.group!.compareTo(b.group!));
    searchHits.addAll(temp.where((element) => !drugsList.contains(element)));

    return ListView(
      padding: const EdgeInsets.all(36),
      children: [
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: .55,
          ),
          itemCount: searchHits.length,
          itemBuilder: (BuildContext context, int index) {
            return DrugCard(drug: searchHits[index]);
          },
        ),
      ],
    );
  }
}
