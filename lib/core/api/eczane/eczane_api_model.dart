class Eczane {
  String? tarih;
  String? lokasyonY;
  String? lokasyonX;
  String? bolgeAciklama;
  String? adi;
  String? telefon;
  String? adres;
  int? bolgeId;
  String? bolge;
  Null uzaklikMetre;
  int? eczaneId;
  int? ilceId;

  Eczane(
      {this.tarih,
      this.lokasyonY,
      this.lokasyonX,
      this.bolgeAciklama,
      this.adi,
      this.telefon,
      this.adres,
      this.bolgeId,
      this.bolge,
      this.uzaklikMetre,
      this.eczaneId,
      this.ilceId});

  Eczane.fromJson(Map<String, dynamic> json) {
    tarih = json['Tarih'];
    lokasyonY = json['LokasyonY'];
    lokasyonX = json['LokasyonX'];
    bolgeAciklama = json['BolgeAciklama'];
    adi = json['Adi'];
    telefon = json['Telefon'];
    adres = json['Adres'];
    bolgeId = json['BolgeId'];
    bolge = json['Bolge'];
    uzaklikMetre = json['UzaklikMetre'];
    eczaneId = json['EczaneId'];
    ilceId = json['IlceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Tarih'] = tarih;
    data['LokasyonY'] = lokasyonY;
    data['LokasyonX'] = lokasyonX;
    data['BolgeAciklama'] = bolgeAciklama;
    data['Adi'] = adi;
    data['Telefon'] = telefon;
    data['Adres'] = adres;
    data['BolgeId'] = bolgeId;
    data['Bolge'] = bolge;
    data['UzaklikMetre'] = uzaklikMetre;
    data['EczaneId'] = eczaneId;
    data['IlceId'] = ilceId;
    return data;
  }
}
