import 'package:flutter/material.dart';
import 'package:pricechecker/db_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'build_result_card.dart';
import 'package:intl/intl.dart';


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

  @override
  void dispose() {
    barcodeController.dispose();
    super.dispose();
  }

  late DBConnection db;

  @override
  void initState() {
    super.initState();
    db = DBConnection();
    initDatabase();
  }

  Future<void> initDatabase() async {
    try {
      await db.initConnection();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void onBarcodeEntered(String value) async{
    setState(() {
      barcode = value;
    });

    try {
      String itemDetails = await db.getItemsByBarcode(value);

      List<dynamic> items = jsonDecode(itemDetails);

      if (items.isNotEmpty) {
        final item = items[0];

        final formatter = NumberFormat("RM 0.00");

        setState(() {
          description = item['Description'] ?? "N/A";
          unitPrice = item['DefaultUnitPrice'] != null
          ? formatter.format(item['DefaultUnitPrice']) : "N/A";
          locationPrice = item['PosUnitPrice'] != null
          ? formatter.format(item['PosUnitPrice']) : "N/A";
        });
      }
      Fluttertoast.showToast(
        msg: "Item found: $itemDetails",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: screenWidth * 0.2,
                    ),
                    const SizedBox(width: 10,),
                    const Text(
                      "Price Checker",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),

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
                            decoration: const InputDecoration(
                              labelText: 'Enter Barcode',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onBarcodeEntered(barcodeController.text.trim());
                          },
                          child: const Text(
                            "Search",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 600 ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: screenWidth > 600 ? 1.5 : 1.2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final data = [
                        {
                          "title": "Barcode",
                          "value": barcode,
                          "icon": Icons.qr_code,
                          "gradient": [Colors.deepPurpleAccent, Colors.blueAccent],
                        },
                        {
                          "title": "Description",
                          "value": description,
                          "icon": Icons.description,
                          "gradient": [Colors.blueAccent, Colors.teal],
                        },
                        {
                          "title": "Unit Price",
                          "value": unitPrice,
                          "icon": Icons.price_change,
                          "gradient": [Colors.orangeAccent, Colors.yellowAccent],
                        },
                        {
                          "title": "Location Price",
                          "value": locationPrice,
                          "icon": Icons.location_on,
                          "gradient": [Colors.redAccent, Colors.orangeAccent],
                        },
                      ];
                      final item = data[index];
                      return buildResultCard(
                        title: item["title"] as String,
                        value: item["value"] as String,
                        icon: item["icon"] as IconData,
                        gradient: item['gradient'] as List<Color>,
                      );
                    },
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

