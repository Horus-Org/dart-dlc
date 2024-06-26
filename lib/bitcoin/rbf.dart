export 'package:bitcoin/bitcoin.dart';
export 'package:bitcoin/src/utils.dart';
export 'package:bitcoin/src/models/networks.dart';

impl RBF {
  static const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl Transaction {
  static const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl TransactionInput {
  static const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl TransactionOutput {
  static const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl BumpFee {
  static const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl TransactionBuilder {
  static const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}

