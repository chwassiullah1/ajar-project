import 'package:ajar/common/buttons/custom_elevated_button.dart';
import 'package:ajar/screens/account_screens/close_account_screens/close_account_feeback_screen.dart';
import 'package:ajar/utils/theme_colors_constants.dart';
import 'package:flutter/material.dart';

class CloseAccountReasonScreen extends StatefulWidget {
  const CloseAccountReasonScreen({super.key});

  @override
  State<CloseAccountReasonScreen> createState() =>
      _CloseAccountReasonScreenState();
}

class _CloseAccountReasonScreenState extends State<CloseAccountReasonScreen> {
  List<String> reasons = [
    'I have another Ajar account I\'d like to use',
    'I\'ve had a negative experience',
    'Insurance, trust or safety concerns',
    'I have privacy concerns',
    'I wasn\'t able to find/book any good cars',
    'My car is no longer available',
    'I\'m not earning enough',
    'Other',
  ];
  List<bool> selectedReasons = List.generate(8, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Close Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    side: const BorderSide(color: fMainColor),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      reasons[index],
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    value: selectedReasons[index],
                    onChanged: (value) {
                      setState(() {
                        selectedReasons[index] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            CustomElevatedButton(
                borderRadius: 8,
                text: "Next",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CloseAccountFeedbackScreen(),
                    ),
                  );
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white)
          ],
        ),
      ),
    );
  }
}
