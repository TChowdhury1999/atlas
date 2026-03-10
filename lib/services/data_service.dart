import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:atlas/models/data_entry.dart';

class DataService {
  static const bool devMode = true; // flip to false for prod

  Future<File> get _localFile async{
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/data.json');
  }

  Future<List<DataEntry>> loadData() async {
    if (devMode) {
      final jsonStr = await rootBundle.loadString('assets/test_data.json');
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList.map((e) => DataEntry.fromJson(e)).toList();
    }

    try {
      final file = await _localFile;
      if (!await file.exists()) {
        await file.writeAsString('[]');
        return [];
      }
      final jsonStr = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList.map((e) => DataEntry.fromJson(e)).toList();
    } catch(e) {
      return [];
    }
  }

  Future<void> saveData(List<DataEntry> entries) async {
    final file = await _localFile;
    final jsonStr = jsonEncode(entries.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonStr);
  }
}