import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileproject/utils.dart';

import '../NavBar.dart';
import '../controllers/coin_controller.dart';

class CurrencyPage extends StatelessWidget {
  final CoinController controller = Get.put(CoinController());

  CurrencyPage({super.key});

  TextStyle myAppbarStyle = textStyle(25, Colors.black, FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 188, 202, 100),
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Crypto Market', style: myAppbarStyle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.network(
                                          controller.coinsList[index].image),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        controller.coinsList[index].name,
                                        style: textStyle(
                                            18, Colors.white, FontWeight.w600),
                                      ),
                                      Text(
                                        "${controller.coinsList[index].priceChangePercentage24H.toStringAsFixed(2)}%", // kısaltma gerçekleştirildi.
                                        style: textStyle(
                                            18, Colors.grey, FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    "\$ ${controller.coinsList[index].currentPrice.round()}",
                                    style: textStyle(
                                        18, Colors.white, FontWeight.w600),
                                  ),
                                  Text(
                                    controller.coinsList[index].symbol
                                        .toUpperCase(),
                                    style: textStyle(
                                        18, Colors.grey, FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ))
          ],
        ),
      ),
    );
  }
}
