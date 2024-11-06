import 'package:ajar/utils/theme_colors_constants.dart';
import 'package:flutter/material.dart';

class YouAreCoverdScreen extends StatelessWidget {
  const YouAreCoverdScreen({super.key});

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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
                const Icon(
                  Icons.shield_outlined,
                  size: 40,
                  color: fMainColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  "You’re covered",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: fMainColor,
                  ),
                )
              ]),
              const SizedBox(height: 16),
              const HowItWorksSection(
                title: "\$750,000 liability insurance",
                description:
                    "With each protection plan, you're covered by \$750,000 in liability insurance protecting you in the rare case someone files a lawsuit for injury or property damage that occurs during a trip.",
              ),
              const HowItWorksSection(
                title: "Physical damage protection",
                description:
                    "Choose from a range of protection plans, each with a different level of contractual reimbursement from Ajar in the unlikely event your car is damaged, stolen, or vandalized during a trip.\nPick the plan that's right for you spring for top-tier protection, or opt for a lighter plan to pocket more earning",
              ),
              const HowItWorksSection(
                title: "Your personal insurance",
                description:
                    "Your protection plan acts as primary coverage during a trip, so your personal insurance shouldn't be affected. You'll still need your own insurance for when you drive your car and to satisfy the registration requirements in your state.",
              ),
              const HowItWorksSection(
                title: "Appraisals accepted for specialty vehicles",
                description:
                    "Get paIf you're listing an eligible specialty vehicle, you can provide, at your own expense, an appraisal from an independent source to establish the value of your vehicle. Ajar will use the appraisal to determine the amount of reimbursement in the event of damage.",
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
