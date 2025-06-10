class AntikKent {
  int? sayfadakiKayitsayisi;
  int? kayitSayisi;
  int? sayfaNumarasi;
  List<Onemliyer>? onemliyer;
  int? toplamSayfaSayisi;

  AntikKent(
      {this.sayfadakiKayitsayisi,
      this.kayitSayisi,
      this.sayfaNumarasi,
      this.onemliyer,
      this.toplamSayfaSayisi});

  AntikKent.fromJson(Map<String, dynamic> json) {
    sayfadakiKayitsayisi = json['sayfadaki_kayitsayisi'];
    kayitSayisi = json['kayit_sayisi'];
    sayfaNumarasi = json['sayfa_numarasi'];
    if (json['onemliyer'] != null) {
      onemliyer = <Onemliyer>[];
      json['onemliyer'].forEach((v) {
        onemliyer!.add(Onemliyer.fromJson(v));
      });
    }
    toplamSayfaSayisi = json['toplam_sayfa_sayisi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sayfadaki_kayitsayisi'] = this.sayfadakiKayitsayisi;
    data['kayit_sayisi'] = this.kayitSayisi;
    data['sayfa_numarasi'] = this.sayfaNumarasi;
    if (this.onemliyer != null) {
      data['onemliyer'] = this.onemliyer!.map((v) => v.toJson()).toList();
    }
    data['toplam_sayfa_sayisi'] = this.toplamSayfaSayisi;
    return data;
  }
}

class Onemliyer {
  String? iLCE;
  String? kAPINO;
  double? eNLEM;
  String? aCIKLAMA;
  String? iLCEID;
  String? mAHALLE;
  dynamic mAHALLEID;
  String? aDI;
  double? bOYLAM;
  String? yOL;

  Onemliyer(
      {this.iLCE,
      this.kAPINO,
      this.eNLEM,
      this.aCIKLAMA,
      this.iLCEID,
      this.mAHALLE,
      this.mAHALLEID,
      this.aDI,
      this.bOYLAM,
      this.yOL});

  Onemliyer.fromJson(Map<String, dynamic> json) {
    iLCE = json['ILCE']?.toString() ?? '';
    kAPINO = json['KAPINO']?.toString() ?? '';
    eNLEM = _parseDouble(json['ENLEM']);
    aCIKLAMA = json['ACIKLAMA']?.toString() ?? '';
    iLCEID = json['ILCEID']?.toString() ?? '';
    mAHALLE = json['MAHALLE']?.toString() ?? '';
    mAHALLEID = json['MAHALLEID'];
    aDI = json['ADI']?.toString() ?? '';
    bOYLAM = _parseDouble(json['BOYLAM']);
    yOL = json['YOL']?.toString() ?? '';
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        throw FormatException('Invalid number format: $value');
      }
    }
    throw FormatException('Invalid number format: $value');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ILCE'] = this.iLCE;
    data['KAPINO'] = this.kAPINO;
    data['ENLEM'] = this.eNLEM;
    data['ACIKLAMA'] = this.aCIKLAMA;
    data['ILCEID'] = this.iLCEID;
    data['MAHALLE'] = this.mAHALLE;
    data['MAHALLEID'] = this.mAHALLEID;
    data['ADI'] = this.aDI;
    data['BOYLAM'] = this.bOYLAM;
    data['YOL'] = this.yOL;
    return data;
  }
}
