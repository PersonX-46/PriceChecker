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
  String _searchQuery = "";

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
        _filteredItems = _items.take(100).toList(); // Limit to first 100 items
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error fetching items: $e");
    }
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      final filtered = _items
          .where((item) =>
      item['ItemCode'].toString().contains(query) ||
          item['Description'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['Barcode'].toString().contains(query))
          .toList();
      _filteredItems = filtered.take(100).toList(); // Apply limit to filtered results
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items Table"),
        backgroundColor: Colors.deepPurple[800],
      ),
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
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.deepPurple[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _filterItems, // Update search query
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Enable vertical scrolling
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Item Code", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Description", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Barcode", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Location", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Price", style: TextStyle(color: Colors.white))),
                    ],
                    rows: _filteredItems.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(item['ItemCode'] ?? "", style: const TextStyle(color: Colors.white))),
                        DataCell(Text(item['Description'] ?? "", style: const TextStyle(color: Colors.white))),
                        DataCell(Text(item['Barcode'] ?? "", style: const TextStyle(color: Colors.white))),
                        DataCell(Text(item['Location'] ?? "", style: const TextStyle(color: Colors.white))),
                        DataCell(Text(item['PosUnitPrice'].toString(), style: const TextStyle(color: Colors.white))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
