import 'package:mssql_connection/mssql_connection.dart';

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

  Future<String> getItemsByBarcode(String barcode) async {
    if (!_connection.isConnected) {
      throw Exception("Database connection is not initialized");
    }

    final query = """
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
      SELECT * FROM BaseItems
      WHERE Barcode = '$barcode';
    """;

    final results = await _connection.getData(query);
    return results;
  }

}