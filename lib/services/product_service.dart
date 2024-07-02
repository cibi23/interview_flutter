import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../models/product.dart';

@Injectable()
class ProductService {

  static const limit = 5;
  final baseUrlList = "https://products-dno6nb6hsa-uc.a.run.app";
  final baseUrlDetails = "https://productdetails-dno6nb6hsa-uc.a.run.app";

  Future getProducts(int page) async {
      var url = Uri.parse('$baseUrlList?limit=$limit&page=$page');
      final response = await http.get(url);
      var newProducts = productListFromJson(jsonDecode(response.body));
      return newProducts;
  }

  Future<Product> getProduct(int productId) async {
      var url = Uri.parse('$baseUrlDetails/$productId');
      final response = await http.get(url);
      return Product.fromJson(jsonDecode(response.body));
  }

  List<Product> productListFromJson(List<dynamic> obj) =>
      obj.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();

}