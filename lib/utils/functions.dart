import 'package:med_connect/models/review.dart';

double calculateRating(List<Review> reviewList) {
  if (reviewList.isEmpty) return 0;
  
  double? sum = 0;

  for (Review review in reviewList) {
    sum = review.rating;
  }

  return sum! / reviewList.length;
}
