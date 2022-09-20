import 'package:flutter/material.dart';
import 'package:med_connect/models/pharmacy/drug.dart';
import 'package:med_connect/screens/home/appointment/appointments_list_page.dart';
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
      // backgroundColor: kBackgroundColor,
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
