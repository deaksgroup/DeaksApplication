class DisplaySlot {
  final String slotId;
  final String outletId;
  final String outletName;
  final List<dynamic> outletImages;
  final List<dynamic> groomingImages;
  final List<dynamic> hoeToImages;
  final String adminNumber;
  final String youtubeLink;
  final String jobRemarks;
  final String paymentDetails;
  final String hotelId;
  final String hotelName;
  final String hotelLogo;
  final String longitude;
  final String latitude;
  final String date;
  final String startTime;
  final String endTime;
  final String payPerHour;
  final String totalPay;
  final String slotStatus;
  final String priority;

  DisplaySlot(
      {required this.slotId,
      required this.jobRemarks,
      required this.outletId,
      required this.outletName,
      required this.paymentDetails,
      required this.outletImages,
      required this.groomingImages,
      required this.hoeToImages,
      required this.adminNumber,
      required this.youtubeLink,
      required this.hotelId,
      required this.hotelName,
      required this.hotelLogo,
      required this.longitude,
      required this.latitude,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.payPerHour,
      required this.totalPay,
      required this.slotStatus,
      required this.priority});
}
