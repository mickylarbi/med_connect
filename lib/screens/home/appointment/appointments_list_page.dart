import 'package:flutter/material.dart';
import 'package:med_connect/screens/shared/header_text.dart';

class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: HeaderText(
              text: 'Appointments',
              isLarge: true,
            ),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          ),
          SliverToBoxAdapter(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 24),
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appointmentsList.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 20);
              },
              itemBuilder: (BuildContext context, int index) {
                return AppointmentCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

List appointmentsList = List.generate(20, (index) => index);

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
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
          color: Colors.white,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Neurosurgeon',
                  style: TextStyle(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.calendar_month,
                  ),
                  Text(
                    'Mon, Jan 24 2022',
                    style: TextStyle(),
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(
                    Icons.watch,
                  ),
                  Text(
                    '10:00 am',
                    style: TextStyle(),
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
