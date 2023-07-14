import 'dart:convert';
import 'package:cryptography/cryptography.dart';

var algorithm;
var secretKey;
var nonce;
var secretBox;
var clearText;

Future<void> AesCbc_algorithmFuctiom() async {
  algorithm = AesCbc.with256bits(
    macAlgorithm: Hmac.sha256(),
  );
  secretKey = await algorithm.newSecretKey();
  nonce = algorithm.newNonce();
}

Future<List<int>> AesCbc_Encrypt(List<int> message) async {
  final paddedMessage = padPKCS7(message, 16);

  secretBox = await algorithm.encrypt(
    paddedMessage,
    secretKey: secretKey,
    nonce: nonce,
  );

  return secretBox.cipherText;
}

Future<String> AesCbc_Decrypt(List<int> cipherText, List<int> macBytes) async {
  try {
    var decryptedBytes = await algorithm.decrypt(
      SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes)),
      secretKey: secretKey,
    );

    var unpaddedBytes = unpadPKCS7(decryptedBytes);

    var clearText = utf8.decode(unpaddedBytes, allowMalformed: true);
    return clearText;
  } catch (error) {
    throw Exception('Decryption error: $error');
  }
}

List<int> padPKCS7(List<int> data, int blockSize) {
  final paddingLength = blockSize - (data.length % blockSize);
  final paddingValue = paddingLength.toRadixString(16).padLeft(2, '0');
  final padding =
      List<int>.filled(paddingLength, int.parse(paddingValue, radix: 16));
  return data + padding;
}

List<int> unpadPKCS7(List<int> paddedData) {
  final paddingLength = paddedData.last;
  return paddedData.sublist(0, paddedData.length - paddingLength);
}
