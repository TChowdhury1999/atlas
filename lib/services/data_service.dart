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

  Future<Map<String, dynamic>> _loadRawData() async {
  if (devMode) {
    final jsonStr = await rootBundle.loadString('assets/test_data.json');
    return jsonDecode(jsonStr);
  }
  
  final file = await _localFile;
  if (!await file.exists()) {
    await file.writeAsString('{}');
  }
  final jsonStr = await file.readAsString();
  return jsonDecode(jsonStr);
}

Future<List<DataEntry>> loadData(String key) async {
  try {
    final data = await _loadRawData();
    final List<dynamic> jsonList = data[key];
    return jsonList.map((e) => DataEntry.fromJson(e)).toList();
  } catch(e) {
    return [];
  }
}

  Future<void> saveData(String key, List<DataEntry> entries) async {
    final file = await _localFile;

    Map<String, dynamic> allData = {};
    if (await file.exists()) {
      allData = jsonDecode(await file.readAsString());
    }

    allData[key] = entries.map((e) => e.toJson()).toList();

    await file.writeAsString(jsonEncode(allData));
  }

  Future<List<String>> loadAvailableMetrics() async {
    try {
      final data = await _loadRawData();
      return data.keys.toList();
    } catch (e) {
      return ["error"];
    }
  }
}