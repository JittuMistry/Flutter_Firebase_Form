import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form/controller/cards_controller.dart';
import 'package:form/models/model.dart';
import 'package:flutter/material.dart';
import 'package:form/utils/assets_utils.dart';
import 'package:form/utils/colors_utils.dart';
import 'package:form/utils/extensions_utils.dart';
import 'package:form/widgets/custom_button.dart';
import 'package:form/widgets/custom_loader.dart';

class AddCardScreen extends GetView {
  final DataModel? data;

  const AddCardScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'Add Visiting Card',
            style: TextStyle(
              color: AppColors.black,
            ),
          ),
        ),
        body: GetBuilder<CardsController>(builder: (con) {
          if (data != null) {
            con.companyNameController.text = data?.companyName ?? "";
            con.nameController.text = data?.name ?? "";
            con.emailController.text = data?.email ?? "";
            con.mobileController.text = data?.mobile ?? "";
            con.addressController.text = data?.address ?? "";
            con.timestamp = data?.timestamp ?? "";
            con.image.value = data?.image ?? "";
          }
          return Form(
            key: con.formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Center(
                        child: InkWell(
                            onTap: () => con.getImage(ImageSource.gallery),
                            child: imageWidget(con))),
                    customTitle("Company Name"),
                    TextFormField(
                      controller: con.companyNameController,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration:
                          con.buildInputDecoration('Enter Company Name'),
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      maxLength: 200,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Company Name';
                        }
                        return null;
                      },
                    ),
                    customTitle("Name"),
                    TextFormField(
                      controller: con.nameController,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration: con.buildInputDecoration('Enter Your Name'),
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      maxLength: 200,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    customTitle("Email"),
                    TextFormField(
                      controller: con.emailController,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration: con.buildInputDecoration('Enter Your Email'),
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      maxLength: 200,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[^\w@.]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    customTitle("Mobile Number"),
                    TextFormField(
                      controller: con.mobileController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 15,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration: con.buildInputDecoration("+91 7837894456"),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Mobile Number';
                        }
                        return null;
                      },
                    ),
                    customTitle("Address"),
                    TextFormField(
                      controller: con.addressController,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration:
                          con.buildInputDecoration('Enter Your Address'),
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      maxLength: 200,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    customTitle("Select background color"),
                    const SizedBox(height: 5),
                    backColor(con),
                    const SizedBox(height: 20),
                    CustomButton(
                      height: 50,
                      btnName: "SAVE",
                      callback: () async {
                        if (con.formKey.currentState!.validate()) {
                          showCustomLoader();
                          await con.setUpdateData();
                          hideCustomLoader();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Widget imageWidget(CardsController con) {
    return Obx(() {
      if (con.selectedImage.value != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.file(
            con.selectedImage.value!,
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
        );
      } else if (con.image.value != "") {
        return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            con.image.value,
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Image.asset(
          Assets.profilePlaceholder,
          height: 120,
        );
      }
    });
  }

  Widget backColor(CardsController con) {
    return SizedBox(
      height: 25,
      child: ListView.builder(
        itemCount: con.backColors.length,
        padding: const EdgeInsets.only(left: 10, right: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => con.color.value = con.backColors[i],
                child: Container(
                  width: 25,
                  decoration: BoxDecoration(
                    border: con.color.value == con.backColors[i]
                        ? Border.all(width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(18),
                    color: HexColor(con.backColors[i]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget customTitle(String title) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, top: 10, bottom: 5),
        child: Text(
          title,
          style: const TextStyle(fontSize: 15),
        ));
  }
}
