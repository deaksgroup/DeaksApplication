class Outlet {
  final String outletName;
  final String id;
  final String hotelName;
  final String hotelId;
  final List<dynamic> outletImages;
  final List<dynamic> groomingImages;
  final List<dynamic> howToImages;
  final String jobRemarks;
  final String adminNumber;
  final String youtubeLink;
  final String paymentDescription;

  Outlet(
      {required this.outletName,
      required this.id,
      required this.hotelName,
      required this.hotelId,
      required this.outletImages,
      required this.groomingImages,
      required this.howToImages,
      required this.jobRemarks,
      required this.adminNumber,
      required this.youtubeLink,
      required this.paymentDescription});
}
