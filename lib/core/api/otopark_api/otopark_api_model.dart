class ParkingModel {
  final String status;
  final String provider;
  final String name;
  final String ufid;
  final String address;
  final bool isPaid;
  final bool nonstop;
  final double lat;
  final double lng;
  final Accessibility accessibility;
  final Accessories accessories;
  final Payment payment;
  final OpeningHours openingHours;
  final Poi poi;
  final Occupancy occupancy;

  ParkingModel({
    required this.status,
    required this.provider,
    required this.name,
    required this.ufid,
    required this.address,
    required this.isPaid,
    required this.nonstop,
    required this.lat,
    required this.lng,
    required this.accessibility,
    required this.accessories,
    required this.payment,
    required this.openingHours,
    required this.poi,
    required this.occupancy,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    return ParkingModel(
      status: json['status'],
      provider: json['provider'],
      name: json['name'],
      ufid: json['ufid'],
      address: json['address'] ?? '',
      isPaid: json['isPaid'],
      nonstop: json['nonstop'],
      lat: json['lat'],
      lng: json['lng'],
      accessibility: Accessibility.fromJson(json['accessibility']),
      accessories: Accessories.fromJson(json['accessories']),
      payment: Payment.fromJson(json['payment']),
      openingHours: OpeningHours.fromJson(json['openingHours']),
      poi: Poi.fromJson(json['poi']),
      occupancy: Occupancy.fromJson(json['occupancy']),
    );
  }
}

class Accessibility {
  final bool lpgAllowed;
  final bool disabled;
  final int maxLength;
  final int maxHeight;
  final int maxWidth;

  Accessibility({
    required this.lpgAllowed,
    required this.disabled,
    required this.maxLength,
    required this.maxHeight,
    required this.maxWidth,
  });

  factory Accessibility.fromJson(Map<String, dynamic> json) {
    return Accessibility(
      lpgAllowed: json['lpgAllowed'],
      disabled: json['disabled'],
      maxLength: json['maxLength'],
      maxHeight: json['maxHeight'],
      maxWidth: json['maxWidth'],
    );
  }
}

class Accessories {
  final bool covered;
  final bool barrier;
  final bool cctv;

  Accessories({
    required this.covered,
    required this.barrier,
    required this.cctv,
  });

  factory Accessories.fromJson(Map<String, dynamic> json) {
    return Accessories(
      covered: json['covered'],
      barrier: json['barrier'],
      cctv: json['cctv'],
    );
  }
}

class Payment {
  final bool cash;
  final bool card;
  final bool sms;

  Payment({
    required this.cash,
    required this.card,
    required this.sms,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      cash: json['cash'],
      card: json['card'],
      sms: json['sms'],
    );
  }
}

class OpeningHours {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  OpeningHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday'],
      friday: json['friday'],
      saturday: json['saturday'],
      sunday: json['sunday'],
    );
  }
  Map<String, String> toMap() {
    return {
      'Pazartesi': monday,
      'Salı': tuesday,
      'Çarşamba': wednesday,
      'Perşembe': thursday,
      'Cuma': friday,
      'Cumartesi': saturday,
      'Pazar': sunday,
    };
  }
}

class Poi {
  final bool metroStation;
  final bool trainStation;
  final bool busStation;
  final bool tramStation;

  Poi({
    required this.metroStation,
    required this.trainStation,
    required this.busStation,
    required this.tramStation,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      metroStation: json['metroStation'],
      trainStation: json['trainStation'],
      busStation: json['busStation'],
      tramStation: json['tramStation'],
    );
  }
}

class Occupancy {
  final Total total;

  Occupancy({
    required this.total,
  });

  factory Occupancy.fromJson(Map<String, dynamic> json) {
    return Occupancy(
      total: Total.fromJson(json['total']),
    );
  }
}

class Total {
  final int free;
  final int occupied;

  Total({
    required this.free,
    required this.occupied,
  });

  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(
      free: json['free'],
      occupied: json['occupied'],
    );
  }
}
