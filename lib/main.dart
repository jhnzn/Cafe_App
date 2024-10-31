import 'package:cafe_app/screen/AdminPage.dart';
import 'package:cafe_app/screen/DataMejaPage.dart';
import 'package:cafe_app/screen/DataProdukPage.dart';
import 'package:cafe_app/screen/DataTransaksi.dart';
import 'package:cafe_app/screen/DataUserPage.dart';
import 'package:cafe_app/screen/EditMejaPage.dart';
import 'package:cafe_app/screen/EditProdukPage.dart';
import 'package:cafe_app/screen/EditUserPage.dart';
import 'package:cafe_app/screen/KeranjangPage.dart';
import 'package:cafe_app/screen/LoginPage.dart';
import 'package:cafe_app/screen/MejaPage.dart';
import 'package:cafe_app/screen/NotaPage.dart';
import 'package:cafe_app/screen/OnBoarding.dart';
import 'package:cafe_app/screen/OrderPage.dart';
import 'package:cafe_app/screen/Splash.dart';
import 'package:cafe_app/screen/TambahMejaPage.dart';
import 'package:cafe_app/screen/TambahProdukPage.dart';
import 'package:cafe_app/screen/TambahUserPage.dart';
import 'package:cafe_app/screen/model/meja_model.dart';
import 'package:cafe_app/screen/model/produk_model.dart';
import 'package:cafe_app/screen/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/onboard': (context) => Onboarding(),
        '/login': (context) => LoginPage(),
        '/order': (context) => OrderPage(),
        '/keranjang': (context) => Keranjang(),
        '/meja': (context) => Mejapage(),
        '/nota': (context) => Nota(quantities: {},),
        '/Data Transaksi': (context) => DataTransaksi(),
        '/Admin': (context) => AdminPage(),
        '/DataUser': (context) => DataUser(),
        '/DataProduct': (context) => DataProduct(),
        '/DataMeja': (context) => DataMeja(),
        '/EditUser': (context) => EditUser(user: UserModel(Nama: '',Role: '',Password:'',docId: '')),
        '/EditProduk': (context) => EditProduk(produk: ModalRoute.of(context)!.settings.arguments as ProdukModel), // Pastikan Anda melewatkan argumen
        '/EditMeja': (context) => EditMeja(meja:MejaModel(nomorMeja: '', kapasitas: '', status: '', docId: '')),
        '/TambahUser': (context) => TambahUser(),
        '/TambahProduk': (context) => TambahProduk(),
        '/TambahMeja': (context) => TambahMeja(),
      },
    );
  }
}
