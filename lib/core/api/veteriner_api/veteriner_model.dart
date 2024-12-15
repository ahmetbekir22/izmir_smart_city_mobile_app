class Veteriner {
  int? sayfadakiKayitsayisi;
  int? kayitSayisi;
  int? sayfaNumarasi;
  List<Onemliyer>? onemliyer;
  int? toplamSayfaSayisi;

  Veteriner(
      {this.sayfadakiKayitsayisi,
      this.kayitSayisi,
      this.sayfaNumarasi,
      this.onemliyer,
      this.toplamSayfaSayisi});

  Veteriner.fromJson(Map<String, dynamic> json) {
    sayfadakiKayitsayisi = json['sayfadaki_kayitsayisi'];
    kayitSayisi = json['kayit_sayisi'];
    sayfaNumarasi = json['sayfa_numarasi'];
    if (json['onemliyer'] != null) {
      onemliyer = <Onemliyer>[];
      json['onemliyer'].forEach((v) {
        onemliyer!.add(new Onemliyer.fromJson(v));
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
  Null? mAHALLEID;
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
    iLCE = json['ILCE'];
    kAPINO = json['KAPINO'];
    eNLEM = json['ENLEM'];
    aCIKLAMA = json['ACIKLAMA'];
    iLCEID = json['ILCEID'];
    mAHALLE = json['MAHALLE'];
    mAHALLEID = json['MAHALLEID'];
    aDI = json['ADI'];
    bOYLAM = json['BOYLAM'];
    yOL = json['YOL'];
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