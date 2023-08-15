import 'dart:typed_data';

class Builder {
  // Constants
  static final int txVersion = 2;
  static final int defaultSequence = 0xFFFFFFFE;
  static final int defaultLocktime = 0;
  static final int defaultCetHashType = 0x00;

  static Map<String, dynamic> newOutput(int value, String scriptPubKey) {
    return {
      'value': value,
      'script_pub_key': scriptPubKey,
    };
  }

  static Map<String, dynamic> buildFundingTx(
      List<Map<String, dynamic>> inputs,
      Map<String, dynamic> fundingOutput,
      List<Map<String, dynamic>> changeOutputs) {
    // Sorting outputs and finding funding vout
    List<Map<String, dynamic>> outputs = _lexicographicalSortOutputs([fundingOutput, ...changeOutputs]);
    int fundingVout = outputs.indexWhere((output) => output == fundingOutput);

    // Building and sorting inputs
    List<Map<String, dynamic>> txInputs = inputs
        .map((input) => _fundingInputToTxIn(input))
        .toList();
    _lexicographicalSortInputs(txInputs);

    Map<String, dynamic> fundingTx = {
      'version': txVersion,
      'inputs': txInputs,
      'outputs': outputs,
      'lock_time': defaultLocktime,
    };

    Uint8List fundingTxid = _calculateTransactionId(fundingTx);

    // Settlement txin used as single input to CETs & Refund tx
    Map<String, dynamic> settlementTxin = _buildSettlementTxin(fundingTxid, fundingVout);

    return {
      'funding_tx': fundingTx,
      'settlement_txin': settlementTxin,
    };
  }

  static Map<String, dynamic> _fundingInputToTxIn(Map<String, dynamic> inputInfo) {
    String redeemScript = inputInfo['redeem_script'] ?? '';

    return {
      'prev_txid': _calculateTransactionId(inputInfo['prev_tx']),
      'prev_vout': inputInfo['prev_vout'],
      'script_sig': redeemScript,
      'sequence_no': inputInfo['sequence'],
    };
  }

  static Map<String, dynamic> _buildSettlementTxin(Uint8List fundingTxid, int fundingVout) {
    return {
      'prev_txid': fundingTxid,
      'prev_vout': fundingVout,
      'script_sig': '',
      'sequence_no': defaultSequence,
    };
  }

  static Uint8List _calculateTransactionId(Map<String, dynamic> transaction) {
    // Implement the logic to calculate the transaction ID
    // This involves serializing and hashing the transaction
    // Return the calculated transaction ID as a Uint8List
    // Replace the following line with your implementation
    return Uint8List(32);
  }

  static List<Map<String, dynamic>> _lexicographicalSortOutputs(List<Map<String, dynamic>> outputs) {
    // Implement the logic to lexicographically sort the outputs
    // Return the sorted list of outputs
    // Replace the following line with your implementation
    return outputs;
  }

  static void _lexicographicalSortInputs(List<Map<String, dynamic>> inputs) {
    // Implement the logic to lexicographically sort the inputs in-place
    // Replace the following line with your implementation
    inputs.sort((a, b) {
      // Compare inputs based on the sorting criteria
      return 0;
    });
  }

  // Other methods...
}

void main() {
  // You can use the ExFactoBuilder class and its methods here
}
