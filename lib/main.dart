// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'dart:io';
//
// import 'ImagestorByte.dart';
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printer_testing/bluetooth_printer_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BluetoothPrinterPage(),
    );
  }
}


//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String? selectedDeviceMac;
//   ScreenshotController screenshotController = ScreenshotController();
//
//   String dir = Directory.current.path;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {initPrinter();});
//   }
//
//   void initPrinter() {
//
//   }
//
//   void testPrint(String printerIp, Uint8List theimageThatComesfr) async {
//     print("im inside the test print 2");
//     // TODO Don't forget to choose printer's paper size
//     const PaperSize paper = PaperSize.mm80;
//     final profile = await CapabilityProfile.load();
//   }
//
//   TextEditingController Printer = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Printer Testing ABW"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 250,
//               child: StreamBuilder<List<BluetoothDevice>>(
//                   stream: FlutterBluetoothPrinter.discovery,
//                   builder: (context, snapshot){
//
//                     final list = snapshot.data ?? <BluetoothDevice>[];
//                     return ListView.builder(
//                         itemCount: list.length,
//                         itemBuilder: (context, index){
//                           final device = list.elementAt(index);
//                           return ListTile(
//                               title: Text(device.name ?? 'No Name'),
//                               subtitle: Text(device.address),
//                               onTap: (){
//                                 // do anything
//                                 FlutterBluetoothPrinter.printImage(
//                                     address: device.address,
//                                     image: // some image
//                                 );
//                               }
//                           );
//                         }
//                     );
//                   }
//               );
//             ),
//             SizedBox(
//               height: 500,
//               child: ListView(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       ElevatedButton(
//                         child: const Text(
//                           'print res',
//                           style: TextStyle(fontSize: 40),
//                         ),
//                         onPressed: () {
//                           screenshotController
//                               .capture(delay: const Duration(milliseconds: 10))
//                               .then((capturedImage) async {
//                             theimageThatComesfromThePrinter = capturedImage!;
//                             setState(() {
//                               theimageThatComesfromThePrinter = capturedImage;
//                               testPrint(Printer.text, theimageThatComesfromThePrinter);
//                             });
//                           }).catchError((onError) {
//                             print(onError);
//                           });
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Screenshot(
//                         controller: screenshotController,
//                         child: Container(
//                             width: 140,
//                             child: Column(
//                               children: [
//                                 const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "မြန်မာစာ ‌မြန်မာစကား",
//                                       style: TextStyle(
//                                           fontSize: 10, fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                                 const Text(
//                                     "-----------------"),
//                                 const Padding(
//                                   padding: EdgeInsets.only(bottom: 20.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "(  汉字 )",
//                                         style: TextStyle(
//                                             fontSize: 10, fontWeight: FontWeight.bold),
//                                       ),
//                                       SizedBox(
//                                         width: 2,
//                                       ),
//                                       Text(
//                                         "رقم الطلب",
//                                         style: TextStyle(
//                                             fontSize: 10, fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                   child: Text(
//                                       "-----------------------"),
//                                 ),
//                                 const Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       flex: 6,
//                                       child: Center(
//                                         child: Text(
//                                           "التفاصيل",
//                                           style: TextStyle(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: Center(
//                                         child: Text(
//                                           "السعر ",
//                                           style: TextStyle(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: Center(
//                                         child: Text(
//                                           "العدد",
//                                           style: TextStyle(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 ListView.builder(
//                                   scrollDirection: Axis.vertical,
//                                   shrinkWrap: true,
//                                   physics: const ScrollPhysics(),
//                                   itemCount: 1,
//                                   itemBuilder: (context, index) {
//                                     return const Card(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Expanded(
//                                             flex: 6,
//                                             child: Center(
//                                               child: Text(
//                                                 "臺灣",
//                                                 style: TextStyle(fontSize: 10),
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 2,
//                                             child: Center(
//                                               child: Text(
//                                                 "تجربة عيوني انتة ",
//                                                 style: TextStyle(fontSize: 10),
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 2,
//                                             child: Center(
//                                               child: Text(
//                                                 "Test",
//                                                 style: TextStyle(fontSize: 10),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 const Text(
//                                     "----------"),
//                               ],
//                             )),
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }