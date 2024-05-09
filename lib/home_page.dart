import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printer_testing/print_page.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'title': 'Indian Milk', 'price': 15, 'qty': 2},
    {'title': 'Parle Biscut', 'price': 5, 'qty': 5},
    {'title': 'Fresh Onion', 'price': 20, 'qty': 1},
    {'title': 'Fresh Lime', 'price': 20, 'qty': 5},
    {'title': 'Maggi', 'price': 10, 'qty': 2},
  ];

  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  Widget build(BuildContext context) {
    int _total = 0;
    _total = data.map((e) => e['price'] * e['qty']).reduce(
      (value, element) => value + element,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter - Thermal Printer'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (c, i) {
                return ListTile(
                  title: Text(
                    data[i]['title'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${f.format(data[i]['price'])} x ${data[i]['qty']}",
                  ),
                  trailing: Text(
                    f.format(
                      data[i]['price'] * data[i]['qty'],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (){
                    
                  },
                  child: Text('Direct Print')
              )
            ],
          ),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Total: ${f.format(_total)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 80,
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrintPage(data),
                        ),
                      );
                    },
                    icon: Icon(Icons.print),
                    label: Text('Print'),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
