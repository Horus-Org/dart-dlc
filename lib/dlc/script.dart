
import 'ECDSA.dart';

void main(dynamic scriptMessage) {
  final privateKey = Uint8List.fromList([/* your private key bytes */]);
  final message = Uint8List.fromList([/* your message bytes */]);
  final signature = signMessage(privateKey, message);                                     
  // ignore: unused_local_variable
  final script = scriptMessage;

  print('Signature: ${signature.toHexString()}');
}

class Uint8List {
  static fromList(List list) {}
}
