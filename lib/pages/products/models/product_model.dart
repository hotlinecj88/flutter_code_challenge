import 'dart:convert';
import 'dart:math';
import 'package:flutter_code_challenge/pages/products/models/product_vendor_model.dart';

class ProductModel {

  final int? id;
  final String? title;
  final String? description;
  final List<String>? platforms;
  final List<String>? tags;
  final String? esrbRating;
  final String? esrbDescriptors;
  final String? tagline;
  final List<String>? mediaList;
  final List<String>? sidebarImage;
  final String? thumbnail;
  final String? thumbnailHover;
  final List<ProductVendorModel>? vendors;
  final String? developer;
  final DateTime? createdAt;
  final String? releaseDateOverride;
  final int? price;

   ProductModel({
    this.id,
    this.title,
    this.description,
    this.platforms,
    this.tags,
    this.esrbRating,
    this.esrbDescriptors,
    this.tagline,
    this.mediaList,
    this.sidebarImage,
    this.thumbnail,
    this.thumbnailHover,
    this.vendors,
    this.developer,
    this.createdAt,
    this.releaseDateOverride,
    this.price,
  });

  static List<ProductVendorModel> _parseVendors(dynamic raw) {
    if(raw == null) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => ProductVendorModel.fromJson(e)).toList();
      } else if (decoded is Map<String, dynamic>) {
        return [ProductVendorModel.fromJson(decoded)];
      }
    } catch (e) {
      print('Error parsing vendors: $e');
    }
    return [];
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rng = Random();

    return ProductModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      platforms: (json['platforms'] as String?)?.split(',').map((e) => e.trim()).toList(),
      tags: (json['tags'] as String?)?.split(',').map((e) => e.trim()).toList(),
      esrbRating: json['esrbRating'] as String?,
      esrbDescriptors: json['esrbDescriptors'] as String?,
      tagline: json['tagline'] as String?,
      mediaList: (json['mediaList'] as String?)?.split(',').map((e) => e.trim()).toList(),
      sidebarImage: (json['sidebarImage'] as String?)?.split(',').map((e) => e.trim()).toList(),
      thumbnail: json['thumbnail'] as String?,
      thumbnailHover: json['thumbnailHover'] as String?,
      vendors: _parseVendors(json['vendors']),
      developer: json['developer'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      releaseDateOverride: json['releaseDateOverride'] as String?,
      price: json['price'] as int? ?? rng.nextInt(59) + 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'platforms': platforms?.join(','),
      'tags': tags?.join(','),
      'esrbRating': esrbRating,
      'esrbDescriptors': esrbDescriptors,
      'tagline': tagline,
      'mediaList': mediaList?.join(','),
      'sidebarImage': sidebarImage?.join(','),
      'thumbnail': thumbnail,
      'thumbnailHover': thumbnailHover,
      'vendors': vendors != null
        ? jsonEncode(vendors!.map((e) => e.toJson()).toList())
        : null,
      'developer': developer,
      'createdAt': createdAt?.toIso8601String(),
      'releaseDateOverride': releaseDateOverride,
      'price': price,
    };
  }

}