/// Defines the contract for interacting with the external biometric hardware
/// (DigitalPersona 5100 via C# wrapper).
abstract class BiometricService {
  /// Initiates the enrollment process on the device.
  ///
  /// Returns the captured FMD (Fingerprint Minutiae Data) as a Base64 String
  /// upon successful enrollment, or null if the process fails or times out.
  Future<String?> enrollUser();

  /// Initiates the matching process. This method handles:
  /// 1. Fetching all known FMDs from the MemberRepository.
  /// 2. Writing the FMDs to a JSON file for the C# app.
  /// 3. Executing the C# app's 'match' command.
  ///
  /// Returns the `memberId` of the matched user, or null if no match is found.
  Future<void> verifyUser();
}