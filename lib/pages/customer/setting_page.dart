import 'dart:developer' as logger;
import 'dart:io';
import 'dart:math';
import 'package:do_an_ui/models/customer.dart';
import 'package:do_an_ui/services/customer_service.dart';
import 'package:do_an_ui/services/image_service.dart';
import 'package:do_an_ui/shared/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class SettingPage extends StatefulWidget {
  final String userId;
  final picker = ImagePicker();

  SettingPage({
    Key? key,
    required this.userId
  }): super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  TextEditingController pointController = new TextEditingController();
  TextEditingController ticketController = new TextEditingController();

  late Customer customer;
  late String imageUrl;
  int maxConvertPoint = 1000;
  int convertPoint = 0;

  Future changeAvatar() async {
    String random = (new DateTime.now()).toIso8601String();

    File pickedFile = await widget.picker.getImage(source: ImageSource.camera) as File;
    imageService.uploadFile(pickedFile, "Customer/${widget.userId}/$random").then((url) {
      setState(() {
        imageUrl = url;
        customer.imageUrl = url;
      });
    });
  }

  void onAvatarTap() {
    Toast.show("Double tap avatar to change it", context);
  }

  void convert() {
    customer.point -= convertPoint;
    customer.ticket += (convertPoint / 100).floor();

    setState(() {
      ticketController.text = customer.ticket.toString();
      pointController.text = customer.point.toString();
    });
  }

  void save() {
     customer.name = nameController.text;
     customer.phoneNumber = phoneController.text;
     customer.address = addressController.text;

    customerService.update(customer).then((value) => {
      Toast.show("Save your information successfully!", context)
    });
  }

  @override
  void initState() {
    super.initState();

    customerService.readLive(widget.userId).listen((cus) {
      if (cus != null) customer = cus;
      else customer = new Customer(widget.userId);

      nameController.text = customer.name;
      phoneController.text = customer.phoneNumber;
      addressController.text = customer.address;

      ticketController.text = customer.ticket.toString();
      pointController.text = customer.point.toString();

      setState(() {
        imageUrl = customer.imageUrl;
        convertPoint = 0;
        maxConvertPoint = customer.point;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Image.asset("images/pic_user.png")
              ),
            ), flex: 4,),

          Expanded(child: ListView(
            children: [
              Center(child: Text("USER INFOS", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),),),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'name',
                ),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'phone number',
                ),
              ),
              TextField(
                controller: addressController,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: 'address',
                ),
              ),

              Row(children: [
                Expanded(child: TextField(
                  controller: pointController,
                  keyboardType: TextInputType.number,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Points you have gained',
                  ),
                ), flex: 1,),
                Expanded(child: TextField(
                  controller: ticketController,
                  keyboardType: TextInputType.number,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Discount tickets',
                  ),
                ), flex: 1,)
              ],),
              Row(children: [
                CustomNumberPicker(
                    onValue: (value) {
                      setState(() {
                        convertPoint = min((value as int), maxConvertPoint);
                      });
                    },
                    initialValue: convertPoint, step: 100,
                    minValue: 0, maxValue: maxConvertPoint),
                // Text("Convert ${convertPoint * 100} points to $convertPoint discount tickets"),
                Expanded(child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: convert,
                    child: Text("Convert $convertPoint points "
                        "to ${(convertPoint / 100).floor()} discount tickets",),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).buttonColor,
                  ),
                ), flex: 1,)
              ],),

              Divider(),
            ],
          ), flex: 9,),
          Expanded(child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: save,
              child: Text('Save',),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).buttonColor,
            ),
          ), flex: 1,)
          ],),
      )
    );
  }
}
