import 'package:bitcoin_flutter/bitcoin_flutter.dart';

void main() {

  //Bitcoin Network
  BitcoinNetwork = BitcoinNetwork.testnet();

  // Generate private key and corresponding public key
  ECPrivateKey privateKey = ECPrivateKey.generate();
  ECPublicKey publicKey = privateKey.publicKey;

  print('Private Key: ${privateKey.toHex()}');
  print('Public Key: ${publicKey.toHex()}');

  // Simulate an oracle providing an outcome
  String oracleOutcome = 'Heads';
  DateTime timestamp = DateTime.now();
  String announcementMessage = '$oracleOutcome-$timestamp';

  // Oracle signs the announcement message
  String oraclePrivateKeyHex = 'oracle_private_key_in_hex';
  ECPrivateKey oraclePrivateKey = ECPrivateKey.fromHex(oraclePrivateKeyHex);
  ECSignature oracleSignature = privateKey.sign(Uint8List.fromList(announcementMessage.codeUnits));

  print('Oracle Announcement: $announcementMessage');
  print('Oracle Signature: ${oracleSignature.toHex()}');
}

