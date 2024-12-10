import 'package:flutter/material.dart';

Widget buildResultCard({
  required String title,
  required String subtitle,
  required String value,
  required IconData icon,
  required double textSize,
  required List<Color> gradient,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Limit icon size to a maximum value to avoid overflow
      double iconSize = constraints.maxWidth * 0.2; // Slightly smaller for better balance

      double textSize = constraints.maxWidth > 600 ? 24 : 18; // Adjust text size for readability
      double valueSize = constraints.maxWidth > 600 ? 32 : 18;
      double padding = constraints.maxWidth > 600 ? 16 : 12; // Adjust padding

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18), // Round corners for a modern look
        ),

        elevation: 6, // Increased elevation for a shadow effect
        margin: EdgeInsets.symmetric(vertical: constraints.maxWidth > 300 ? 12 : 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18), // Rounded corners match the card
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                // Icon and Title aligned at the top-left corner
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: iconSize, // Fixed size to ensure it stays within bounds
                      height: iconSize,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    const SizedBox(width: 12), // Spacing between the icon and text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2, // Slightly spaced out for a modern feel
                          ),
                        ),
                        Text(
                          subtitle,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: textSize * 0.7,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2, // Slightly spaced out for a modern feel
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16), // Space between title and value

                // Value in the center
                Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: valueSize + textSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start, // Ensures text is centered
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

