import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({Key key}) : super(key: key);

  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = '';
  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initPrinter();
    });
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 3));
    if (!mounted) return;
    bluetoothPrint.scanResults.listen((val) {
      if (!mounted) return;
      setState(() {
        _devices = val;
      });
      if (_devices.isEmpty) {
        setState(() {
          _devicesMsg = 'No Devices';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Select Printer'),
          backgroundColor: Colors.green,),
        body: _devices.isEmpty ? Center(child: Text(_devicesMsg ?? ''),):
            ListView.builder(itemCount: _devices.length,itemBuilder:(c,i){
              return ListTile(leading: Icon(Icons.print),title: Text(_devices[i].name??''),subtitle:Text(_devices[i].address??'') ,onTap: (){
                _startPrint(_devices[i]);
              },);
            } )
    );
  }
  Future<void>_startPrint(BluetoothDevice device)async{
    print('device name is ${device.name}');
    if(device!=null && device.address!=null){
      print('**');
      await bluetoothPrint.connect(device).then((value) => print('aaaaa $value'));
      bluetoothPrint.state.listen((state) {
        print('cur device status: ${BluetoothPrint.CONNECTED}');


  /*      switch (state) {
          case BluetoothPrint.CONNECTED:
            setState(() {
              _connected = true;
            });
            break;
          case BluetoothPrint.DISCONNECTED:
            setState(() {
              _connected = false;
            });
            break;
          default:
            break;
        }*/
      });
      //bluetoothPrint.printTest();
      print('****');
      Map<String , dynamic>config=Map();
      List<LineText>list=[];
      list.add(LineText(type: LineText.TYPE_TEXT,content: 'دارت يا صيع',width: 2,height: 2,weight: 2,align: LineText.ALIGN_CENTER,linefeed: 1));
      print('**//**');
    }
  }
}
