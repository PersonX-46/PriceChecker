import 'package:fluttertoast/fluttertoast.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'dart:convert';

class DBConnection {

  static const String server = "192.168.1.22";
  static const String databaseName = "AED_ALPHA_FE";
  static const String username = "test";
  static const String password = "test";
  static const String port = '50602';

  late MssqlConnection _connection;

  DBConnection() {
    initConnection();
  }

  Future<void> initConnection() async {
    _connection = MssqlConnection.getInstance();
    await _connection.connect(
      ip: server,
      port: port,
      databaseName: databaseName,
      username: username,
      password: password
    );
  }

  Future<void> closeConnection() async {
    if (_connection.isConnected) {
      await _connection.disconnect();
    }
  }

  List<Map<String, dynamic>> _items = [];

  Future<void> fetchAllItems() async {
    if (!_connection.isConnected) {
      throw Exception("Database connection is not initialized");
    }

    const query = """
    WITH BaseItems AS (
          SELECT
              u.ItemCode,
              i.Description,
              u.Price AS DefaultUnitPrice,
              u.Cost,
              ISNULL(NULLIF(u.BarCode, ''), i.ItemCode) as Barcode,
              ISNULL(p.Location, 'HQ') as Location,
              ISNULL(p.Price, u.Price) AS PosUnitPrice
          FROM dbo.ItemUOM u
          LEFT JOIN dbo.Item i ON u.ItemCode = i.ItemCode
          LEFT JOIN dbo.PosPricePlan p ON u.ItemCode = p.ItemCode AND p.Location = 'HQ'
      )
      SELECT * FROM BaseItems;
    """;

    String results = await _connection.getData(query);
    List<dynamic> result = jsonDecode(results); // Decode JSON as List<dynamic>

    if (result is List) {
      // Safely cast the result to List<Map<String, dynamic>>
      _items = List<Map<String, dynamic>>.from(result);
      _items.sort((a, b) => (a['Barcode'] ?? '').compareTo((b['Barcode'] ?? '')));
    } else {
      throw Exception("Invalid data format: Expected a list of maps");
    }
  }


  Map<String, dynamic>? findItemByBarcode(String barcode) {
    int left = 0;
    int right = _items.length -1;

    while (left <= right) {
      int mid = (left + right) ~/ 2;
      String midBarcode = _items[mid]['Barcode'];

      if (midBarcode == barcode) {
        return _items[mid];
      }else if (midBarcode.compareTo(barcode) < 0) {
        left = mid + 1;
      }else {
        right = mid - 1;
      }
    }
    return null;
  }

}
