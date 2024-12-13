import 'package:flutter/material.dart';
import 'db_connection.dart'; // Adjust the path based on your file structure.

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final DBConnection _dbConnection = DBConnection(); // Initialize DBConnection
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
        _items = _dbConnection.getFetchedItems() ?? [];
        _filteredItems = _items.take(50).toList(); // Limit to first 50 items
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
      final filtered = _items
          .where((item) =>
          (item['Description'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      _filteredItems = filtered.take(50).toList(); // Apply limit to filtered results
    });
  }

  void _getItemByBarcode(String barcode) {
    setState(() {
      final foundItems = _items
          .where((item) => item['Barcode']?.toString() == barcode)
          .toList();
      _filteredItems = foundItems.take(50).toList();
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
            colors: [Colors.black87, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        )
            : SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: isSmallScreen
                          ? screenWidth * 0.2
                          : screenWidth * 0.1, // Adjust size based on screen
                    ),
                    const SizedBox(width: 8), // Fixed spacing
                    Flexible(
                      child: Text(
                        "Price Checker",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis, // Prevent overflow
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: "Search by Barcode",
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.deepPurple[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
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
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              item['Description'] ?? "",
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              item['Barcode'] ?? "",
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              item['Location'] ?? "",
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              item['PosUnitPrice']?.toString() ?? "",
                              style: const TextStyle(color: Colors.white),
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
