class ProductVendorModel {
  final String? label;
  final String? url;

  ProductVendorModel({
    this.label, 
    this.url
  });

  factory ProductVendorModel.fromJson(Map<String, dynamic> json) {
    return ProductVendorModel(
      label: json['label'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'url': url,
  };
}