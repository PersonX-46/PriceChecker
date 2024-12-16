import 'package:flutter/material.dart';

Widget buildResultCard({
  required String title,
  required String subtitle,
  required String value,
  required IconData icon,
  required int textSize, // You pass the textSize from the parent widget here
  required List<Color> gradient,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Your existing code remains unchanged

      double fontsize = constraints.maxWidth > 600 ? 24 : 18; // Adjust text size for readability
      double iconSize = constraints.maxWidth * 0.2; // Icon size based on layout constraints
      double padding = constraints.maxWidth > 600 ? 16 : 12; // Adjust padding based on width

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 6,
        margin: EdgeInsets.symmetric(vertical: constraints.maxWidth > 300 ? 12 : 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded( // Ensures text adjusts to available space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: fontsize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: fontsize * 0.7,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible( // Prevents overflow by flexibly sizing the child
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: textSize.toDouble(),
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      );
    },
  );
}


