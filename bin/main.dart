import 'dart:convert';
import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';

import 'Helpers/Lorem Ipsum Text.dart';
import 'Models/Text.dart';
import 'Services/Encrypt and Decrypt Text.dart';
import 'Services/Serialization and Deserialization.dart';

var uuid = Uuid();

String? Get_id;

Future<void> TextCreateFunction() async {
  String myString = '';
  String readyText = await myString.Readytext();

  Text<String, DateTime> text = Text(uuid.v4(), readyText, DateTime.now());

  await serializeToJson(text, './Files/Text/text.json', 'texts');
  Get_id = text.getId;

  final updatedTexts = await deserializeFromJson<Text<String, DateTime>>(
    './Files/Text/text.json',
    'texts',
  );

  String style = '{\n "todos": [      ';
  print(style);

  for (var i = 0; i < updatedTexts.length; i++) {
    var todo = updatedTexts[i];
    if (todo.getId == Get_id) {
      print("\t{");
      print("\t\tid: ${todo.getId},");
      print("\t\ttext: ${todo.getText},");
      print("\t\treleaseDate: ${todo.getReleaseDate},");
      print("\t}${i != updatedTexts.length - 1 ? ',' : ''}");
    }
  }

  String style2 = '  ]\n}';
  print(style2);
}

Future<SecretBox> CiphersEncrypt() async {
  String myString = '';
  String readyText = await myString.Readytext();

  await AesCbc_algorithmFuctiom();

  List<int> encryptedText = await AesCbc_Encrypt(utf8.encode(readyText));

  String encryptedString = String.fromCharCodes(encryptedText);

  Text<String, DateTime> text =
      Text(uuid.v4(), encryptedString, DateTime.now());

  await serializeToJson(text, './Files/Text/textCiphers_encrypt.json', 'texts');
  String? getTextId = text.getId;

  final updatedTexts = await deserializeFromJson<Text<String, DateTime>>(
    './Files/Text/textCiphers_encrypt.json',
    'texts',
  );

  String style = '{\n "todos": [      ';
  print(style);

  for (var i = 0; i < updatedTexts.length; i++) {
    var todo = updatedTexts[i];
    if (todo.getId == getTextId) {
      print("\t{");
      print("\t\tid: ${todo.getId},");
      print("\t\ttext: ${todo.getText},");
      print("\t\treleaseDate: ${todo.getReleaseDate},");
      print("\t}${i != updatedTexts.length - 1 ? ',' : ''}");
    }
  }

  String style2 = '  ]\n}';
  print(style2);

  return secretBox;
}

Future<void> CiphersDecrypt(SecretBox secretBox) async {
  try {
    String decryptedString =
        await AesCbc_Decrypt(secretBox.cipherText, secretBox.mac.bytes);

    Text<String, DateTime> text =
        Text(uuid.v4(), decryptedString, DateTime.now());

    await serializeToJson(
        text, './Files/Text/textCiphers_decrypt.json', 'texts');
    String? getTextId = text.getId;

    final updatedTexts = await deserializeFromJson<Text<String, DateTime>>(
      './Files/Text/textCiphers_decrypt.json',
      'texts',
    );

    String style = '{\n "todos": [      ';
    print(style);

    for (var i = 0; i < updatedTexts.length; i++) {
      var todo = updatedTexts[i];
      if (todo.getId == getTextId) {
        print("\t{");
        print("\t\tid: ${todo.getId},");
        print("\t\ttext: ${todo.getText},");
        print("\t\treleaseDate: ${todo.getReleaseDate},");
        print("\t}${i != updatedTexts.length - 1 ? ',' : ''}");
      }
    }

    String style2 = '  ]\n}';
    print(style2);
  } catch (error) {
    throw Exception('Decryption error: $error');
  }
}

String red(String text) {
  final redColor = '\u001b[31m';

  final resetColor = '\u001b[0m';

  return '$redColor$text$resetColor';
}

Future<void> main() async {
  var FilesfolderName = './Files';
  var TextfolderName = './Files/Text';

  var Filesfolder = Directory(FilesfolderName);
  var Textfolder = Directory(TextfolderName);

  Filesfolder.create().then((Directory newFolder) {}).catchError((error) {
    print('Failed to create folder: $error');
  });

  Textfolder.create().then((Directory newFolder) {}).catchError((error) {
    print('Failed to create folder: $error');
  });

  bool isRunning = true;

  while (isRunning) {
    print('Menu:');
    print('1. Ciphers');
    print('0. Exit');

    stdout.write('\n Enter your choice: ');
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print('\n ${red('Orginal text\n')}');

        await TextCreateFunction();

        print('\n ${red('Encrypt text\n')}');

        var secretBox = await CiphersEncrypt();

        print('\n ${red('Decrypt text\n')}');

        await Future.delayed(Duration(seconds: 1));
        await CiphersDecrypt(secretBox);

        break;

      case '0':
        print('Exiting...');
        isRunning = false;
        exit(0);

      default:
        print('Invalid choice. Please try again.');
        break;
    }
  }
}
