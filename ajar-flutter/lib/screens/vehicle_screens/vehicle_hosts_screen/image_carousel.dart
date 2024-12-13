import 'dart:io';
import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';

class ImageCarousel extends StatefulWidget {
  final List<dynamic> selectedImages;

  const ImageCarousel({
    super.key,
    required this.selectedImages,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0; // Track the current index

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The CarouselSlider to show images
        CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            height: 250.0,
            viewportFraction: 1.0,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index; // Update current index
              });
            },
          ),
          items: widget.selectedImages
              .where((image) => image != null) // Filter out null values
              .map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Image(
                  image: image is XFile
                      ? FileImage(File(image.path)) // Use FileImage for XFile
                      : NetworkImage(image)
                          as ImageProvider, // Use NetworkImage for URL
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10), // Add space between carousel and dots
        // Dot Indicator Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.selectedImages
              .where((image) => image != null)
              .map((image) {
            int index = widget.selectedImages.indexOf(image);
            return Container(
              width: 8.0,
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
