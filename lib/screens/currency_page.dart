import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileproject/utils.dart';

import '../NavBar.dart';
import '../controllers/coin_controller.dart';

class CurrencyPage extends StatelessWidget {
  final CoinController controller = Get.put(CoinController());

  CurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: NavBar(),
      appBar: AppBar(
        title:
            const Text('Crypto Market', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
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
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                    0.05), // Gölge rengi ve opaklık
                                spreadRadius: 5, // Yayılma yarıçapı
                                blurRadius: 2, // Bulanıklık yarıçapı
                                offset: const Offset(
                                    0, 3), // Gölgenin konumu (x, y)
                              ),
                            ],
                          ),
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.2), // Gölge rengi ve opaklık
                                          spreadRadius: 2, // Yayılma yarıçapı
                                          blurRadius: 5, // Bulanıklık yarıçapı
                                          offset: const Offset(
                                              0, 3), // Gölgenin konumu (x, y)
                                        ),
                                      ],
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
                                            18,
                                            Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            FontWeight.w600),
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
                                        18, Theme.of(context)
                                        .colorScheme
                                        .tertiary, FontWeight.w600),
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
