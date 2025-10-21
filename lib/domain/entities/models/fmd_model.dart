import 'dart:convert';

/// A lightweight model used to pass minimal member and fingerprint data
/// to the external C# matching application.
///
/// OPTIMIZATION: Removed 'name' field as it is not required for matching.
class FmdData {
  final String memberId;
  final String fmdBase64;

  FmdData({
    required this.memberId,
    required this.fmdBase64,
  });

  /// Converts the model to the JSON structure expected by the C# application.
  /// The C# app should now expect only 'member_id' and 'fmd_base64'.
  Map<String, dynamic> toJson() => {
    "member_id": memberId,
    "fmd_base64": fmdBase64,
  };
}
