class Bisiklet {
  final String durumu;
  final String kapasite;
  final String istasyonAdi;
  final String istasyonID;
  final String bisikletSayisi;
  final String koordinat;

  Bisiklet({
    required this.durumu,
    required this.kapasite,
    required this.istasyonAdi,
    required this.istasyonID,
    required this.bisikletSayisi,
    required this.koordinat,
  });

  factory Bisiklet.fromJson(Map<String, dynamic> json) {
    return Bisiklet(
      durumu: json['Durumu'],
      kapasite: json['Kapasite'],
      istasyonAdi: json['IstasyonAdi'],
      istasyonID: json['IstasyonID'],
      bisikletSayisi: json['BisikletSayisi'],
      koordinat: json['Koordinat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Durumu': durumu,
      'Kapasite': kapasite,
      'IstasyonAdi': istasyonAdi,
      'IstasyonID': istasyonID,
      'BisikletSayisi': bisikletSayisi,
      'Koordinat': koordinat,
    };
  }
}
