import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pricechecker/db_connection.dart';
import 'package:pricechecker/table_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseConfigScreen extends StatefulWidget {
  const DatabaseConfigScreen({super.key});

  @override
  State<DatabaseConfigScreen> createState() => _DatabaseConfigScreenState();
}

class _DatabaseConfigScreenState extends State<DatabaseConfigScreen> {
  final TextEditingController serverController = TextEditingController();
  final TextEditingController databaseController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool showLocationPrice = false;
  late DBConnection db;

  @override
  void initState() {
    loadConfig();
    super.initState();
  }

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      serverController.text = prefs.getString('server') ?? "NULL";
      databaseController.text = prefs.getString('database') ?? "NULL";
      usernameController.text = prefs.getString('username') ?? 'NULL';
      passwordController.text = prefs.getString('password') ?? "NULL";
      portController.text = prefs.getString('port') ?? "NULL";
      locationController.text = prefs.getString('location') ?? "HQ";
      showLocationPrice = prefs.getBool('showLocationPrice') ?? false;
    });
  }

  void initConnection() async {
    try {
      db = DBConnection();
      if (await db.initConnection()) {
        Fluttertoast.showToast(
          msg: "Database connected successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Database connection unsuccessful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error connecting database",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      db.closeConnection();
    }
  }

  Future<void> saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server', serverController.text.trim());
    await prefs.setString('database', databaseController.text.trim());
    await prefs.setString("username", usernameController.text.trim());
    await prefs.setString('password', passwordController.text.trim());
    await prefs.setString('port', portController.text.trim());
    await prefs.setBool("showLocationPrice", showLocationPrice);
    await prefs.setString('location', locationController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Configuration saved successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final containerWidth = isLandscape
              ? constraints.maxWidth * 0.7
              : constraints.maxWidth * 1;

          double screenWidth = MediaQuery
              .of(context)
              .size
              .width;
          bool isSmallScreen = screenWidth < 600;

          return Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment:
                  isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment
                      .center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: isSmallScreen
                              ? screenWidth * 0.15
                              : screenWidth * 0.1,
                        ),
                        const SizedBox(width: 8), // Adjusted spacing
                        Text(
                          "Price Checker",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            width: containerWidth,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueGrey.shade800,
                                  Colors.deepPurple.shade600
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Enter Database Configuration",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30,),
                                GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isLandscape ? 2 : 1,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 5,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: 6,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return _buildTextField(
                                          serverController, 'Server Name',
                                          Icons.cloud);
                                    } else if (index == 1) {
                                      return _buildTextField(
                                          databaseController, 'Database Name',
                                          Icons.storage);
                                    } else if (index == 2) {
                                      return _buildTextField(
                                          usernameController, 'Username',
                                          Icons.person);
                                    } else if (index == 3) {
                                      return _buildTextField(
                                          passwordController, 'Password',
                                          Icons.lock);
                                    } else if (index == 4) {
                                      return _buildTextField(
                                          portController, 'Port',
                                          Icons.network_cell);
                                    } else if (index == 5) {
                                      return _buildTextField(
                                          locationController, "Location",
                                          Icons.location_on);
                                    }
                                    return null;
                                  },
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: showLocationPrice,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          showLocationPrice = newValue!;
                                        });
                                      },
                                      activeColor: Colors.deepPurple,
                                    ),
                                    const Text(
                                      'Show Location Price',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                Center(
                                  child: Wrap(
                                    spacing: 8,
                                    // Horizontal space between buttons
                                    runSpacing: 8,
                                    // Vertical space between rows of buttons
                                    alignment: WrapAlignment.center,
                                    // Align buttons in the center
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .deepPurpleAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12),
                                          ),
                                          elevation: 8,
                                        ),
                                        icon: const Icon(
                                          Icons.save, color: Colors.white,),
                                        onPressed: saveConfig,
                                        label: const Text(
                                          'Save Configuration',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .deepPurpleAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12),
                                          ),
                                          elevation: 8,
                                        ),
                                        icon: const Icon(
                                          Icons.settings_ethernet,
                                          color: Colors.white,),
                                        onPressed: initConnection,
                                        label: const Text(
                                          'Test Database',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .deepPurpleAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12),
                                          ),
                                          elevation: 8,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (
                                                context) => const TableScreen()),
                                          );
                                        },
                                        icon: const Icon(Icons.table_chart,
                                          color: Colors.white,),
                                        label: const Text(
                                          'View Table',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black45,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
