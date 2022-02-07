class AllData {
  List<Data>? data;
  String? status;

  AllData({this.data, this.status});

  AllData.fromJson(Map<String, dynamic> json) {
    this.data = json["Data"] == null
        ? null
        : (json["Data"] as List).map((e) => Data.fromJson(e)).toList();
    this.status = json["Status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null)
      data["Data"] = this.data?.map((e) => e.toJson()).toList();
    data["Status"] = this.status;
    return data;
  }
}

class Data {
  String? finCode;
  String? clientName;
  String? dealType;
  String? quantity;
  String? value;
  String? tradePrice;
  String? dealDate;
  String? exchange;

  Data(
      {this.finCode,
      this.clientName,
      this.dealType,
      this.quantity,
      this.value,
      this.tradePrice,
      this.dealDate,
      this.exchange});

  Data.fromJson(Map<String, dynamic> json) {
    this.finCode = json["FinCode"];
    this.clientName = json["ClientName"];
    this.dealType = json["DealType"];
    this.quantity = json["Quantity"];
    this.value = json["Value"];
    this.tradePrice = json["TradePrice"];
    this.dealDate = json["DealDate"];
    this.exchange = json["Exchange"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["FinCode"] = this.finCode;
    data["ClientName"] = this.clientName;
    data["DealType"] = this.dealType;
    data["Quantity"] = this.quantity;
    data["Value"] = this.value;
    data["TradePrice"] = this.tradePrice;
    data["DealDate"] = this.dealDate;
    data["Exchange"] = this.exchange;
    return data;
  }
}
