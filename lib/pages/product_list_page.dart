import 'package:flutter/material.dart';
import 'package:interview_flutter/common/bottom_navigation.dart';
import 'package:interview_flutter/pages/product_details_page.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'dart:convert';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});
  @override
  State<StatefulWidget> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];
  final scrollController = ScrollController();
  final baseUrl = "https://products-dno6nb6hsa-uc.a.run.app";
  var page = 0;
  var limit = 5;
  var isLoading = false;
  var noMoreData = false;

  @override
  initState() {
    super.initState();
    loadData();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double childWidth = (MediaQuery.of(context).size.width - 10) / 2;
    final double childHeight = childWidth * 270 / 190;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Products',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.6,
        ),
        body: (products.isEmpty && isLoading)
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : RefreshIndicator(
                onRefresh: refresh,
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width / childWidth)
                                .floor(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        childAspectRatio: childWidth / childHeight,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: products.length,
                        (context, index) {
                          var product = products[index];
                          var hasImage = product.imageUrls != null &&
                              product.imageUrls?.first != null;
                          var url = product.imageUrls?.first;
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ProductDetailsPage(
                                    productId: product.id!);
                              }));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                      decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: hasImage
                                          ? NetworkImage(url!)
                                          : const AssetImage(
                                                  'assets/iphone.png')
                                              as ImageProvider,
                                      fit: BoxFit.fitHeight,
                                      alignment: FractionalOffset.bottomRight,
                                    ),
                                  )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 12, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name ?? '',
                                        style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '\$${product.price ?? 0}',
                                        style: const TextStyle(
                                            fontSize: 19, color: Colors.blue),
                                      ),
                                      Text(
                                        '${product.percent ?? 0}% • ${product.stock ?? 0} left',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (!noMoreData)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                )),
        bottomNavigationBar: MyBottomNavigationBar.get());
  }

  Future getProducts() async {
    try {
      var url = Uri.parse('$baseUrl?limit=$limit&page=$page');
      final response = await http.get(url);
      var newProducts = productListFromJson(jsonDecode(response.body));
      setState(() {
        if (newProducts.isEmpty) {
          noMoreData = true;
        }
        isLoading = false;
        products += newProducts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error occurred.$e"),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
      page++;
      getProducts();
    });
  }

  Future refresh() async {
    setState(() {
      page = 0;
      noMoreData = false;
      products.clear();
    });
    loadData();
  }

  List<Product> productListFromJson(List<dynamic> obj) =>
      obj.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
}
