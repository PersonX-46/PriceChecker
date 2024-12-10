import 'package:flutter/material.dart';
import 'package:pricechecker/configuration_screen.dart';

Future<void> showPasswordPrompt(BuildContext context) async {
  TextEditingController passwordController = TextEditingController();

  // Get the current date, month, and year
  DateTime now = DateTime.now();
  // Calculate the product of year, month, and day
  int correctPassword = now.year * now.month * now.day; // Year * Month * Day

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      // Use MediaQuery to get the screen size
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      // Set the dialog width limit for large screens
      double dialogWidth = screenWidth > 600 ? screenWidth * 0.6 : screenWidth * 0.8;

      // Adjust font size and padding based on screen size
      double titleFontSize = screenWidth > 600 ? 30 : 24;
      double contentPadding = screenWidth > 600 ? 30 : 20;
      double buttonFontSize = screenWidth > 600 ? 16 : 14;

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners for a softer look
        ),
        backgroundColor: Colors.transparent, // Transparent background for custom decorations
        child: Container(
          width: dialogWidth, // Control the dialog width dynamically
          padding: EdgeInsets.all(contentPadding),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16), // Match the dialog border radius
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title
              Text(
                'Enter Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: contentPadding),

              // Password input field
              TextField(
                controller: passwordController,
                obscureText: true, // Hide the password
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.white54),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: contentPadding),

              // Buttons (Cancel & Submit)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Red for Cancel button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight > 600 ? 16 : 12,
                          horizontal: screenWidth > 600 ? 40 : 20),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: buttonFontSize),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String enteredPassword = passwordController.text;

                      // Check if the entered password matches the correct password
                      if (int.tryParse(enteredPassword) == correctPassword) {
                        Navigator.of(context).pop(); // Close the password dialog
                        // Proceed to show settings
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DatabaseConfigScreen(),
                          ),
                        );
                      } else {
                        // Show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Incorrect Password!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent, // Green for Submit button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight > 600 ? 16 : 12,
                          horizontal: screenWidth > 600 ? 40 : 20),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: buttonFontSize),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
