import 'package:flutter/material.dart';

Widget buildResultCard({
  required String title,
  required String value,
  required IconData icon,
  required List<Color> gradient,
}){
  return LayoutBuilder(
    builder: (context, constraints) {
      double iconSize = constraints.maxWidth * 0.2;
      double textSize = constraints.maxWidth > 300 ? 16 : 14;
      double valueSize = constraints.maxWidth > 300 ? 18 : 16;

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,

        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: iconSize,),
                const SizedBox(width: 16,),
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
                      const SizedBox(height: 4,),
                      Text(
                        value,
                        style: TextStyle(
                            fontSize: valueSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}