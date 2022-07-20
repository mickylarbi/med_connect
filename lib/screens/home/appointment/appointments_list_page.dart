import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/appointment.dart';
import 'package:med_connect/screens/home/appointment/appointment_card.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/header_text.dart';
import 'package:med_connect/screens/shared/outline_icon_button.dart';

class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              const SizedBox(height: 138),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appointmentsList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 0,
                    indent: 126,
                    endIndent: 36,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return AppointmentCard(
                    appointment: Appointment(),
                  );
                },
              ),
            ],
          ),
        ),
        ...fancyAppBar(
          context,
          _scrollController,
          'Appointments',
          [
            OutlineIconButton(
              iconData: Icons.filter_alt,
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

List appointmentsList = List.generate(20, (index) => index);
