import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();

  static const String routeName = '/add_product';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AddProductScreen(),
    );
  }
}

bool checkedPricePerDay = false;
bool checkedPricePerWeek = false;
bool checkedPricePerMonth = false;

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มสินค้า")),
      body: Form(
        //key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InkWell(
              onTap: (){},
              child: Container(
                  height: 200,
                  width: 200,
                  //childrencolor: Colors.blue,
                  child: Center(child: Text('Upload Image Here!'))),
            ),
            const SizedBox(height: 16),
            const Text('ชื่อสินค้าที่ให้เช่า'),
            const SizedBox(height: 4),
            buildTitle(),
            const SizedBox(height: 16),
            const Text('รายละเอียดสินค้า'),
            const SizedBox(height: 4),
            buildDetail(),
            const SizedBox(height: 32),
            const SizedBox(height: 4),
            const Text('เลือกหมวดหมู่สินค้า'),
            const SizedBox(height: 4),
            buildCategory(),
            const SizedBox(height: 32),
            const Text('ราคาให้เช่า'),
            const SizedBox(height: 4),
            CheckboxListTile(
              title: const Text('ราคาต่อวัน', style: TextStyle(fontSize: 14)),
              value: checkedPricePerDay,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerDay = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            buildPrice(checkedPricePerDay),
            CheckboxListTile(
              title:
                  const Text('ราคาต่อสัปดาห์', style: TextStyle(fontSize: 14)),
              value: checkedPricePerWeek,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerWeek = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            buildPrice(checkedPricePerWeek),
            CheckboxListTile(
              title: const Text('ราคาต่อเดือน', style: TextStyle(fontSize: 14)),
              value: checkedPricePerMonth,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerMonth = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            buildPrice(checkedPricePerMonth),
          ],
        ),
      ),
    );
  }
}

Widget buildTitle() => TextFormField(
      decoration: const InputDecoration(
        //labelText: 'ชื่อสินค้าที่ให้เช่า',
        hintText: 'ใส่ชื่อสินค้า',
      ),
      maxLength: 50,
    );

Widget buildDetail() => TextFormField(
      maxLines: 3,
      decoration: const InputDecoration(
        //labelText: 'รายละเอียดสินค้า',
        hintText: 'ใส่รายละเอียดสินค้า',
        alignLabelWithHint: true,
      ),
      maxLength: 200,
    );

Widget buildPrice(checkedValue) {
  return checkedValue
      ? TextFormField(
          decoration: const InputDecoration(
            suffix: Text('บาท'),
            //labelText: 'ราคาเช่าต่อวัน',
            hintText: 'ใส่ราคาเช่า',
          ),
          maxLength: 10,
          keyboardType: TextInputType.number,
        )
      : const SizedBox();
}

Widget buildAdress() => TextFormField(
      decoration: const InputDecoration(
        //labelText: 'ชื่อสินค้าที่ให้เช่า',
        hintText: 'ใส่ชื่อสินค้า',
      ),
      maxLength: 50,
    );

Widget buildCategory() {
  final List<String> categories = [
    'เสื้อผ้าผู้ชาย',
    'เสื้อผ้าผู้หญิง',
    "อุปกรณ์ถ่ายภาพ",
    "ตั้งแคมป์",
    "หนังสือ",
    "อุปรณ์กีฬา",
    "อุปกรณ์อิเล็กทรอนิกส์",
    "อื่นๆ",
  ];

  String? selectedValue;

  return DropdownButtonFormField2(
    dropdownElevation: 2,
    dropdownMaxHeight: 260,
    decoration: const InputDecoration(
      //Add isDense true and zero Padding.
      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
      isDense: true,
      contentPadding: EdgeInsets.zero,
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(15),
      // ),
      //Add more decoration as you want here
      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
    ),
    isExpanded: true,
    hint: const Text(
      'เลือกหมวดหมู่สินค้า',
      style: TextStyle(fontSize: 14),
    ),
    icon: const Icon(
      Icons.arrow_drop_down,
      color: Colors.black45,
    ),
    iconSize: 30,
    buttonHeight: 60,
    buttonPadding: const EdgeInsets.only(left: 20, right: 10),
    dropdownDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    items: categories
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
        .toList(),
    validator: (value) {
      if (value == null) {
        return 'Please select gender.';
      }
    },
    onChanged: (value) {
      //Do something when changing the item if you want.
    },
    onSaved: (value) {
      selectedValue = value.toString();
    },
  );
}
