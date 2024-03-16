import 'package:get/get.dart';
import 'package:form/controller/cards_controller.dart';
import 'package:form/screens/add_card_screen.dart';
import 'package:form/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:form/widgets/custom_card.dart';
import 'package:form/widgets/custom_loader.dart';
import 'package:form/widgets/custom_snackbar_widget.dart';

class AllCardsScreen extends GetView {
  const AllCardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardsController>(builder: (con) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: const Text(
              'All Visiting Cards',
              style: TextStyle(
                color: AppColors.black,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    con.clearData();
                    Get.to(() => const AddCardScreen());
                  },
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.black,
                  )),
              const SizedBox(width: 10)
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => con.getData(),
            child: bodyWidget(con),
          ));
    });
  }

  Widget bodyWidget(CardsController con) {
    if (con.isLoading.value == true) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    } else if (con.allData.isEmpty) {
      return const Center(child: Text('You don\'t have any record'));
    } else {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: con.allData.length,
          itemBuilder: (context, i) {
            return CustomCard(
              companyName: con.allData[i].companyName,
              companyIcon: con.allData[i].image,
              userName: con.allData[i].name,
              email: con.allData[i].email,
              mobile: con.allData[i].mobile,
              address: con.allData[i].address,
              color: con.allData[i].color,
              onEdit: () {
                Get.to(() => AddCardScreen(data: con.allData[i]));
              },
              onDelete: () {
                deleteData(con.allData[i].timestamp, con);
              },
              onDownload: () {},
            );
          },
        ),
      );
    }
  }

  void deleteData(String time, CardsController con) async {
    try {
      showCustomLoader();
      await con.collRef.doc(time).delete().then((value) async {
        hideCustomLoader();

        CustomSnackbar().success("Data deleted.", 2);

        con.getData();
      });
    } catch (e) {
      hideCustomLoader();
      CustomSnackbar().error("Failed to delete data.", 2);
    }
  }
}
