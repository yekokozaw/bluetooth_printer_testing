// printer_service.dart

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrinterService extends ChangeNotifier {
  final BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool connected = false;
  String tips = '';
  BluetoothDevice? mDevice;
  final f = NumberFormat("\$###,###.00", "en_US");

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));
    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          connected = true;
          tips = 'connect success';
          notifyListeners(); // Notify listeners of state change
          break;
        case BluetoothPrint.DISCONNECTED:
          connected = false;
          tips = 'disconnect success';
          notifyListeners();
          break;
        default:
          break;
      }
    });
    if (isConnected) {
      connected = true;
      notifyListeners();
    }
  }

  Future<void> connect(BluetoothDevice device) async {
    if (device.address != null) {
        tips = 'connecting...';
      await bluetoothPrint.connect(device);
      notifyListeners();
    } else {
        tips = 'please select device';
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
      tips = "disconnecting...";
    await bluetoothPrint.disconnect();
    print(connected);
    notifyListeners();
  }

  Future<void> startPrint() async {
    Map<String, dynamic> config = Map();

    List<LineText> list = [];

    list.add(LineText(type: LineText.TYPE_TEXT, content: '**********************************************', weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: '打印单据头', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 2, linefeed: 1));
    list.add(LineText(linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: '----------------------明细---------------------', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Scarlet Johnson', weight: 1, align: LineText.ALIGN_LEFT, x: 0,relativeX: 0, linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT, content: '单位', weight: 1, align: LineText.ALIGN_LEFT, x: 350, relativeX: 0, linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT, content: '数量', weight: 1, align: LineText.ALIGN_LEFT, x: 500, relativeX: 0, linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Covid C30', align: LineText.ALIGN_LEFT, x: 0,relativeX: 0, linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT, content: '\$10', align: LineText.ALIGN_LEFT, x: 350, relativeX: 0, linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT, content: '12.0', align: LineText.ALIGN_LEFT, x: 500, relativeX: 0, linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: '**********************************************', weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));
    list.add(LineText(linefeed: 1));

    await bluetoothPrint.printReceipt(config, list);
  }
}
