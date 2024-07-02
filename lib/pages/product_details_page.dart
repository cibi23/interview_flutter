
import 'package:flutter/material.dart';
import 'package:interview_flutter/common/bottom_navigation.dart';
import 'package:interview_flutter/services/product_service.dart';

import '../models/product.dart';
import '../services/network.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key, required this.productId});
  final int productId;
  final ProductService service = getIt.get<ProductService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Product>(
          future: service.getProduct(productId),
          builder:
              (BuildContext context, AsyncSnapshot<Product> productResult) {
            if (productResult.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error occurred')));
              return Container(color: Colors.white);
            } else if (!productResult.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final prod = productResult.data!;
              return ListView(children: [
                _startImage(prod, context),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Text(
                    'Description',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  child: Text(
                    prod.description ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 16, left: 12),
                  child: Text(
                    'Images',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                _images(prod)
              ]);
            }
          },
        ),
        bottomNavigationBar: MyBottomNavigationBar.get());
  }

  Widget _startImage(Product prod, BuildContext context){
    var hasImage =
        prod.imageUrls != null && prod.imageUrls?.first != null;
    var firstUrl = prod.imageUrls?.first;
    return AspectRatio(
      aspectRatio: MediaQuery.of(context).size.height /
          MediaQuery.of(context).size.width,
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: hasImage
                  ? NetworkImage(firstUrl!)
                  : const AssetImage('assets/iphone.png')
              as ImageProvider,
              fit: BoxFit.fitHeight,
              alignment: FractionalOffset.bottomRight,
            ),
          )),
    );
  }

  Widget _images(Product prod){
    var hasImage =
        prod.imageUrls != null && prod.imageUrls?.first != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (hasImage)
              for (var url in prod.imageUrls!)
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.center,
                            ),
                          )),
                    ),
                  ),
                ),
            if (!hasImage)
              for (var i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/iphone.png'),
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.center,
                            ),
                          )),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

}
