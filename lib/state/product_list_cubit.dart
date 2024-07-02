import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_flutter/services/product_service.dart';
import 'package:interview_flutter/state/product_list_state.dart';

import '../models/product.dart';
import '../services/network.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit() : super(ProductListLoadingState()){
    loadData();
  }
  int page = 0;
  List<Product> products = [];
  final ProductService service = getIt.get<ProductService>();

  Future getProducts() async {
    try {
      var newProducts = await service.getProducts(page);
      var noMoreData = newProducts.isEmpty;
      products.addAll(newProducts);
      emit(ProductListLoadedState(products: products, noMoreData: noMoreData));
    } catch (e) {
      emit(ProductListErrorState(error: e.toString()));
    }
  }

  Future loadData() async {
    page++;
    if(page == 1){
      emit(ProductListLoadingState());
    }
    getProducts();
  }

  Future refresh() async {
    emit(ProductListLoadingState());
    page = 0;
    products.clear();
    loadData();
  }

}
