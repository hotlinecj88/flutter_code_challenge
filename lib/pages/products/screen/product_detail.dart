import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_appbar_static.dart';
import 'package:flutter_code_challenge/blocks/block_image.dart';
import 'package:flutter_code_challenge/blocks/block_not_found.dart';
import 'package:flutter_code_challenge/pages/products/models/product_model.dart';
import 'package:flutter_code_challenge/state/product_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDetail extends HookConsumerWidget {

  final Map<String, dynamic>? params; 

  ProductDetail({
    super.key,
    this.params
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final id = params?['id'] ?? null;
    final is_owner = params?['is_owner'] ?? false;
    if( id == null ) return BlockNotFound();

    final productState = ref.watch(product_state);
    final productList = is_owner
    ? productState.value?.my_products
    : productState.value?.products;
    ProductModel? product = productList?.firstWhereOrNull((e) => e.id == id);

    if( product == null ) return BlockNotFound();

    final imageSize = MediaQuery.of(context).size.width * 0.65;

    return Scaffold(
      appBar: BlockAppbarStatic(
        title: product.title,
        actions: [
          SizedBox(width: 24.0),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.0),
              Center(
                child: BlockImage(
                urlImage: product.thumbnail,
                  width: imageSize, height: imageSize,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if( product.platforms?.isNotEmpty == true ) label(title: 'Platforms'),
                    if( product.platforms?.isNotEmpty == true ) Wrap(
                      spacing: 8.0,
                      children: product.platforms!.map((e) {
                        return Chip(
                          label: Text('${e}'),
                        );
                      }).toList(),
                    ),

                    label(title: product.title),
                    longtext(text: product.description),
                    
                    if( product.tagline?.isEmpty == true ) label(title: 'Tag Line'),
                    if( product.tagline?.isEmpty == true ) longtext(text: product.tagline),

                    if( product.vendors?.isNotEmpty == true ) label(title: 'Shops'),
                    if( product.vendors?.isNotEmpty == true ) Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: product.vendors!.map((e) {
                        
                        return InkWell(
                          onTap: () {

                          },
                          child: Text(
                            '${e.label}', 
                            style: TextStyle(
                              fontSize: 16.0, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                        );
                      }).toList(),
                    ),

                  ],
                ),
              )
            ],
          )
        ),
      ),
    );

  }

  Widget longtext({ String? text }){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text ?? '',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  Widget label({ String? title }){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title ?? '',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}