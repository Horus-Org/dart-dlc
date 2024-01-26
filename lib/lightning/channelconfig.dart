'package:ldk_node_package/ChannelConfig';

const ChannelConfig({
  required this.forwardingFeeProportionalMillionths,
  required this.forwardingFeeBaseMsat,
  required this.cltvExpiryDelta,
  required this.maxDustHtlcExposure,
  required this.forceCloseAvoidanceMaxFeeSatoshis,
  required this.acceptUnderpayingHtlcs,
});
