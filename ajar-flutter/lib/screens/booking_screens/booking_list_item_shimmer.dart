import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingListItemShimmer extends StatelessWidget {
  const BookingListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors for the dark mode shimmer effect
    final darkBaseColor =
        fdarkBlue.withOpacity(0.7); // Slightly lighter fdarkBlue
    final darkHighlightColor = fMainColor.withOpacity(0.5); // Faded main color
    final darkBackgroundColor =
        fdarkBlue.withOpacity(0.9); // Darker base for backgrounds

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          Card(
            color:
                isDarkMode ? darkBackgroundColor : Theme.of(context).cardColor,
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Shimmer.fromColors(
                      baseColor: isDarkMode ? darkBaseColor : Colors.grey[300]!,
                      highlightColor:
                          isDarkMode ? darkHighlightColor : Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        color: isDarkMode
                            ? darkBaseColor
                            : Colors.grey[300], // Placeholder for image
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer.fromColors(
                            baseColor: isDarkMode
                                ? fdarkBlue.withOpacity(0.6)
                                : Colors.grey[300]!,
                            highlightColor: isDarkMode
                                ? fMainColor.withOpacity(0.4)
                                : Colors.grey[100]!,
                            child: Container(
                              width: 100,
                              height: 16,
                              color: isDarkMode
                                  ? darkBaseColor
                                  : Colors.grey[300], // Placeholder for name
                            ),
                          ),
                          Row(
                            children: [
                              // Remove the star icon
                              const SizedBox(width: 5),
                              Shimmer.fromColors(
                                baseColor: isDarkMode
                                    ? fdarkBlue.withOpacity(0.5)
                                    : Colors.grey[300]!,
                                highlightColor: isDarkMode
                                    ? fMainColor.withOpacity(0.3)
                                    : Colors.grey[100]!,
                                child: Container(
                                  width: 20,
                                  height: 14,
                                  color: isDarkMode
                                      ? darkBaseColor
                                      : Colors
                                          .grey[300], // Placeholder for rating
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer.fromColors(
                            baseColor: isDarkMode
                                ? fdarkBlue.withOpacity(0.4)
                                : Colors.grey[300]!,
                            highlightColor: isDarkMode
                                ? fMainColor.withOpacity(0.25)
                                : Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 14,
                              color: isDarkMode
                                  ? darkBaseColor
                                  : Colors.grey[
                                      300], // Placeholder for transmission type
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: isDarkMode
                                ? fdarkBlue.withOpacity(0.3)
                                : Colors.grey[300]!,
                            highlightColor: isDarkMode
                                ? fMainColor.withOpacity(0.2)
                                : Colors.grey[100]!,
                            child: Container(
                              width: 60,
                              height: 14,
                              color: isDarkMode
                                  ? darkBaseColor
                                  : Colors.grey[300], // Placeholder for price
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
