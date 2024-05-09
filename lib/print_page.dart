
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  PrintPage(this.data);

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  bool _connected = false;
  String tips = '';
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  BluetoothDevice? _device ;
  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {initPrinter();});
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));
    bool isConnected = await bluetoothPrint.isConnected??false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;
    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Printer'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(tips,style: TextStyle(
              fontSize: 16,
            )),
          ),
          StreamBuilder<List<BluetoothDevice>>(
            stream: bluetoothPrint.scanResults,
            initialData: [],
            builder: (c, snapshot) => Column(
              children: snapshot.data!.map((d) => ListTile(
                title: Text(d.name??''),
                subtitle: Text(d.address??''),
                onTap: () async {
                  setState(() {
                    _device = d;
                  });
                },
                trailing: _device!=null && _device!.address == d.address?Icon(
                  Icons.check,
                  color: Colors.green,
                ):null,
              )).toList(),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: _connected?null:() async{
                    if(_device!=null && _device!.address !=null){
                      setState(() {
                        tips = 'connecting...';
                      });
                      await bluetoothPrint.connect(_device!);
                    }else{
                      setState(() {
                        tips = 'please select device';
                      });
                    }
                  },
                  child: const Text('Connect')
              ),
              SizedBox(width: 10),
              OutlinedButton(
                  onPressed: _connected?() async{
                    setState(() {
                      tips = "disconnecting...";
                    });
                    await bluetoothPrint.disconnect();
                  }:null,
                  child: const Text('Disconnect')
              ),
            ],
          ),

          const SizedBox(height: 40),
          OutlinedButton(
            child: const Text('Print '),
            onPressed: _connected?() async{
              startPrint();
            }:null,
          ),
        ],
      ),
      //search bluetooth
      floatingActionButton: StreamBuilder<bool>(
        stream: bluetoothPrint.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data == true) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => bluetoothPrint.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () =>
                    bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }

  Future<void> startPrint() async {
    int _total = 0;
    _total = widget.data.map((e) => e['price'] * e['qty']).reduce(
          (value, element) => value + element,
    );
      Map<String, dynamic> config = Map();
      config['gap'] = 2;
      List<LineText> list = [];
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "***Grocery App***",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ),
      );

      list.add(LineText(type: LineText.TYPE_TEXT,linefeed: 1,align:LineText.ALIGN_CENTER,content: ' ',height: 10));
      for (var i = 0; i < widget.data.length; i++) {

        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: widget.data[i]['title'],
            weight: 0,
            relativeX: 0,
            x: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),);

        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            relativeX: 0,
            content:
            "${f.format(this.widget.data[i]['price'])} x ${this.widget.data[i]['qty']}",
            x: 380,
            align: LineText.ALIGN_CENTER,
            linefeed: 1,
          ),);
      }

      list.add(LineText(type: LineText.TYPE_TEXT,linefeed: 1,align:LineText.ALIGN_CENTER,content: ' ',height: 10));
      list.add(LineText(type: LineText.TYPE_TEXT,size: 4,align: LineText.ALIGN_CENTER,content: 'Total :               \$${_total}',));

      await bluetoothPrint.printReceipt(config, list);

  }
}
