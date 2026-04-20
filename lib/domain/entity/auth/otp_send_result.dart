import 'package:json_annotation/json_annotation.dart';

part 'otp_send_result.g.dart';

@JsonSerializable()
class OtpSendResult {
  final String nonce;

  const OtpSendResult({required this.nonce});

  factory OtpSendResult.fromJson(Map<String, dynamic> json) =>
      _$OtpSendResultFromJson(json);

  Map<String, dynamic> toJson() => _$OtpSendResultToJson(this);
}
