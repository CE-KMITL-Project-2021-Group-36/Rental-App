import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/rent_request_screen.dart';
import 'package:rental_app/widgets/choice_chip.dart';

class ProductSlidePanel extends StatefulWidget {
  const ProductSlidePanel({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductSlidePanel> createState() => _ProductSlidePanelState();
}

class _ProductSlidePanelState extends State<ProductSlidePanel> {
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  List<String> chipList = [];
  //String _selectedChoice = '';
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  Duration duration = const Duration(days: 0);
  double price = 0;

  @override
  void initState() {
    super.initState();
    if (widget.product.pricePerDay != 0) {
      chipList.add("รายวัน");
    }
    if (widget.product.pricePerWeek != 0) {
      chipList.add("รายสัปดาห์");
    }
    if (widget.product.pricePerMonth != 0) {
      chipList.add("รายเดือน");
    }
    // dateRange =
    //     DateTimeRange(start: DateTime.now(), end: DateTime(2022, 3, 31));
    // start = dateRange.start;
    // end = dateRange.end;
    // duration = dateRange.duration;
  }

  pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        child: child!,
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
          ),
        ),
      ),
    );
    if (newDateRange == null) return null;
    setState(() {
      dateRange = newDateRange;
    });
  }

  double _rentalPrice(int days) {
    int temp = days;
    double price = 0;
    double pricePerDay = widget.product.pricePerDay;
    double pricePerWeek = widget.product.pricePerWeek;
    double pricePerMonth = widget.product.pricePerMonth;
    while (temp != 0) {
      if (temp >= 30 && pricePerMonth != 0) {
        temp = temp - 30;
        price = price + pricePerMonth;
      } else if (temp >= 7 && pricePerWeek != 0) {
        temp = temp - 7;
        price = price + pricePerWeek;
      } else {
        temp = temp - 1;
        price = price + pricePerDay;
      }
    }
    return price;
  }

  Future<void> _showDeposit() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ค่ามัดจำ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(widget.product.deposit.replaceAll('\\n', '\n')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    start = dateRange.start;
    end = dateRange.end;
    duration = dateRange.duration;
    price = _rentalPrice(duration.inDays + 1);
    return Container(
      color: const Color(0xFF737373),
      child: Container(
        height: 400,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 100,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox.fromSize(
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ราคาเช่า',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.product.pricePerDay != 0
                          ? Text(
                              '฿' +
                                  currencyFormat(widget.product.pricePerDay) +
                                  ' /วัน',
                              style: const TextStyle(
                                  color: primaryColor, fontSize: 16),
                            )
                          : const SizedBox.shrink(),
                      widget.product.pricePerWeek != 0
                          ? Text(
                              '฿' +
                                  currencyFormat(widget.product.pricePerWeek) +
                                  ' /สัปดาห์',
                              style: const TextStyle(
                                  color: primaryColor, fontSize: 16),
                            )
                          : const SizedBox.shrink(),
                      widget.product.pricePerMonth != 0
                          ? Text(
                              '฿' +
                                  currencyFormat(widget.product.pricePerMonth) +
                                  ' /เดือน',
                              style: const TextStyle(
                                  color: primaryColor, fontSize: 16),
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                ],
              ),
              // const SizedBox(
              //   height: 24,
              // ),
              // const Text(
              //   'รูปแบบการเช่า',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // Row(children: [
              //   ChoiceChipWidget(
              //     chipList,
              //     (selectedChoice) {
              //       _selectedChoice = selectedChoice;
              //     },
              //   ),
              // ]),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'เช่าวันที่',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      pickDateRange();
                    },
                    child: Text(
                      '${start.day}/${start.month}/${start.year}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'ถึง',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      pickDateRange();
                    },
                    child: Text(
                      '${end.day}/${end.month}/${end.year}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),

              Text('ระยะเวลา ${duration.inDays + 1} วัน'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'ค่าเช่าไม่รวมมัดจำ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '฿' + currencyFormat(price),
                    style: const TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    _showDeposit();
                  },
                  child: const Text(
                    'ดูค่ามัดจำ',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    primary: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RentRequestScreen(product: widget.product, dateRange: dateRange, price: price)),
                        );
                      },
                      child: const Text('ส่งคำขอเช่า'),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
