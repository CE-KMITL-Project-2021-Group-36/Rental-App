import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';

class UploadEvidenceScreen extends StatefulWidget {
  const UploadEvidenceScreen({Key? key}) : super(key: key);

  @override
  State<UploadEvidenceScreen> createState() => _UploadEvidenceScreenState();
}

class _UploadEvidenceScreenState extends State<UploadEvidenceScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำขอเช่า'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor,
                  border: Border.all(
                    color: outlineColor,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.videocam, color: Colors.white),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'ที่ต้องได้รับ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'กรุณาถ่ายและอัปโหลดวิดีโอการเปิดกล่องพัสดุ'
                              .replaceAll('\\n', '\n'),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: outlineColor,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox.fromSize(
                            child: Image.network(
                              'https://www.zoomcamera.net/wp-content/uploads/2020/07/Canon-EOS-R5-Mirrorless-Digital-Camera-with-24-105mm-f4L-Lens-1.jpg',
                              fit: BoxFit.cover,
                              height: 100.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Canon EOS R5 Mirrorless Digital Camera with 24-105mm f4L Lens',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'เช่าวันที่ $formattedStartDate ถึง $formattedEndDate',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'ค่าเช่าไม่รวมมัดจำ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '฿' + 300.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(thickness: 0.6, height: 32),
                    const Text(
                      'เงื่อนไขค่ามัดจำ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '-แนบบัตรประชาชนมัดจำ 8,000 บาท\n-แนบบัตรนักศึกษามัดจำ 5,000 บาท'
                          .replaceAll('\\n', '\n'),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'เอกสารแนบเพิ่มเติม',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: primaryColor,
                    onTap: () {},
                    child: Ink(
                      decoration: BoxDecoration(
                        color: primaryColor[50],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox.fromSize(
                          child: Image.network(
                            'https://std.kpru.ac.th/th/img/student-card-3.jpg',
                            fit: BoxFit.contain,
                            height: 100.0,
                            width: 100.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: outlineColor,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'ที่อยู่',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'วัชรากร แท่นแก้ว'.replaceAll('\\n', '\n'),
                    ),
                    Text(
                      '086-123-1669'.replaceAll('\\n', '\n'),
                    ),
                    Text(
                      '9/1 ถ.พหลโยธิน 35 แขวงลาดยาว\nเขตจตุจักร, จังหวัดกรุงเทพมหานคร, 10900'
                          .replaceAll('\\n', '\n'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ค่าเช่าทั้งหมด',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ค่าเช่า',
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '฿' + 300.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 18,
                      // color: primaryColor,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ค่ามัดจำ',
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '฿' + '5,000',
                    style: const TextStyle(
                      fontSize: 18,
                      // color: primaryColor,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ยอดรวมทั้งหมด',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    '฿' + '5,300',
                    style: const TextStyle(
                      fontSize: 24,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 0.6, height: 32),
              const Text(
                'วิด๊โอรับสินค้า',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'เมื่อได้รับ - เปิดกล่องพัสดุและตรวจสอบสินค้าอย่างละเอียด',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return InkWell(
                        splashColor: primaryColor,
                        onTap: () {},
                        child: Ink(
                          decoration: BoxDecoration(
                            color: primaryColor[50],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Icon(Icons.videocam,
                              color: primaryColor, size: 60),
                        ));
                  }),
              const SizedBox(height: 16),
              const Divider(thickness: 0.6, height: 32),
              const Text(
                'การคืนสินค้าเมื่อใช้งานเสร็จ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: outlineColor,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'ส่งคืนที่อยู่',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ภูริวัจน์ วิจิตธัญโรจน์'.replaceAll('\\n', '\n'),
                    ),
                    Text(
                      '0837476791'.replaceAll('\\n', '\n'),
                    ),
                    Text(
                      '123/2 ซ.ฉลองกรุง 1, ถ.ฉลองกรุง, แขวงลาดกระบัง,\n ลาดกระบัง, กรุงเทพมหานคร, 10520'
                          .replaceAll('\\n', '\n'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'วิด๊โอหลักฐาน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'เมื่อส่งคืน - ตรวจสอบสินค้าอย่างละเอียดและนำส่งพัสดุ',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return InkWell(
                        splashColor: primaryColor,
                        onTap: () {},
                        child: Ink(
                          decoration: BoxDecoration(
                            color: primaryColor[50],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Icon(Icons.videocam,
                              color: primaryColor, size: 60),
                        ));
                  }),
                  const SizedBox(height: 16),
              const Text(
                'หมายเลขพัสดุ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(fontSize: 14),
                    //initialValue: 'ใส่หมายเลขพัสดุ',
                    onChanged: (value) {},
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'ใส่หมายเลขพัสดุ',
                      
                      //alignLabelWithHint: true,
                    ),
                    keyboardType: TextInputType.number
                              ),
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.done), color: primaryColor,)
                ],
              ),
            const Divider(thickness: 0.6, height: 32),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {},
                      child: const Text('เปิดข้อพิพาท'),
                      style: TextButton.styleFrom(
                        primary: primaryColor,
                        //backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(color: primaryColor, width: 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.chat_bubble_rounded),
                          SizedBox(
                            width: 4,
                          ),
                          Text('ติดต่อผู้ให้เช่า'),
                        ],
                      ),
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
