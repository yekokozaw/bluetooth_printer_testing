import 'dart:async';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:printer_testing/bluetooth/bluetooth_service.dart';
import 'package:provider/provider.dart';

class ExamplePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ExamplePage> {
  final printerService = PrinterService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => printerService.initPrinter());
  }

  Future<void> bluetoothConnect(BluetoothDevice device) async{
    Provider.of<PrinterService>(context,listen: false).connect(device);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BluetoothPrint example app'),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              printerService.bluetoothPrint.startScan(),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(printerService.tips),
                    ),
                  ],
                ),
                Divider(),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: printerService.bluetoothPrint.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!.map((d) => ListTile(
                      title: Text(d.name??''),
                      subtitle: Text(d.address??''),
                      onTap: () async {
                        setState(() {
                          printerService.mDevice = d;
                        });
                      },
                      trailing: printerService.mDevice!=null && printerService.mDevice!.address == d.address?Icon(
                        Icons.check,
                        color: Colors.green,
                      ):null,
                    )).toList(),
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                            onPressed:  printerService.connected?null:() async {
                              bluetoothConnect(printerService.mDevice!);
                            },
                            child: const Text('connect'),
                          ),
                          SizedBox(width: 10.0),
                          OutlinedButton(
                            child: Text('disconnect'),
                            onPressed:  printerService.connected?() async {
                              await printerService.disconnect();
                            }:null,
                          ),
                        ],
                      ),
                      const Divider(),
                      OutlinedButton(
                        child: Text('print receipt(esc)'),
                        onPressed:  printerService.connected?() async {
                          printerService.startPrint();
                        }:null,
                      ),

                      //print label
                      OutlinedButton(
                        child: Text('print label(tsc)'),
                        onPressed:  printerService.connected?() async {
                          Map<String, dynamic> config = Map();
                          config['width'] = 40; // 标签宽度，单位mm
                          config['height'] = 70; // 标签高度，单位mm
                          config['gap'] = 2; // 标签间隔，单位mm

                          // x、y坐标位置，单位dpi，1mm=8dpi
                          List<LineText> list = [];
                          list.add(LineText(type: LineText.TYPE_TEXT, x:10, y:10, content: 'A Title'));
                          list.add(LineText(type: LineText.TYPE_TEXT, x:10, y:40, content: 'this is content'));
                          list.add(LineText(type: LineText.TYPE_QRCODE, x:10, y:70, content: 'qrcode i\n'));
                          list.add(LineText(type: LineText.TYPE_BARCODE, x:10, y:190, content: 'qrcode i\n'));

                          // List<LineText> list1 = [];
                          // ByteData data = await rootBundle.load("assets/images/guide3.png");
                          // List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                          // String base64Image = base64Encode(imageBytes);
                          // list1.add(LineText(type: LineText.TYPE_IMAGE, x:10, y:10, content: base64Image,));

                          await printerService.bluetoothPrint.printLabel(config, list);
                          //await bluetoothPrint.printLabel(config, list1);
                        }:null,
                      ),
                      OutlinedButton(
                        child: Text('print selftest'),
                        onPressed:  printerService.connected?() async {
                          await printerService.bluetoothPrint.printTest();
                        }:null,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        floatingActionButton: StreamBuilder<bool>(
          stream: printerService.bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data == true) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => printerService.bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () => printerService.bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }
}