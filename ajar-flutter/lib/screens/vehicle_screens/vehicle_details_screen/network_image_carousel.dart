// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:ajar/utils/theme_constants.dart';

// class NetworkImageCarousel extends StatefulWidget {
//   final List<String> networkImages; // List of network image URLs

//   const NetworkImageCarousel({
//     super.key,
//     required this.networkImages,
//   });

//   @override
//   State<NetworkImageCarousel> createState() => _ImageCarouselState();
// }

// class _ImageCarouselState extends State<NetworkImageCarousel> {
//   int _currentIndex = 0; // Track the current index for the indicator

//   @override
//   Widget build(BuildContext context) {
//     // Check if dark mode is enabled
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     // Define colors for the shimmer effect based on the theme
//     final baseColor =
//         isDarkMode ? fdarkBlue.withOpacity(0.7) : Colors.grey.shade300;
//     final highlightColor =
//         isDarkMode ? fMainColor.withOpacity(0.5) : Colors.grey.shade100;
//     final backgroundColor =
//         isDarkMode ? fdarkBlue.withOpacity(0.9) : Colors.white;

//     return Column(
//       children: [
//         // The CarouselSlider to show images
//         CarouselSlider(
//           options: CarouselOptions(
//             height: 250.0,
//             viewportFraction: 1.0,
//             enlargeCenterPage: false,
//             enableInfiniteScroll: false,
//             autoPlay: false,
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _currentIndex = index; // Update current index for the dots
//               });
//             },
//           ),
//           items: widget.networkImages.map((imageUrl) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return CachedNetworkImage(
//                   imageUrl: imageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   placeholder: (context, url) => Shimmer.fromColors(
//                     baseColor: baseColor,
//                     highlightColor: highlightColor,
//                     child: Container(
//                       width: double.infinity,
//                       height: 250.0,
//                       color: backgroundColor,
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Image.asset(
//                     'assets/vehicles/1.png', // Default image on error
//                     fit: BoxFit.contain,
//                     width: double.infinity,
//                   ),
//                 );
//               },
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 10), // Space between carousel and dots
//         // Dot Indicator Row
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: widget.networkImages.map((imageUrl) {
//             int index = widget.networkImages.indexOf(imageUrl);
//             return Container(
//               width: 5.0,
//               height: 8.0,
//               margin:
//                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _currentIndex == index
//                     ? fMainColor // Active dot color
//                     : Colors.grey, // Inactive dot color
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ajar/utils/theme_constants.dart';

class NetworkImageCarousel extends StatefulWidget {
  final List<String> networkImages; // List of network image URLs

  const NetworkImageCarousel({
    super.key,
    required this.networkImages,
  });

  @override
  State<NetworkImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<NetworkImageCarousel> {
  int _currentIndex = 0; // Track the current index for the indicator

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The CarouselSlider to show images
        CarouselSlider(
          options: CarouselOptions(
            height: 250.0,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index; // Update current index for the dots
              });
            },
          ),
          items: widget.networkImages.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                // Check if the image is a local asset or a network URL
                return imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250.0,
                        errorBuilder: (context, error, stackTrace) {
                          // Show error icon if image fails to load
                          return const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      )
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 250.0,
                      );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10), // Space between carousel and dots
        // Dot Indicator Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.networkImages.map((imageUrl) {
            int index = widget.networkImages.indexOf(imageUrl);
            return Container(
              width: 5.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? fMainColor // Active dot color
                    : Colors.grey, // Inactive dot color
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
