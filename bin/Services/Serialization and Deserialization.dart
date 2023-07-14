import 'dart:convert';
import 'dart:io';

import '../Models/Text.dart';




Future<void> serializeToJson<T>(T object, String filePath, String arrName) async {
  final file = File(filePath);

  dynamic existingData;

  if (await file.exists()) {
    final jsonString = await file.readAsString();
    existingData = jsonDecode(jsonString);

    if (existingData is! Map) {
      throw FormatException('Invalid JSON format');
    }
  } else {
    existingData = {arrName: []};
  }


  if (!existingData.containsKey(arrName)) {
    existingData[arrName] = [];
  }

  existingData[arrName].add(object);

  final jsonEncoder = JsonEncoder.withIndent('  ');
  final jsonString = jsonEncoder.convert(existingData);

  await file.writeAsString(jsonString);
}


Future<List<T>> deserializeFromJson<T>(String filePath, String arrName) async {
  final file = File(filePath);

  if (await file.exists()) {
    final json = await file.readAsString();
    final object = jsonDecode(json);

    if (object is Map<String, dynamic>) {
      if (object.containsKey(arrName) && object[arrName] is List) {
        final itemList = (object[arrName] as List<dynamic>)
            .map((item) => _fromJson<T>(item))
            .toList();
        return itemList;
      }
    }
  }

  return [];
}

T _fromJson<T>(Map<String, dynamic> json) {
  if (T == Text) {
    return Text.fromJson(json) as T;
  }


  throw Exception('Unsupported type: $T');
}






