
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image/image.dart' as Image;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:screenshot/screenshot.dart';
import 'ImagestorByte.dart';

class BluetoothPrinterPage extends StatefulWidget {
  const BluetoothPrinterPage({super.key});

  @override
  _BluetoothPrinterPageState createState() => _BluetoothPrinterPageState();
}

class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
  ScreenshotController screenshotController = ScreenshotController();
  List<BluetoothInfo> pairedDevices = [];
  bool isConnected = false;
  String? selectedDeviceMac;

  @override
  void initState() {
    super.initState();
    _getPairedDevices();
  }

  // Get a list of paired Bluetooth devices
  Future<void> _getPairedDevices() async {
    try {
      pairedDevices = await PrintBluetoothThermal.pairedBluetooths;
      setState(() {});
    } catch (e) {
      print("Error fetching paired devices: $e");
    }
  }

  Future<void> disconnectToDevice() async{
      bool disconnected = await PrintBluetoothThermal.disconnect;
      setState(() {
        isConnected = !disconnected;
      });
  }

  // Connect to selected Bluetooth device
  Future<void> _connectToDevice(String macAddress) async {
    await PrintBluetoothThermal.disconnect;
    try {
      bool connected = await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      setState(() {
        isConnected = connected;
      });
      if (connected) {
        print("Connected to $macAddress");
      } else {
        print("Failed to connect");
      }
    } catch (e) {
      print("Connection error: $e");
    }
  }

  Future<void> _printSampleReceipt() async {
    if (isConnected) {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];

      // bytes += generator.text("Welcome to My Store",
      //     styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
      // bytes += generator.reset();

      // final ByteData data = await rootBundle.load('lib/images/grocery.jpg');
      // final bytesImg = data.buffer.asUint8List();
      // final image = Image.decodeImage(bytesImg);
      // generator.image(imgSrc)
      final image = decodeImage(theimageThatComesfromThePrinter);
      bytes += generator.imageRaster(image!);
      await PrintBluetoothThermal.writeBytes(bytes);
        // print("Printed sample receipt");
    } else {
        //print("Device not connected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Select a Bluetooth Device to Connect:"),
            Expanded(
              child: ListView.builder(
                itemCount: pairedDevices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(pairedDevices[index].name),
                    subtitle: Text(pairedDevices[index].macAdress),
                    trailing: (selectedDeviceMac == pairedDevices[index].macAdress && isConnected)
                        ? const Icon(Icons.check_circle,color: Colors.greenAccent)
                        :null,
                    onTap: () {
                      selectedDeviceMac = pairedDevices[index].macAdress;
                      _connectToDevice(selectedDeviceMac!);
                    },
                  );
                },
              ),
            ),
            Screenshot(
              controller: screenshotController,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                  width: 200,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "မြန်မာစာ ‌မြန်မာစကား",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Text("-----------------"),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ရန်ကုန်မြို့ ရဲ့တစ်နေရာ",
                              style: TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Text(
                                "ကြက်သား",
                                style: TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "2 ပွဲ",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    "臺灣",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "4 ပွဲ",
                                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Text("----------"),
                    ],
                  )),
            ),
              ElevatedButton(
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
                child: const Text("Print Sample Receipt"),
              ),
              ElevatedButton(
                onPressed: disconnectToDevice,
                child: const Text("Disconnect printer"),
              ),
        ],
        ),
      ),
    );
  }
}
