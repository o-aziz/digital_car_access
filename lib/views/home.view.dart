import 'package:car_app/notifiers/driver.notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<TextEditingController> driverName = [];
  List<TextEditingController> driverlastName = [];
  List<TextEditingController> driverTel = [];
  bool isLoading = false;
  bool isLocked = false;
  @override
  void initState() {
    driverName.add(TextEditingController());
    driverlastName.add(TextEditingController());
    driverTel.add(TextEditingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digital Access Car	"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox(
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    controlCarBloc(size),
                    const SizedBox(height: 20),
                    showDriversBloc(size),
                    const SizedBox(height: 20),
                    addDriversBloc(size, context),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.black26,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Container showDriversBloc(Size size) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Show Drivers",
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<QuerySnapshot>(
            future: getDriversData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Wrap(
                  children: snapshot.data!.docs.map((DocumentSnapshot e) {
                    Map<String, dynamic> data =
                        e.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: size.width * 0.6,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Name : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.04,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${data["name"]}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.width * 0.04,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "LaseName : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.04,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${data["laseName"]}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.width * 0.04,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Telephone : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.04,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${data["tel"]}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.width * 0.04,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Container addDriversBloc(Size size, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Add Drivers",
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            Provider.of<DriverNotifier>(context, listen: false).length,
            (index) => Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Column(
                    children: [
                      TextField(
                        controller: driverName.asMap().containsKey(index)
                            ? driverName[index]
                            : TextEditingController(),
                        decoration:
                            const InputDecoration(hintText: 'Driver Name'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: driverlastName.asMap().containsKey(index)
                            ? driverlastName[index]
                            : TextEditingController(),
                        decoration:
                            const InputDecoration(hintText: 'Driver Last Name'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: driverTel.asMap().containsKey(index)
                            ? driverTel[index]
                            : TextEditingController(),
                        decoration:
                            const InputDecoration(hintText: 'Driver telephone'),
                      ),
                      const SizedBox(height: 10),
                      removeItemBtn(context, index, size),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
          addItemBtn(context, size),
          const SizedBox(height: 10),
          addDrivers(context, size)
        ],
      ),
    );
  }

  InkWell addDrivers(BuildContext context, Size size) {
    return InkWell(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        for (var i = 0;
            i < Provider.of<DriverNotifier>(context, listen: false).length;
            i++) {
          await createDriversData({
            "name": driverName.asMap().containsKey(i) ? driverName[i].text : "",
            "laseName": driverlastName.asMap().containsKey(i)
                ? driverlastName[i].text
                : "",
            "tel": driverTel.asMap().containsKey(i) ? driverTel[i].text : ""
          });
        }
        // ignore: use_build_context_synchronously
        Provider.of<DriverNotifier>(context, listen: false).length = 1;

        setState(() {
          driverName = [];
          driverlastName = [];
          driverTel = [];
          driverlastName.add(TextEditingController());
          driverName.add(TextEditingController());
          driverTel.add(TextEditingController());
          driverName[0].text = "";
          driverlastName[0].text = "";
          driverTel[0].text = "";
          isLoading = false;
        });
      },
      child: Container(
        width: size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: const Color(0xff28A745),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.save,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "SAUVGARDER",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector addItemBtn(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Provider.of<DriverNotifier>(context, listen: false).length++;
        driverName.add(TextEditingController());
        driverlastName.add(TextEditingController());
        driverTel.add(TextEditingController());
      },
      child: Container(
        width: size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: const Color(0xff28A745),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Ajouter",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector removeItemBtn(BuildContext context, int index, Size size) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<DriverNotifier>(context, listen: false).length > 1) {
          Provider.of<DriverNotifier>(context, listen: false).length--;

          if (driverName.asMap().containsKey(index)) {
            driverName.removeAt(index);
          }
          if (driverlastName.asMap().containsKey(index)) {
            driverlastName.removeAt(index);
          }
          if (driverTel.asMap().containsKey(index)) {
            driverTel.removeAt(index);
          }
        }
      },
      child: Container(
        width: size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: const Color(0xffDC3545),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.close,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Retirer",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  Container controlCarBloc(Size size) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: size.height * 0.15,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Control Vehicule",
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                isLocked = !isLocked;
              });
              lockUnlockCar(isLocked);
            },
            child: Container(
              color: Colors.blue,
              width: size.width * 0.5,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLocked
                      ? const Icon(
                          Icons.lock,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
                  const SizedBox(width: 5),
                  Text(
                    isLocked ? "car is locked" : "car is unlocked",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future createDriversData(Map<String, dynamic> driverDataMap) async {
  User user = FirebaseAuth.instance.currentUser!;
  CollectionReference ref = FirebaseFirestore.instance.collection(user.uid);
  return ref.add(
    driverDataMap,
  );
}

Future<QuerySnapshot<dynamic>> getDriversData() async {
  User user = FirebaseAuth.instance.currentUser!;
  CollectionReference ref = FirebaseFirestore.instance.collection(user.uid);
  return ref.get();
}

Future lockUnlockCar(bool isLocked) async {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  return await ref.set({
    "lock": isLocked,
  });
}
