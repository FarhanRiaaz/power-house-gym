/// Defines the various user roles for authentication and access control.
enum UserRole {
  /// Has full system access, including financials, data utilities, and all member data.
  superAdmin,

  /// Can only access and manage member data where gender is male.
  maleAdmin,

  /// Can only access and manage member data where gender is female.
  femaleAdmin,
}

/// Defines the gender used for data segregation and UI theming.
enum Gender {
  male,
  female,
}

enum MemberShipType{
  cardio,
  muscle
}

/// Defines the payment status of a member.
enum FeesStatus {
  paid,
  overdue,
  unregistered,
}