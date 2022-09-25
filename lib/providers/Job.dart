class Job {
  final String id;
  final String hotelName;
  final String hotelId;
  final String outletName;
  final String outletId;
  final String startTime;
  final String endTime;
  final String date;
  final String payPerHour;
  final String totalPay;
  final String priority;
  final String slotStatus;

  Job(
      {required this.date,
      required this.slotStatus,
      required this.id,
      required this.endTime,
      required this.hotelId,
      required this.hotelName,
      required this.outletId,
      required this.outletName,
      required this.payPerHour,
      required this.priority,
      required this.startTime,
      required this.totalPay});
}
