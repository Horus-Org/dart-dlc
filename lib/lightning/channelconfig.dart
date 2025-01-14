'package:ldk_node_package/ChannelConfig';

class ChannelConfig {
  final int forwardingFeeProportionalMillionths;
  final int forwardingFeeBaseMsat;
  final int cltvExpiryDelta;
  final int maxDustHtlcExposure;
  final int forceCloseAvoidanceMaxFeeSatoshis;
  final bool acceptUnderpayingHtlcs;

  ChannelConfig({
    required this.forwardingFeeProportionalMillionths,
    required this.forwardingFeeBaseMsat,
    required this.cltvExpiryDelta,
    required this.maxDustHtlcExposure,
    required this.forceCloseAvoidanceMaxFeeSatoshis,
    required this.acceptUnderpayingHtlcs,
  });
}

class ChannelConfigBuilder {
  int forwardingFeeProportionalMillionths = 0;
  int forwardingFeeBaseMsat = 0;
  int cltvExpiryDelta = 0;
  int maxDustHtlcExposure = 0;
  int forceCloseAvoidanceMaxFeeSatoshis = 0;
  bool acceptUnderpayingHtlcs = false;

  ChannelConfigBuilder();

  ChannelConfigBuilder setForwardingFeeProportionalMillionths(int value) {
    forwardingFeeProportionalMillionths = value;
    return this;
  }

  ChannelConfigBuilder setForwardingFeeBaseMsat(int value) {
    forwardingFeeBaseMsat = value;
    return this;
  }

  ChannelConfigBuilder setCltvExpiryDelta(int value) {
    cltvExpiryDelta = value;
    return this;
  }

  ChannelConfigBuilder setMaxDustHtlcExposure(int value) {
    maxDustHtlcExposure = value;
    return this;
  }

  ChannelConfigBuilder setForceCloseAvoidanceMaxFeeSatoshis(int value) {
    forceCloseAvoidanceMaxFeeSatoshis = value;
    return this;
  }

  ChannelConfigBuilder setAcceptUnderpayingHtlcs(bool value) {
    acceptUnderpayingHtlcs = value;
    return this;
  }

  ChannelConfig build() {
    return ChannelConfig(
      forwardingFeeProportionalMillionths: forwardingFeeProportionalMillionths,
      forwardingFeeBaseMsat: forwardingFeeBaseMsat,
      cltvExpiryDelta: cltvExpiryDelta,
      maxDustHtlcExposure: maxDustHtlcExposure,
      forceCloseAvoidanceMaxFeeSatoshis: forceCloseAvoidanceMaxFeeSatoshis,
      acceptUnderpayingHtlcs: acceptUnderpayingHtlcs,
    );
  }
}
