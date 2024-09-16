export 'package:bitcoin/bitcoin.dart';
export 'package:bitcoin/src/utils.dart';
export 'package:bitcoin/src/models/networks.dart';

impl RBF {
  const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl Transaction {
  const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl TransactionInput {
  const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl TransactionOutput {
  const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl BumpFee {
  const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}
impl TransactionBuilder {
  const int DEFAULT_RBF_SEQUENCE = 0xfffffffd;
}

