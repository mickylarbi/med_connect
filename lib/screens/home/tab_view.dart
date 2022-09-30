import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/storage_service.dart';
import 'package:med_connect/models/doctor/doctor.dart';
import 'package:med_connect/models/pharmacy/drug.dart';
import 'package:med_connect/screens/home/appointment/appointments_list_page.dart';
import 'package:med_connect/screens/home/appointment/doctor_search_delegate.dart';
import 'package:med_connect/screens/home/doctor/doctors_list_page.dart';
import 'package:med_connect/screens/home/homepage/home_page.dart';
import 'package:med_connect/screens/home/more_page.dart';
import 'package:med_connect/screens/home/pharmacy/checkout_screen.dart';
import 'package:med_connect/screens/home/pharmacy/pharmacy_page.dart';
import 'package:med_connect/utils/constants.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    cart = ValueNotifier<Map<Drug, int>>({});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomePage(),
              AppointmentsListPage(),
              PharmacyPage(),
            ]),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, value, child) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex.value,
              onTap: (index) {
                if (index != _currentIndex.value) {
                  _currentIndex.value = index;
                  _pageController.jumpToPage(_currentIndex.value);
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.medical_information), label: ''),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndex.dispose();

    cart.dispose();

    super.dispose();
  }
}

class ProfileImageWidget extends StatelessWidget {
  ProfileImageWidget({
    Key? key,
    this.patientId,
    required this.height,
    required this.width,
    this.borderRadius,
  }) : super(key: key);

  StorageService storage = StorageService();
  final String? patientId;
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(.1),
        child: StatefulBuilder(builder: (context, setState) {
          return FutureBuilder<String>(
            future: storage.profileImageDownloadUrl(patientId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {});
                  },
                  child: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.grey,
                    ),
                    onPressed: () async {
                      setState(() {});
                    },
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return CachedNetworkImage(
                  imageUrl: snapshot.data!,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator.adaptive(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.person)),
                );
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          );
        }),
      ),
    );
  }
}
