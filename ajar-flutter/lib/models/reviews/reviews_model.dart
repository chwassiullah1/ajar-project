import 'package:ajar/models/auth/user_model.dart';

class Review {
  final String id;
  final String reviewerId;
  final String vehicleId;
  final String review;
  final String rating;
  final String createdAt;
  final UserModel reviewer; // Assuming you have a UserModel for reviewer

  Review({
    required this.id,
    required this.reviewerId,
    required this.vehicleId,
    required this.review,
    required this.rating,
    required this.createdAt,
    required this.reviewer,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      reviewerId: json['reviewer_id'],
      vehicleId: json['vehicle_id'],
      review: json['review'],
      rating: json['rating'].toString(),
      createdAt: json['created_at'],
      reviewer: UserModel.fromJsonForReviewer(
        json['reviewer'],
      ),
    );
  }
}
