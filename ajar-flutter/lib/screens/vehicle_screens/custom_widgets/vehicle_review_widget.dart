import 'package:ajar/models/reviews/reviews_model.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carded/carded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ReviewWidget extends StatelessWidget {
  final Review review;

  const ReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return CardyContainer(
      borderRadius: BorderRadius.circular(10),
      spreadRadius: 0,
      blurRadius: 1,
      shadowColor: isDarkMode ? fdarkBlue : Colors.grey,
      margin: const EdgeInsets.only(right: 8.0),
      color: isDarkMode ? fdarkBlue : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: 250, // Adjust the width to fit your design
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture and name with date
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? fMainColor : Colors.grey.shade300,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(34.0),
                      child: CachedNetworkImage(
                        imageUrl: review.reviewer.profilePicture!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reviewer Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < int.parse(review.rating)
                                ? IconlyBold.star
                                : IconlyLight.star,
                            color:
                                Colors.amber, // Use purple color for the stars
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 2,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            review.reviewer.firstName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            formatDate(review.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )

                      // Review Date
                    ],
                  ),
                ],
              ),

              // Rating Stars

              const SizedBox(height: 10),

              // Review Text
              Text(
                review.review,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
