import '../models/product.dart';

sealed class ProductListState{}

class ProductListLoadingState extends ProductListState {}
class ProductListErrorState extends ProductListState {
  final String error;
  ProductListErrorState({required this.error});
}
class ProductListLoadedState extends ProductListState {
  final List<Product> products;
  final bool noMoreData;
  ProductListLoadedState({required this.products, required this.noMoreData});
}





