import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_image.dart';
import 'package:flutter_code_challenge/pages/products/models/product_model.dart';

class ProductItem extends StatelessWidget {
  
  final ProductModel? product;
  final VoidCallback? onTap;

  ProductItem({
    super.key,
    this.onTap,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    if( product == null ) return Container();

    return ListTile(
      leading: BlockImage(
        urlImage: product!.thumbnail,
        width: 70,
        height: 70,
      ),
      title: Text(
        '${product?.title ?? ''}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${product?.description ?? ''}',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            '${product?.price ?? ''}\$',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onTap: () {
        if( onTap != null ) {
          onTap!();
        }
      },
    );
  }
}