import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pricechecker/db_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'build_result_card.dart';
import 'package:intl/intl.dart';
import 'package:pricechecker/password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Checker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PriceCheckerPage(),
    );
  }
}

class PriceCheckerPage extends StatefulWidget {
  const PriceCheckerPage({super.key});

  @override
  State<PriceCheckerPage> createState() => _PriceCheckerPageState();
}

class _PriceCheckerPageState extends State<PriceCheckerPage> {
  String barcode = "N/A";
  String description = "N/A";
  String unitPrice = "N/A";
  String locationPrice = "N/A";
  TextEditingController barcodeController = TextEditingController();
  late DBConnection db;
  Timer? _debounce;
  final FocusNode _barcodeFocusNode = FocusNode();
  late SharedPreferences prefs;
  bool showLocationPrice = false;

  @override
  void dispose() {
    barcodeController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    loadConfig();
    super.initState();
    db = DBConnection();
    initDatabase();
  }

  void loadConfig() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      showLocationPrice = prefs.getBool('showLocationPrice') ?? false;
    });
  }

  Future<void> initDatabase() async {
    try {
      Fluttertoast.showToast(
        msg: "Connecting to the database...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await db.initConnection();
      await db.fetchAllItems();
      Fluttertoast.showToast(
        msg: "Connection successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(e);
    }
  }

  void searchItem(String barcode) {
    final formatter = NumberFormat("RM 0.00");
    final item = db.findItemByBarcode(barcode);

    if (item != null) {
      setState(() {
        this.barcode = item['Barcode'] ?? "N/A";
        description = item['Description'] ?? "N/A";
        unitPrice = item['DefaultUnitPrice'] != null
            ? formatter.format(item['DefaultUnitPrice'])
            : "N/A";
        locationPrice = item['PosUnitPrice'] != null
            ? formatter.format(item['PosUnitPrice'])
            : "N/A";
      });
    } else {
      setState(() {
        this.barcode = barcode;
        description = "Item not not not not not not found found found found found";
        unitPrice = "N/A";
        locationPrice = "N/A";
      });
    }
  }

  void clearBarcode() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      barcodeController.clear();
      FocusScope.of(context).requestFocus(_barcodeFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;
    Orientation orientation = MediaQuery.of(context).orientation;

    // Set crossAxisCount based on the orientation
    int crossAxisCount = (orientation == Orientation.portrait) ? 1 : 2;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.7,
                      ), // Limit the width of the container
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Ensures the Row only takes the space it needs
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: isSmallScreen ? screenWidth * 0.2 : screenWidth * 0.1, // Adjust size based on screen
                          ),
                          const SizedBox(width: 8), // Fixed spacing between logo and text
                          Flexible(
                            child: Text(
                              "Price Checker",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 24 : 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis, // Ensures the text doesn't overflow
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.restart_alt,
                            color: Colors.white,
                            size: isSmallScreen ? screenWidth * 0.07 : screenWidth * 0.04,
                          ),
                          onPressed: () {
                            loadConfig();
                            initDatabase();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.settings, color: Colors.white, size: isSmallScreen ? screenWidth * 0.07 : screenWidth * 0.04,),
                          onPressed: () {
                            showPasswordPrompt(context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 40),

                // Barcode Input
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 166, 0, 162),
                          Color.fromARGB(255, 135, 18, 255),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: barcodeController,
                            focusNode: _barcodeFocusNode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Enter Barcode',
                              prefixIcon: Icon(Icons.search, color: Colors.white),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Process the scanned value
                              searchItem(value.trim());

                              // Clear the TextField after processing
                              clearBarcode();
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            searchItem(barcodeController.text.trim());
                          },
                          child: const Text(
                            "Search",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Expanded GridView to take remaining space
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // 1 in portrait, 2 in landscape
                      crossAxisSpacing: 8.0,        // Spacing between items horizontally
                      mainAxisSpacing: 8.0, // Spacing between items vertically
                      childAspectRatio: orientation == Orientation.landscape ? 1.5 : 1.9,       // Adjust card proportions
                    ),
                    shrinkWrap: false,                // Allows GridView to adjust to its children
                    itemCount: 2,                    // Update this based on the number of cards you have
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return buildResultCard(
                          textSize: 24,
                          title: "Barcode & Description",
                          subtitle: "Barcode: $barcode",
                          value: description,
                          icon: Icons.qr_code,
                          gradient: [Colors.blue, Colors.deepPurple],
                        );
                      } else if (index == 1) {
                        return buildResultCard(
                          textSize: 60,
                          title: "Unit & Location Price",
                          subtitle: showLocationPrice ? "Location Price" : "Unit Price",
                          value: showLocationPrice ? locationPrice : unitPrice,
                          icon: Icons.price_change,
                          gradient: [Colors.teal, Colors.greenAccent],
                        );
                      }
                      return (
                      const SizedBox(width: 0, height: 0,)
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
