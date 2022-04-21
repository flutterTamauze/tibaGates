import 'package:clean_app/Utilities/Colors/colorManager.dart';
import 'package:clean_app/Utilities/Shared/sharedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final Function onTap;
  final BluetoothDevice device;

  const BluetoothDeviceListEntry({this.onTap, @required this.device});

  @override
  Widget build(BuildContext context) {
    return       Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RoundedButton(
          ontap: onTap,
          title: 'الإتصال بالبوابة',
          width: 300,
          height: 70,
          buttonColor: Colors.green,
          titleColor: ColorManager.backGroundColor,
        ),
      ),
    );









      ListTile(
      onTap: onTap,
      leading: Icon(Icons.devices),
      title: Text(device.name ?? 'Unknown device'),
      subtitle: Text(device.address.toString()),
      trailing: FlatButton(
        child: Text('Connect'),
        onPressed: onTap,
        color: Colors.blue,
      ),
    );
  }
}
