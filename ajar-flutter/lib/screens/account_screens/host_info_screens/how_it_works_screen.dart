import 'package:ajar/utils/theme_colors_constants.dart';
import 'package:flutter/material.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.03),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: const Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.directions_car_outlined,
                    size: 40,
                    color: fMainColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "How it works",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: fMainColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const HowItWorksSection(
                title: "List your car for free",
                description:
                    "Share your truck, sports car, or anything in between. Listing takes about 10 minutes and is free—no sign-up charges, no monthly fees.",
              ),
              const HowItWorksSection(
                title: "Set your price & rules",
                description:
                    "Set your own daily price, or let your price automatically adjust to match demand. Customize when your car is available and lay your own ground rules. Also choose how you interact with guests—you can meet them in person or offer self check-in. You're always in control, and we’re here to help.",
              ),
              const HowItWorksSection(
                title: "Welcome your guests",
                description:
                    "When a qualified guest books your car, you’ll confirm pickup details before their trip. Guests usually pick up at your home location, but you can also deliver to them to earn even more.\n\nWhen the trip starts, simply check them in with the Turo app, then sit back and relax until the trip is over.",
              ),
              const HowItWorksSection(
                title: "Get paid",
                description:
                    "Get paid via direct deposit within three days after each trip. You’ll earn 60%-90% of the trip price, depending on the protection plan you choose. You’ll also get reimbursed for things like fuel and any league beyond your limit.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  final String title;
  final String description;

  const HowItWorksSection({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
