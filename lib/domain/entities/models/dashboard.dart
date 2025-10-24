/// \brief        Data model representing the operational, financial, and
///               membership summary for the dashboard screen.
/// <p>
/// \platform     Flutter:DART
/// \copyright    Power House 2025

import 'dart:convert';

class DashboardData {
  // Operational
  int? activeCheckIns;
  String? lastReceiptId;
  String? occupiedHours;

  // Financial
  double? expense;
  double? todayRevenue;
  double? todayRevenueChange;
  double? monthlyRevenue;
  double? monthlyRevenueChange;

  // Membership/Engagement
  int? totalMemberCount;
  int? activeMemberCount;
  double? attendanceRate;
  int? newMembersThisWeek;
  int? expiringMembers;

  DashboardData({
    this.activeCheckIns,
    this.lastReceiptId,
    this.occupiedHours,
    this.expense,
    this.todayRevenue,
    this.todayRevenueChange,
    this.monthlyRevenue,
    this.monthlyRevenueChange,
    this.totalMemberCount,
    this.activeMemberCount,
    this.attendanceRate,
    this.newMembersThisWeek,
    this.expiringMembers,
  });

  // 🔁 CopyWith
  DashboardData copyWith({
    int? activeCheckIns,
    String? lastReceiptId,
    String? occupiedHours,
    double? expense,
    double? todayRevenue,
    double? todayRevenueChange,
    double? monthlyRevenue,
    double? monthlyRevenueChange,
    int? totalMemberCount,
    int? activeMemberCount,
    double? attendanceRate,
    int? newMembersThisWeek,
    int? expiringMembers,
  }) {
    return DashboardData(
      activeCheckIns: activeCheckIns ?? this.activeCheckIns,
      lastReceiptId: lastReceiptId ?? this.lastReceiptId,
      occupiedHours: occupiedHours ?? this.occupiedHours,
      expense: expense ?? this.expense,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      todayRevenueChange: todayRevenueChange ?? this.todayRevenueChange,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      monthlyRevenueChange: monthlyRevenueChange ?? this.monthlyRevenueChange,
      totalMemberCount: totalMemberCount ?? this.totalMemberCount,
      activeMemberCount: activeMemberCount ?? this.activeMemberCount,
      attendanceRate: attendanceRate ?? this.attendanceRate,
      newMembersThisWeek: newMembersThisWeek ?? this.newMembersThisWeek,
      expiringMembers: expiringMembers ?? this.expiringMembers,
    );
  }

  // 🗂 Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'activeCheckIns': activeCheckIns,
      'lastReceiptId': lastReceiptId,
      'occupiedHours': occupiedHours,
      'expense': expense,
      'todayRevenue': todayRevenue,
      'todayRevenueChange': todayRevenueChange,
      'monthlyRevenue': monthlyRevenue,
      'monthlyRevenueChange': monthlyRevenueChange,
      'totalMemberCount': totalMemberCount,
      'activeMemberCount': activeMemberCount,
      'attendanceRate': attendanceRate,
      'newMembersThisWeek': newMembersThisWeek,
      'expiringMembers': expiringMembers,
    };
  }

  // 🧭 Create from Map
  factory DashboardData.fromMap(Map<String, dynamic> map) {
    return DashboardData(
      activeCheckIns: map['activeCheckIns'] ?? 0,
      lastReceiptId: map['lastReceiptId'] ?? '',
      occupiedHours: map['occupiedHours'] ?? '',
      expense: (map['expense'] ?? 0).toDouble(),
      todayRevenue: (map['todayRevenue'] ?? 0).toDouble(),
      todayRevenueChange: (map['todayRevenueChange'] ?? 0).toDouble(),
      monthlyRevenue: (map['monthlyRevenue'] ?? 0).toDouble(),
      monthlyRevenueChange: (map['monthlyRevenueChange'] ?? 0).toDouble(),
      totalMemberCount: map['totalMemberCount'] ?? 0,
      activeMemberCount: map['activeMemberCount'] ?? 0,
      attendanceRate: (map['attendanceRate'] ?? 0).toDouble(),
      newMembersThisWeek: map['newMembersThisWeek'] ?? 0,
      expiringMembers: map['expiringMembers'] ?? 0,
    );
  }

  // 🧾 Convert to JSON
  String toJson() => json.encode(toMap());

  // 📥 Create from JSON
  factory DashboardData.fromJson(String source) =>
      DashboardData.fromMap(json.decode(source));

  @override
  String toString() =>
      'DashboardData(activeCheckIns: $activeCheckIns, lastReceiptId: $lastReceiptId, occupiedHours: $occupiedHours, '
      'expense: $expense, todayRevenue: $todayRevenue, todayRevenueChange: $todayRevenueChange, '
      'monthlyRevenue: $monthlyRevenue, monthlyRevenueChange: $monthlyRevenueChange, '
      'totalMemberCount: $totalMemberCount, activeMemberCount: $activeMemberCount, attendanceRate: $attendanceRate, '
      'newMembersThisWeek: $newMembersThisWeek, expiringMembers: $expiringMembers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardData &&
        other.activeCheckIns == activeCheckIns &&
        other.lastReceiptId == lastReceiptId &&
        other.occupiedHours == occupiedHours &&
        other.expense == expense &&
        other.todayRevenue == todayRevenue &&
        other.todayRevenueChange == todayRevenueChange &&
        other.monthlyRevenue == monthlyRevenue &&
        other.monthlyRevenueChange == monthlyRevenueChange &&
        other.totalMemberCount == totalMemberCount &&
        other.activeMemberCount == activeMemberCount &&
        other.attendanceRate == attendanceRate &&
        other.newMembersThisWeek == newMembersThisWeek &&
        other.expiringMembers == expiringMembers;
  }

  @override
  int get hashCode =>
      activeCheckIns.hashCode ^
      lastReceiptId.hashCode ^
      occupiedHours.hashCode ^
      expense.hashCode ^
      todayRevenue.hashCode ^
      todayRevenueChange.hashCode ^
      monthlyRevenue.hashCode ^
      monthlyRevenueChange.hashCode ^
      totalMemberCount.hashCode ^
      activeMemberCount.hashCode ^
      attendanceRate.hashCode ^
      newMembersThisWeek.hashCode ^
      expiringMembers.hashCode;
}
