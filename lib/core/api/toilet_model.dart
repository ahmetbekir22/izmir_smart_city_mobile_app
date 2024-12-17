class toilet {
  String? help;
  bool? success;
  Result? result;

  toilet({this.help, this.success, this.result});

  toilet.fromJson(Map<String, dynamic> json) {
    help = json['help'];
    success = json['success'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['help'] = this.help;
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? includeTotal;
  String? resourceId;
  List<Fields>? fields;
  String? recordsFormat;
  List<Records>? records;
  int? limit;
  Links? lLinks;
  int? total;

  Result(
      {this.includeTotal,
      this.resourceId,
      this.fields,
      this.recordsFormat,
      this.records,
      this.limit,
      this.lLinks,
      this.total});

  Result.fromJson(Map<String, dynamic> json) {
    includeTotal = json['include_total'];
    resourceId = json['resource_id'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(new Fields.fromJson(v));
      });
    }
    recordsFormat = json['records_format'];
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
    limit = json['limit'];
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['include_total'] = this.includeTotal;
    data['resource_id'] = this.resourceId;
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    data['records_format'] = this.recordsFormat;
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    data['limit'] = this.limit;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Fields {
  String? type;
  String? id;
  Info? info;

  Fields({this.type, this.id, this.info});

  Fields.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class Info {
  String? notes;
  String? typeOverride;
  String? label;

  Info({this.notes, this.typeOverride, this.label});

  Info.fromJson(Map<String, dynamic> json) {
    notes = json['notes'];
    typeOverride = json['type_override'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notes'] = this.notes;
    data['type_override'] = this.typeOverride;
    data['label'] = this.label;
    return data;
  }
}

class Records {
  int? iId;
  String? tESISADI;
  String? iLCE;
  String? mAHALLE;
  String? aDRES;
  double? bOYLAM;
  double? eNLEM;

  Records(
      {this.iId,
      this.tESISADI,
      this.iLCE,
      this.mAHALLE,
      this.aDRES,
      this.bOYLAM,
      this.eNLEM});

  Records.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    tESISADI = json['TESIS_ADI'];
    iLCE = json['ILCE'];
    mAHALLE = json['MAHALLE'];
    aDRES = json['ADRES'];
    bOYLAM = json['BOYLAM'];
    eNLEM = json['ENLEM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['TESIS_ADI'] = this.tESISADI;
    data['ILCE'] = this.iLCE;
    data['MAHALLE'] = this.mAHALLE;
    data['ADRES'] = this.aDRES;
    data['BOYLAM'] = this.bOYLAM;
    data['ENLEM'] = this.eNLEM;
    return data;
  }
}

class Links {
  String? start;
  String? next;

  Links({this.start, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['next'] = this.next;
    return data;
  }
}
