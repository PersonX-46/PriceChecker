import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadConfig();
  }

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      serverController.text = prefs.getString('server') ?? "NULL";
      databaseController.text = prefs.getString('database') ?? "NULL";
      usernameController.text = prefs.getString('username') ?? 'NULL';
      passwordController.text = prefs.getString('password') ?? "NULL";
      portController.text = prefs.getString('port') ?? "NULL";
    });
  }

  Future<void> saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server', serverController.text.trim());
    await prefs.setString('database', databaseController.text.trim());
    await prefs.setString("username", usernameController.text.trim());
    await prefs.setString('password', passwordController.text.trim());
    await prefs.setString('port', portController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Configuration saved successfully!")
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Configuration'),),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final containerWidth = isLandscape
            ? constraints.maxWidth * 0.5
            : constraints.maxWidth * 0.8;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: containerWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Enter Database Configuration",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: serverController,
                      decoration: const InputDecoration(
                        labelText: 'Server Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: databaseController,
                      decoration: const InputDecoration(
                        labelText: 'Database Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: portController,
                      decoration: const InputDecoration(
                        labelText: 'Port',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(constraints.maxWidth * 0.5, 50),
                      ),
                      onPressed: saveConfig,
                      child: const Text(
                        'Save Configuration',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

}