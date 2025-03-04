
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'ImagestorByte.dart';
import 'package:image/image.dart';

import 'bluetooth/bluetooth_service.dart';

class BluetoothPrinterPage extends StatefulWidget {
  const BluetoothPrinterPage({super.key});

  @override
  _BluetoothPrinterPageState createState() => _BluetoothPrinterPageState();
}

class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
  ScreenshotController screenshotController = ScreenshotController();
  List<BluetoothInfo> pairedDevices = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _printSampleReceipt() async {
    var bloc = context.read<PrinterService>();
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];
      final image = decodeImage(theimageThatComesfromThePrinter);
      bytes += generator.imageRaster(image!);
      await PrintBluetoothThermal.writeBytes(bytes);
      bloc.disconnectToDevice();
      if(!mounted){
        bloc.disconnectToDevice();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
                  color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 300,
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "INNOCENT",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8,bottom: 20.0,top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '(Bar and Refrigerator Orders)',
                                    style: TextStyle(
                                        fontSize: 8, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Name",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Unit",
                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Qty",
                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Remark",
                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Keen",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Cup",
                                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "1",
                                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "",
                                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: (){
                screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((capturedImage) async {
                  theimageThatComesfromThePrinter = capturedImage!;
                  setState(() {
                    theimageThatComesfromThePrinter = capturedImage;
                    _printSampleReceipt();

                  });
                }).catchError((onError) {
                  print(onError);
                });
              },
              icon: Icon(Icons.print,color: Colors.greenAccent.shade700,),
              label: const Text("Print Receipt",style: TextStyle(color: Colors.black),),
            ),
              // ElevatedButton(
              //   onPressed: disconnectToDevice,
              //   child: const Text("Disconnect printer"),
              // ),
        ],
        ),
      ),
    );
  }
}
