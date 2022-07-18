import 'package:flutter/material.dart';
import 'package:med_connect/screens/shared/header_text.dart';

class ChatsListPage extends StatefulWidget {
  const ChatsListPage({Key? key}) : super(key: key);

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: const HeaderText(
              text: 'Doctors',
              isLarge: true,
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search))
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Divider(),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(indent: 50);
                },
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/humberto-chavez-FVh_yqLR9eA-unsplash.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    title: Text('Dr Amanda Arthur'),
                    subtitle: Text('Great!'),
                    trailing: const CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
            ]),
          )
        ],
      ),
    );
  }
}
