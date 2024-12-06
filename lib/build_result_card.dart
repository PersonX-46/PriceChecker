import 'package:flutter/material.dart';

Widget buildResultCard({
  required String title,
  required String value,
  required IconData icon,
  required List<Color> gradient,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double iconSize = constraints.maxWidth * 0.3; // Smaller icon size for compact devices
      double textSize = constraints.maxWidth > 300 ? 32 : 18; // Adjust text size for small screens
      double valueSize = constraints.maxWidth > 300 ? 30 : 16;
      double padding = constraints.maxWidth > 300 ? 16 : 8; // Adjust padding

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: constraints.maxWidth > 300 ? 8 : 4),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: iconSize,
                ),
                SizedBox(width: constraints.maxWidth > 300 ? 16 : 8), // Adjust spacing
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth > 300 ? 4 : 2), // Adjust spacing
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: valueSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
