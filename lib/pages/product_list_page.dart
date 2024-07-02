import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_flutter/common/bottom_navigation.dart';
import 'package:interview_flutter/pages/product_details_page.dart';
import 'package:interview_flutter/state/product_list_cubit.dart';
import 'package:interview_flutter/state/product_list_state.dart';

import '../models/product.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({super.key});

  final scrollController = ScrollController();

  void setUpScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        context.read<ProductListCubit>().loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setUpScrollController(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: BlocBuilder<ProductListCubit, ProductListState>(
          builder: (context, state) {
            if (state is ProductListLoadingState) {
              return _circularProgressIndicator();
            } else if (state is ProductListLoadedState) {
              return _loadedList(context, state);
            } else if (state is ProductListErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error occurred')));
              return Container(color: Colors.white);
            } else {
              throw Exception();
            }
          },
        ),
        bottomNavigationBar: MyBottomNavigationBar.get());
  }

  Widget _circularProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _singleProductView(Product product) {
    var hasImage =
        product.imageUrls != null && product.imageUrls?.first != null;
    var url = product.imageUrls?.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
              decoration: BoxDecoration(
            image: DecorationImage(
              image: hasImage
                  ? NetworkImage(url!)
                  : const AssetImage('assets/iphone.png') as ImageProvider,
              fit: BoxFit.fitHeight,
              alignment: FractionalOffset.bottomRight,
            ),
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${product.price ?? 0}',
                style: const TextStyle(fontSize: 19, color: Colors.blue),
              ),
              Text(
                '${product.percent ?? 0}% • ${product.stock ?? 0} left',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Products',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.6,
    );
  }

  Widget _loadedList(BuildContext context, state) {
    final double childWidth = (MediaQuery.of(context).size.width - 10) / 2;
    final double childHeight = childWidth * 280 / 190;
    return RefreshIndicator(
        onRefresh: context.read<ProductListCubit>().refresh,
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (MediaQuery.of(context).size.width / childWidth).floor(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: childWidth / childHeight,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: state.products.length,
                (context, index) {
                  var product = state.products[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ProductDetailsPage(productId: product.id!);
                        }));
                      },
                      child: _singleProductView(product));
                },
              ),
            ),
            if (!state.noMoreData)
              SliverToBoxAdapter(child: _circularProgressIndicator()),
          ],
        ));
  }
}
