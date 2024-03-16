import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form/models/model.dart';
import 'package:form/utils/colors_utils.dart';
import 'package:form/utils/keyboard_utils.dart';
import 'package:form/widgets/custom_snackbar_widget.dart';

class CardsController extends GetxController {
  //
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  List<DataModel> allData = [];
  CollectionReference collRef = FirebaseFirestore.instance.collection('form');

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  //
  Future getData() async {
    isLoading.value = true;
    refresh();

    allData = [];

    QuerySnapshot<Map<String, dynamic>>? snapshot = (await collRef
        .orderBy("timestamp", descending: false)
        .get()) as QuerySnapshot<Map<String, dynamic>>?;

    for (var data in snapshot!.docs) {
      allData.add(DataModel.fromMap(data.data()));
    }

    isLoading.value = false;
    refresh();
  }

  //
  List<String> backColors = [
    "34c532",
    "ffac04",
    "0391f3",
    "807532",
    "1dab6f",
    "8f65ab",
    "ff4067",
    "1a4b46",
    "668fef",
  ];
  final selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  RxString image = "".obs;
  RxString color = "ffac04".obs;
  String? timestamp;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 40,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedFile != null) {
      final picked = File(pickedFile.path);
      final fileSizeInBytes = picked.lengthSync();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > 2) {
        CustomSnackbar().error("Image size cannot exceed 2 MB", 2);
        return;
      }
      image.value = "";
      selectedImage.value = picked;
    }
  }

//
  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      counterText: "",
      hintText: hint,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
      hintStyle: const TextStyle(fontSize: 14, color: AppColors.grey),
      focusedBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.textfieldBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.textfieldBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.textfieldBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.textfieldBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  //

  Future setUpdateData() async {
    await KeyBoardUtil().closeKeyboard();
    if (selectedImage.value == null && image.value == "") {
      CustomSnackbar().error("Please select image", 2);
    } else if (companyNameController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        addressController.text.isEmpty) {
      CustomSnackbar().error("All fields are required", 2);
    } else {
      try {
        if (image.value == "") {
          image.value = await uploadImage(selectedImage.value!.path);
        }

        //
        timestamp ??= DateTime.now().millisecondsSinceEpoch.toString();

        await collRef.doc(timestamp).set(
          {
            "companyName": companyNameController.text,
            "name": nameController.text,
            "email": emailController.text,
            "mobile": mobileController.text,
            "address": addressController.text,
            "image": image.value,
            "color": color.value,
            "timestamp": timestamp,
          },
          SetOptions(merge: true),
        ).then((value) async {
          await getData();
          clearData();
          Get.back();
          CustomSnackbar().success("Data submitted.", 2);
          await Future.delayed(const Duration(seconds: 1));
        });
      } catch (e) {
        CustomSnackbar().error("Failed to submite data.", 2);
      }
    }
  }

  Future<String> uploadImage(String filePath) async {
    final storageRef = FirebaseStorage.instance.ref(DateTime.now().toString());

    try {
      await storageRef.putFile(File(filePath));

      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      log(e.message.toString());
      return "";
    }
  }

  clearData() {
    selectedImage.value = null;
    companyNameController.clear();
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    addressController.clear();
    image.value = "";
    timestamp = null;
  }
}
