import 'package:flutter/material.dart';

const double kIconSize = 64;
const double kFontSize = 18;
const double kSpacingLarge = 16;
const double kSpacingSmall = 8;

class NoPdfLoadedView extends StatelessWidget {
  const NoPdfLoadedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf, size: kIconSize, color: Colors.grey),
          SizedBox(height: kSpacingLarge),
          Text(
            'No PDF loaded',
            style: TextStyle(fontSize: kFontSize, color: Colors.grey),
          ),
          SizedBox(height: kSpacingSmall),
          Text(
            'Open a PDF file to get started',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
