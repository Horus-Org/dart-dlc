import 'dart:typed_data';
import 'package:bitcoin_dart/bitcoin.dart';

class DLCMessaging {
  static Uint8List toWire(int type, Uint8List msg) {
    Uint8List serializedType = BitcoinexUtils.binary.bigSize(type, 16);
    Uint8List serializedMsg = ExFactoUtils.withBigSize(msg);
    return Uint8List.fromList([0xFD]) + serializedType + serializedMsg;
  }

  static Map<String, dynamic> fromWire(Uint8List msg) {
    Uint8List typeBytes = msg.sublist(1, 3); // Assuming type is stored as a u16
    int type = BitcoinexUtils.binary.bigSizeDecode(typeBytes, 16);
    Uint8List remainingMsg = msg.sublist(3);
    Map<String, dynamic> counterData = ExFactoUtils.parseCompactSizeValue(remainingMsg);
    Uint8List parsedMsg = counterData['value'];
    Uint8List rest = counterData['remaining'];
    return {'type': type, 'msg': parsedMsg, 'rest': rest};
  }

  static Map<String, dynamic> fromTlv(int type, Uint8List msg) {
    Uint8List typeBytes = BitcoinexUtils.binary.bigSize(type, 16);
    Map<String, dynamic> counterData = ExFactoUtils.getCounter(msg);
    return {'type': type, 'msg': counterData['vec']};
  }

  static Uint8List toTlv(int type, Uint8List data) {
    Uint8List serializedType = BitcoinexUtils.binary.bigSize(type, 16);
    Uint8List serializedData = ExFactoUtils.withBigSize(data);
    return serializedType + serializedData;
  }

  static Uint8List serBool(bool value) {
    return Uint8List.fromList([value ? 0x01 : 0x00]);
  }

  static Uint8List serUInt8(int value) {
    return BitcoinexUtils.binary.bigSize(value, 8);
  }

  static Uint8List serUInt16(int value) {
    return BitcoinexUtils.binary.bigSize(value, 16);
  }

  static Uint8List serUInt32(int value) {
    return BitcoinexUtils.binary.bigSize(value, 32);
  }

  static Uint8List serUInt64(int value) {
    return BitcoinexUtils.binary.bigSize(value, 64);
  }

  static Uint8List serUInt256(Uint8List value) {
    return Uint8List.fromList(value);
  }

  static Uint8List serUtf8(String value) {
    if (value.isEmpty) {
      return Uint8List.fromList([0x00]);
    } else {
      Uint8List normalizedValue = value.normalize();
      return ExFactoUtils.withBigSize(normalizedValue);
    }
  }

  static Uint8List serScript(BitcoinexScript script) {
    return ExFactoUtils.scriptWithBigSize(script);
  }

  static Uint8List serPoint(Uint8List pk) {
    return pk;
  }

  static Uint8List serSignature(Uint8List sig) {
    return sig;
  }

  static Uint8List serializeEnumeratedContractDescriptor(List<Map<String, dynamic>> outcomes) {
    List<Uint8List> serializedOutcomes = outcomes
        .map((outcome) =>
            serUtf8(outcome['data']) + serUInt64(outcome['payout']))
        .toList();
    Map<String, dynamic> serializedData = ExFactoUtils.serializeWithCount(serializedOutcomes, (item) => item);
    Uint8List serializedOutcomesData = serializedData['acc'];
    return ExFactoUtils.withBigSize(serializedData['count']) + serializedOutcomesData;
  }

  static Uint8List serializeCetAdaptorSignatures(List<Map<String, dynamic>> cetAdaptorSignatures) {
    List<Uint8List> serializedSignatures = cetAdaptorSignatures
        .map((cas) => serSignature(cas['adaptor_signature']) + serBool(cas['was_negated']))
        .toList();
    Map<String, dynamic> serializedData = ExFactoUtils.serializeWithCount(serializedSignatures, (item) => item);
    Uint8List serializedSignaturesData = serializedData['acc'];
    return ExFactoUtils.withBigSize(serializedData['count']) + serializedSignaturesData;
  }

  static Uint8List serializeFundingInputs(List<Map<String, dynamic>> inputs) {
    List<Uint8List> serializedInputs = inputs
        .map((input) =>
            serTransaction(input['prev_tx']) +
            serUInt32(input['prev_vout']) +
            serUInt32(input['sequence']) +
            serUInt16(input['max_witness_len']) +
            serScript(input['redeem_script']))
        .toList();
    Map<String, dynamic> serializedData = ExFactoUtils.serializeWithCount(serializedInputs, (item) => item);
    Uint8List serializedInputsData = serializedData['acc'];
    return ExFactoUtils.withBigSize(serializedData['count']) + serializedInputsData;
  }

  static Uint8List serializeFundingWitnesses(List<Map<String, dynamic>> witnesses) {
    Uint8List serializedWitnesses = BitcoinexTransaction.Witness.serializeWitness(witnesses);
    return ExFactoUtils.withBigSize(witnesses.length) + serializedWitnesses;
  }

  static Uint8List serializeEnumEventDescriptor(List<String> outcomes) {
    Map<String, dynamic> serializedData = ExFactoUtils.serializeWithCount(outcomes, (item) => serUtf8(item));
    Uint8List serializedOutcomesData = serializedData['acc'];
    return serUInt16(serializedData['count']) + serializedOutcomesData;
  }

  static Map<String, dynamic> parseCetAdaptorSignatures(Uint8List msg) {
    Map<String, dynamic> counterData = ExFactoUtils.getCounter(msg);
    int cetAdaptorSigCt = counterData['counter'];
    Uint8List remainingMsg = counterData['vec'];
    return parseItems(remainingMsg, cetAdaptorSigCt, [], parseCetAdaptorSignature);
  }

  static Map<String, dynamic> parseCetAdaptorSignature(Uint8List msg) {
    Uint8List sig = msg.sublist(0, 64);
    Uint8List remainingMsg = msg.sublist(64);
    Map<String, dynamic> wasNegatedData = par(remainingMsg, 'bool');
    bool wasNegated = wasNegatedData['value'];
    remainingMsg = wasNegatedData['remaining'];
    return {
      'adaptor_signature': sig,
      'was_negated': wasNegated,
      'remaining': remainingMsg,
    };
  }

  static Map<String, dynamic> parseItems(Uint8List msg, int count, List<dynamic> items, Function(Uint8List) parseFunc) {
    if (count == 0) {
      return {
        'items': items.reversed.toList(),
        'remaining': msg,
      };
    } else {
      Map<String, dynamic> parsedData = parseFunc(msg);
      Uint8List parsedItem = parsedData['remaining'];
      items.add(parsedData['parsed']);
      return parseItems(parsedItem, count - 1, items, parseFunc);
    }
  }

  static Map<String, dynamic> parseFundingInputs(Uint8List msg) {
    Map<String, dynamic> counterData = ExFactoUtils.getCounter(msg);
    int inputCt = counterData['counter'];
    Uint8List remainingMsg = counterData['vec'];
    return parseFundingInputsHelper(remainingMsg, inputCt, []);
  }

  static Map<String, dynamic> parseFundingInputsHelper(Uint8List msg, int count, List<dynamic> inputs) {
    if (count == 0) {
      return {
        'inputs': inputs.reversed.toList(),
        'remaining': msg,
      };
    } else {
      Map<String, dynamic> parsedInput = parseFundingInput(msg);
      Uint8List remainingInput = parsedInput['remaining'];
      inputs.add(parsedInput['input']);
      return parseFundingInputsHelper(remainingInput, count - 1, inputs);
    }
  }

  static Map<String, dynamic> parseFundingInput(Uint8List msg) {
    Map<String, dynamic> prevTxData = ExFactoUtils.parseCompactSizeValue(msg);
    Uint8List remainingMsg = prevTxData['remaining'];
    Map<String, dynamic> prevTxParse = BitcoinexTransaction.Utils.parse(prevTxData['value']);
    BitcoinexTransaction tx = prevTxParse['parsed'];
    Uint8List remainingVoutData = par(remainingMsg, 'u32');
    int prevVout = remainingVoutData['value'];
    remainingMsg = remainingVoutData['remaining'];
    Uint8List remainingSeqData = par(remainingMsg, 'u32');
    int sequence = remainingSeqData['value'];
    remainingMsg = remainingSeqData['remaining'];
    Uint8List remainingWitnessLenData = par(remainingMsg, 'u16');
    int maxWitnessLen = remainingWitnessLenData['value'];
    remainingMsg = remainingWitnessLenData['remaining'];
    Map<String, dynamic> redeemScriptData = par(remainingMsg, 'script');
    BitcoinexScript redeemScript = redeemScriptData['value'];
    remainingMsg = redeemScriptData['remaining'];
    return {
      'input': {
        'prev_tx': tx,
        'prev_vout': prevVout,
        'sequence': sequence,
        'max_witness_len': maxWitnessLen,
        'redeem_script': redeemScript,
      },
      'remaining': remainingMsg,
    };
  }
  
  // Other parsing functions follow in a similar pattern
}
