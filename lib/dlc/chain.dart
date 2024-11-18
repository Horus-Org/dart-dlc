import 'dart:typed_data';
import 'package:dart_bitcoin';

class Chain {
  static Uint8List chainHash(String network) {
    if (network == 'mainnet') {
      final mainnetHashHex =
          '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f';
      return hexToBytes(mainnetHashHex);
    } else if (network == 'testnet') {
      final testnetHashHex =
          '000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943';
      return hexToBytes(testnetHashHex);
    } else {
      throw ArgumentError('Invalid network: $network');
    }
  }

  static Uint8List hexToBytes(String hexString) {
    final cleanHexString = hexString.replaceAll(RegExp(r'[^a-fA-F0-9]'), '');
    final byteCount = cleanHexString.length ~/ 2;
    final bytes = List<int>.generate(byteCount, (i) {
      final start = i * 2;
      return int.parse(cleanHexString.substring(start, start + 2), radix: 16);
    });
    return Uint8List.fromList(bytes);
  }
}

void main() {
  String network = 'mainnet'; // Replace with 'testnet' if needed
  Uint8List hash = ExFactoChain.chainHash(network);
  print('Chain Hash: ${hash}');
}

class ExFactoChain {
  static Uint8List chainHash(String network) {
    if (network == 'mainnet') {
      final mainnetHashHex =
          '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f';
      return hexToBytes(mainnetHashHex);
    } else if (network == 'testnet') {
      final testnetHashHex =
          '000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943';
      return hexToBytes(testnetHashHex);
    } else {
      throw ArgumentError('Invalid network: $network');
    }
  }}
