class Etkinlik {
  String tur;
  int id;
  String adi;
  String etkinlikBitisTarihi;
  String kucukAfis;
  String etkinlikMerkezi;
  String kisaAciklama;
  bool ucretsizMi;
  String resim;
  String etkinlikUrl;
  String etkinlikBaslamaTarihi;

  Etkinlik({
    required this.tur,
    required this.id,
    required this.adi,
    required this.etkinlikBitisTarihi,
    required this.kucukAfis,
    required this.etkinlikMerkezi,
    required this.kisaAciklama,
    required this.ucretsizMi,
    required this.resim,
    required this.etkinlikUrl,
    required this.etkinlikBaslamaTarihi,
  });

  factory Etkinlik.fromJson(Map<String, dynamic> json) {
    return Etkinlik(
      tur: json['Tur'] as String,
      id: json['Id'] as int,
      adi: json['Adi'] as String,
      etkinlikBitisTarihi: json['EtkinlikBitisTarihi'] as String,
      kucukAfis: json['KucukAfis'] as String,
      etkinlikMerkezi: json['EtkinlikMerkezi'] as String,
      kisaAciklama: json['KisaAciklama'] as String,
      ucretsizMi: json['UcretsizMi'] as bool,
      resim: json['Resim'] as String,
      etkinlikUrl: json['EtkinlikUrl'] as String,
      etkinlikBaslamaTarihi: json['EtkinlikBaslamaTarihi'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Tur'] = tur; // Key is case-sensitive and should match the JSON
    data['Id'] = id;
    data['Adi'] = adi;
    data['EtkinlikBitisTarihi'] =
        etkinlikBitisTarihi; // String, no null check needed
    data['KucukAfis'] = kucukAfis;
    data['EtkinlikMerkezi'] = etkinlikMerkezi;
    data['KisaAciklama'] = kisaAciklama;
    data['UcretsizMi'] = ucretsizMi;
    data['Resim'] = resim;
    data['EtkinlikUrl'] = etkinlikUrl;
    data['EtkinlikBaslamaTarihi'] =
        etkinlikBaslamaTarihi; // String, no null check needed
    return data;
  }
}
