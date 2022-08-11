import 'package:flutter/material.dart';
import 'package:med_connect/models/review.dart';
import 'package:med_connect/screens/home/doctor/review_card.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/outline_icon_button.dart';

class ReviewListScreen extends StatelessWidget {
  final List<Review> reviews;
  const ReviewListScreen({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.fromLTRB(36, 88, 36, 36),
              physics: const BouncingScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 50,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return ReviewCard(review: reviews[index]);
              },
            ),
            CustomAppBar(
              title: 'Reviews',
              actions: [
                OutlineIconButton(
                  iconData: Icons.sort_rounded,
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}