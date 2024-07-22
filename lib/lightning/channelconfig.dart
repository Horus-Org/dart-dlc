'package:ldk_node_package/ChannelConfig';

const ChannelConfig({
  required this.forwardingFeeProportionalMillionths,
  required this.forwardingFeeBaseMsat,
  required this.cltvExpiryDelta,
  required this.maxDustHtlcExposure,
  required this.forceCloseAvoidanceMaxFeeSatoshis,
  required this.acceptUnderpayingHtlcs,
});

class ChannelConfigBuilder {
  late int forwardingFeeProportionalMillionths;
  late int forwardingFeeBaseMsat;
  late int cltvExpiryDelta;
  late int maxDustHtlcExposure;
  late int forceCloseAvoidanceMaxFeeSatoshis;
  late bool acceptUnderpayingHtlcs;
}

  ChannelConfigBuilder({
    required this.forwardingFeeProportionalMillionths,
    required this.forwardingFeeBaseMsat,
    required this.cltvExpiryDelta,
    required this.maxDustHtlcExposure,
    required this.forceCloseAvoidanceMaxFeeSatoshis,
    required this.acceptUnderpayingHtlcs,
  });

class ChannelConfigBuilder {
  late int forwardingFeeProportionalMillionths;
  late int forwardingFeeBaseMsat;
  late int cltvExpiryDelta;
  late int maxDustHtlcExposure;
  late int forceCloseAvoidanceMaxFeeSatoshis;
  late bool acceptUnderpayingHtlcs;