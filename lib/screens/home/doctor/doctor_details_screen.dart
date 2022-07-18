import 'package:flutter/material.dart';
import 'package:med_connect/screens/shared/header_text.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
          IconButton(onPressed: () {}, icon: Icon(Icons.chat)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(
            height: 140,
            child: Row(
              children: [
                Container(
                  height: 140,
                  width: 140,
                  color: Colors.grey,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const HeaderText(text: 'Dr. Amanda Arthur'),
                    Text('Urologist'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.location_pin, color: Colors.blue),
                        Flexible(
                          child: Text(
                            'Tech Hospital, Kumasi',
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 3,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.yellow),
                            Text(
                              '4.5',
                              overflow: TextOverflow.fade,
                              // maxLines: 3,
                              // softWrap: true,
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Row(
                          children: const [
                            CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '20 reviews',
                              overflow: TextOverflow.fade,
                              // maxLines: 3,
                              // softWrap: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  color: Colors.black.withOpacity(.15),
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderText(text: 'Bio'),
                Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut laore et delore magna aliqua'),
                SizedBox(height: 20),
                const HeaderText(text: 'Studied at'),
                Text('UCC SMS'),
                SizedBox(height: 20),
                const HeaderText(text: 'Experience'),
                Text('10 years'),
                Divider(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(text: 'Reviews'),
                    TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 14))),
                      onPressed: () {},
                      child: const Text('See all'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        HeaderText(text: 'Juliet Rene'),
                        Text('4 hours ago'),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    HeaderText(text: '4.0'),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                    'Excepteur sint occaecat cupidatat no proident, sunt in culpa qui officia descrunt mellit anim id est laborum.')
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Book an appointment'),
                        Icon(Icons.arrow_right_alt)
                      ],
                    )),
              ))
        ],
      ),
    );
  }
}

void func() {
  List arr = [20, 2, 70, 80, 90, 1, 7, 91, 73, 101];

  arr.forEach((element) {
    if (element == 72 + 1) {
      print(element);
    }
  });
  
  for (int i=0; i<arr.length; i++){
    if(arr[i]== 72 + 1){
      print (arr[i]);
    }
  }
}
