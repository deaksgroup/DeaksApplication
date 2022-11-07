class Slot {
  final String id;

  final Map<dynamic, dynamic> hotel;
  final Map<dynamic, dynamic> outlet;

  final String startTime;
  final String endTime;
  final String date;
  final String hourlyPay;
  final String totalPayForSlot;
  final String priority;
  final String vacancy;
  final String release;
  final String jobRemarks;
  final List<dynamic> confirmedRequests;
  final List<dynamic> waitingRequests;

  Slot({
    required this.hotel,
    required this.confirmedRequests,
    required this.waitingRequests,
    required this.endTime,
    required this.hourlyPay,
    required this.totalPayForSlot,
    required this.vacancy,
    required this.release,
    required this.jobRemarks,
    required this.date,
    required this.id,
    required this.outlet,
    required this.priority,
    required this.startTime,
  });
}
