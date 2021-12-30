import 'package:gsheets/gsheets.dart';
import 'package:nodd/scj_number.dart';

class NumberManager {
  final String _credentials;
  final String _spreadsheetId;
  late GSheets _gsheets;
  Spreadsheet? _rawSpreadsheet;
  Worksheet? _rawWorksheet;
  Map<String, String>? _members;
  NumberManager(this._credentials, this._spreadsheetId) {
    _gsheets = GSheets(_credentials);
  }
  Future<Spreadsheet> get _spreadsheet async {
    return _rawSpreadsheet ??= await _gsheets.spreadsheet(_spreadsheetId);
  }

  Future<Worksheet> get _worksheet async {
    return _rawWorksheet ??= (await _spreadsheet).worksheetByTitle('Nodd2') ??
        await (await _spreadsheet).addWorksheet('Nodd2');
  }

  Future<Map<String, String>> get members async {
    return _members ??=
        await (await _worksheet).values.map.column(2, fromRow: 2);
  }

  Future<bool> registered(int id) async =>
      (await members).containsKey(id.toString());

  Future<bool> assigned(int number) async =>
      (await members).containsValue(number.toString());

  Future<int> register(int id) async {
    _members = await members;
    if (await registered(id)) {
      return int.parse(_members![id.toString()]!);
    }
    var newNumber = scjNumber(id);
    for (int i = 1; await assigned(newNumber); i++) {
      newNumber = scjNumber(id + i);
    }
    _members![id.toString()] = newNumber.toString();
    await (await _worksheet).values.map.insertColumn(2, _members!,
        fromRow: 2, appendMissing: true, overwrite: true);
    return newNumber;
  }
}
