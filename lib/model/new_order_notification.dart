class NewOrderNotification {
  String orderId;
  String type;
  String addressFrom;
  String addressTo;
  Customer customer;

  NewOrderNotification(
      {this.orderId,
      this.type,
      this.addressFrom,
      this.addressTo,
      this.customer});

  NewOrderNotification.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    type = json['type'];
    addressFrom = json['address_from'];
    addressTo = json['address_to'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['type'] = this.type;
    data['address_from'] = this.addressFrom;
    data['address_to'] = this.addressTo;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  String id;
  String name;
  String contact;
  double rating;

  Customer({this.id, this.name, this.contact, this.rating});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['rating'] = this.rating;
    return data;
  }
}
