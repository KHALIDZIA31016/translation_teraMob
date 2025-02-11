// import 'package:get/get.dart';
// import 'package:mnh/testor/database/db_creation.dart';
// import 'package:mnh/testor/model/mod_lang.dart';
//
//
// class SelectLangController extends GetxController{
//
//   final DBCreation dbCreation = DBCreation();
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     getDataSet();
//   }
//
//   var catLang = <SelectLangModel>[].obs;
//   var selectedTranslation = ''.obs;
//
//   Future<void> getDataSet() async{
//     try{
//       await dbCreation.initDatabase();
//       catLang.value = await dbCreation.getCat();
//     }catch(e){
//       print('Error: ====> $e');
//     }
//
//   }
//
//   void updateTranslation(String language) {
//     if (catLang.isNotEmpty) {
//       selectedTranslation.value = catLang.first.getTranslation(language)!;
//     }
//
// }}
//










import 'package:get/get.dart';

import '../database/db_creation.dart';
import '../model/mod_lang.dart';

class SelectLangController extends GetxController {
  final DBCreation dbCreation = DBCreation();

  @override
  void onInit() {
    super.onInit();
    getDataSet();
  }

  var catLang = <SelectLangModel>[].obs;
  var selectedTranslation = ''.obs;

  // Get data from the database
  Future<void> getDataSet() async {
    try {
      await dbCreation.initDatabase();
      catLang.value = await dbCreation.getCat();
    } catch (e) {
      print('Error: ====> $e');
    }
  }

  // Update translation based on selected language
  void updateTranslation(String language) {
    if (catLang.isNotEmpty) {
      // Fetch the translation for the selected language
      selectedTranslation.value = catLang.first.getTranslation(language) ?? '';
    }
  }
}

