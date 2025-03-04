
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:printer_testing/bluetooth/bluetooth_service.dart';
import 'package:printer_testing/bluetooth/helper_functions.dart';
import 'package:printer_testing/bluetooth_printer_page.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        if(_adapterState == BluetoothAdapterState.off){
          showScaffoldMessage(context, 'Bluetooth is off');
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var bloc = context.read<PrinterService>();
      bloc.getPairedDevices();
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetoothScan.isDenied ||
        await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.bluetoothScan.isPermanentlyDenied ||
        await Permission.bluetoothConnect.isPermanentlyDenied) {
      openAppSettings(); // Opens the app settings to enable Nearby Devices
    }

    if (await Permission.bluetoothScan.isGranted && await Permission.bluetoothConnect.isGranted) {
      print("Bluetooth permissions granted");
    } else {
      print("Bluetooth permissions denied or Nearby Devices permission disabled");
    }
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<PrinterService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade300,
        leading: const Icon(Icons.menu,color: Colors.white,),
      ),
      body: Column(
        children: [
          Selector<PrinterService,bool?>(
            selector: (context,bloc) => bloc.isBluetoothEnabled,
            builder: (context,isEnabled,_) {
              if(isEnabled == null){
                return const CircularProgressIndicator();
              }
              else if (!isEnabled){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Enable Bluetooth in your settings'),
                    TextButton(
                        onPressed: () => bloc.getPairedDevices(),
                        child: const Icon(Icons.refresh)),
                  ],
                );
              }
              else{
                return const SizedBox(height: 1);
              }
            }),
          Expanded(
            child: Selector<PrinterService,List<BluetoothInfo>>(
              selector: (context,bloc) => bloc.pairedDevices,
              builder: (context,pairedDevices,_){
                return ListView.builder(
                  itemCount: pairedDevices.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(pairedDevices[index].name),
                        subtitle: Text(pairedDevices[index].macAdress),
                        trailing: Selector<PrinterService,bool>(
                          selector: (context,bloc) => bloc.connected,
                            builder: (context,isConnected,_){
                              if(bloc.selectedDeviceMac == pairedDevices[index].macAdress && isConnected){
                                return const Icon(Icons.check_circle,color: Colors.green);
                              }else{
                                return const SizedBox(width: 1);
                              }
                            },
                        ),
                        onTap: () {
                          bloc.connectToDevice(pairedDevices[index].macAdress,context);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BluetoothPrinterPage())
            );
          },child: const Text('Navigate to Print'))
        ],
      )
    );
  }
}
