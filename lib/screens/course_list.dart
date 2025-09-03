import 'package:dhan_manthan/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // two tabs
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          centerTitle: false,
          title: const Text(
            "Courses",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue,

            tabs: [
              Tab(text: "All Courses"),
              Tab(text: "My Courses"),
            ],
          ),
        ),
        body: TabBarView(children: [allCourses(context), myCourses(context)]),
      ),
    );
  }
}

Widget allCourses(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (builder, ctx) {
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 140,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          course["banner"],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.error, color: Colors.blue),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white54,
                        ),
                        child: Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.blue,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course["title"],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true, // <-- allows line breaking
                            overflow:
                                TextOverflow.visible, // <-- don't clip or fade
                          ),
                          Text(
                            "By Arsh Ku. Mandal",
                            style: TextStyle(fontSize: 11),
                            softWrap: true, // <-- allows line breaking
                            overflow:
                                TextOverflow.visible, // <-- don't clip or fade
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: const Color.fromARGB(
                                    255,
                                    229,
                                    243,
                                    255,
                                  ),
                                ),
                                child: Icon(
                                  CupertinoIcons.book,
                                  color: Colors.blue,
                                  size: 15,
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '10 Lessons',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: const Color.fromARGB(255, 229, 243, 255),
                            ),
                            child: Icon(
                              CupertinoIcons.clock,
                              color: Colors.blue,
                              size: 15,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text('8h 20min.', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // aligns them properly
                        children: [
                          Icon(Icons.currency_rupee, size: 15),
                          Text("1500", style: TextStyle(fontSize: 15)),
                          Spacer(),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: const Color.fromARGB(255, 241, 184, 15),
                          ),
                          SizedBox(width: 2),
                          Text("4.9(1700)", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget myCourses(BuildContext context) {
  return Container();
}
