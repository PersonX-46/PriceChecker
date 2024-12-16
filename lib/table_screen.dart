import 'package:flutter/material.dart';
import 'db_connection.dart'; // Adjust the path based on your file structure.

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final DBConnection _dbConnection = DBConnection();
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];
  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      await _dbConnection.initConnection();
      await _dbConnection.fetchAllItems();
      setState(() {
        _items = _dbConnection.getFetchedItems();
        _filteredItems = _items.take(50).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error fetching items: $e");
    }
  }

  void _filterItemsByDescription(String query) {
    setState(() {
      _filteredItems = _items
          .where((item) =>
          (item['Description'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .take(50)
          .toList();
    });
  }

  void _getItemByBarcode(String barcode) {
    setState(() {
      _filteredItems = _items
          .where((item) =>
      (item['Barcode'] ?? '').toString().toLowerCase() == barcode.toLowerCase())
          .take(50)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Logo and Title Section
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: isSmallScreen
                          ? screenWidth * 0.2
                          : screenWidth * 0.1,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Price Checker",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search Section
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.deepPurple],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Enter Barcode',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            border: InputBorder.none,
                          ),
                          onChanged: _getItemByBarcode,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _filterItemsByDescription(searchController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[700],
                        ),
                        child: const Text(
                          "Search Description",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Table Section
                Expanded(
                  child: _filteredItems.isEmpty
                      ? const Center(
                    child: Text(
                      "No items found",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text("Item Code",
                                style: TextStyle(color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Description",
                                style: TextStyle(color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Barcode",
                                style: TextStyle(color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Location",
                                style: TextStyle(color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Price",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                        rows: _filteredItems.map((item) {
                          return DataRow(cells: [
                            DataCell(Text(
                              item['ItemCode'] ?? "",
                              style:
                              const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              item['Description'] ?? "",
                              style:
                              const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              item['Barcode'] ?? "",
                              style:
                              const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              item['Location'] ?? "",
                              style:
                              const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              item['PosUnitPrice']?.toString() ?? "",
                              style:
                              const TextStyle(color: Colors.white),
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
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
