class DisplaySlot {
  final String slotId;
  final String outletId;
  final String outletName;
  final List<dynamic> outletImages;
  final List<dynamic> groomingImages;
  final List<dynamic> howToImages;
  final String adminNumber;
  final String youtubeLink;
  final String jobRemarks1;
  final String jobRemarks2;
  final String paymentDetails;
  final String hotelId;
  final String hotelName;
  final String hotelLogo;
  final String googleMapLink;
  final String appleMapLink;
  final String date;
  final String startTime;
  final String endTime;
  final String payPerHour;
  final String totalPay;
  final String vacancy;
  final String release;
  final List<dynamic> confirmedRequests;
  final List<dynamic> waitingListRequests;

  final String priority;

  DisplaySlot(
      {required this.slotId,
      required this.confirmedRequests,
      required this.waitingListRequests,
      required this.release,
      required this.vacancy,
      required this.jobRemarks1,
      required this.jobRemarks2,
      required this.outletId,
      required this.outletName,
      required this.paymentDetails,
      required this.outletImages,
      required this.groomingImages,
      required this.howToImages,
      required this.adminNumber,
      required this.youtubeLink,
      required this.hotelId,
      required this.hotelName,
      required this.hotelLogo,
      required this.googleMapLink,
      required this.appleMapLink,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.payPerHour,
      required this.totalPay,
      required this.priority});
}
