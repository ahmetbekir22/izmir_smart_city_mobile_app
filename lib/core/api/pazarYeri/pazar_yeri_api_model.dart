class Onemliyer {
  String? iLCE;
  String? kAPINO;
  double? eNLEM;
  String? aCIKLAMA;
  String? iLCEID;
  String? mAHALLE;
  Null mAHALLEID;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ILCE'] = iLCE;
    data['KAPINO'] = kAPINO;
    data['ENLEM'] = eNLEM;
    data['ACIKLAMA'] = aCIKLAMA;
    data['ILCEID'] = iLCEID;
    data['MAHALLE'] = mAHALLE;
    data['MAHALLEID'] = mAHALLEID;
    data['ADI'] = aDI;
    data['BOYLAM'] = bOYLAM;
    data['YOL'] = yOL;
    return data;
  }
}
