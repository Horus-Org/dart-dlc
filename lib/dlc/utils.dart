import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:bitcoin_flutter::Script';
import 'package:bitcoin_flutter::Secp256k1';

class dlcUtils {
  int protocolVersionV0 = 0;

  int getProtocolVersion() {
    return protocolVersionV0;
  }

  int newRandInt() {
    final randBytes = Utils.randomBytes(32);
    return Utils.bytesToBigInt(randBytes).toInt();
  }

  String newEventId() {
    final randBytes = Utils.randomBytes(32);
    return hex.encode(randBytes);
  }

  ECPrivateKey newPrivateKey() {
    final randInt = newRandInt();
    final privateKey = ECPrivateKey.fromBigInt(randInt);
    return Secp256k1.forceEvenY(privateKey);
  }

  Uint8List bigSize(int compactSize) {
    if (compactSize >= 0 && compactSize <= 0xFC) {
      return Uint8List.fromList([compactSize]);
    } else if (compactSize <= 0xFFFF) {
      return Uint8List.fromList([0xFD]) + Utils.encodeUint16(compactSize);
    } else if (compactSize <= 0xFFFFFFFF) {
      return Uint8List.fromList([0xFE]) + Utils.encodeUint32(compactSize);
    } else if (compactSize <= 0xFF) {
      return Uint8List.fromList([0xFF]) + Utils.encodeUint64(compactSize);
    } else {
      throw Exception('Invalid compactSize value');
    }
  }

  Map<String, dynamic> getCounter(Uint8List data) {
    final counter = data[0];
    Uint8List vec = data.sublist(1);
    if (counter == 0xFD) {
      final len = Utils.decodeUint16(vec);
      vec = vec.sublist(2);
      return {'len': len, 'vec': vec};
    } else if (counter == 0xFE) {
      final len = Utils.decodeUint32(vec);
      vec = vec.sublist(4);
      return {'len': len, 'vec': vec};
    } else if (counter == 0xFF) {
      final len = Utils.decodeUint64(vec);
      vec = vec.sublist(8);
      return {'len': len, 'vec': vec};
    } else {
      return {'counter': counter, 'vec': vec};
    }
  }

  Map<String, dynamic> parseCompactSizeValue(Uint8List msg) {
    final counterResult = getCounter(msg);
    final len = counterResult['len'];
    Uint8List value = counterResult['vec'].sublist(0, len);
    Uint8List remaining = counterResult['vec'].sublist(len);
    return {'value': value, 'remaining': remaining};
  }

  Uint8List withBigSize(Uint8List data) {
    final size = bigSize(data.length);
    return Uint8List.fromList([...size, ...data]);
  }

  Uint8List scriptWithBigSize(Script script) {
    final serializedScript = script.serializeScript();
    return withBigSize(serializedScript);
  }

  Map<String, dynamic> serializeWithCount(List items, Function serializeFunc) {
    int count = 0;
    Uint8List acc = Uint8List(0);
    items.forEach((item) {
      final serializedItem = serializeFunc(item);
      count += 1;
      acc = Uint8List.fromList([...acc, ...serializedItem]);
    });
    return {'count': count, 'binary': acc};
  }

  int oracleTaggedHash(Uint8List msg, String tag) {
    final taggedHash = Utils.taggedHash('DLC/oracle/$tag', msg);
    return Utils.bytesToBigInt(taggedHash).toInt();
  }

  Uint8List contractorTaggedHash(Uint8List msg, String tag) {
    return Utils.taggedHash('DLC/contractor/$tag', msg);
  }

  String binToHex(Uint8List data) {
    return hex.encode(data);
  }

  Uint8List hexToBin(String data) {
    return Uint8List.fromList(hex.decode(data));
  }

  Uint8List hexToBinEx(String data) {
    return hex.decode(data);
  }
}
