import 'package:flutter/material.dart';
import 'driver.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DCDS',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        backgroundColor:Colors.white ,
        body: Padding(
          padding: EdgeInsets.only(left: 10 ,right: 10),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Image(
                    image: AssetImage('assets/sl_122021_47430_11.jpg'),
                    width: 70,
                    height: 70,
                  ),
                  Text(
                    'DRIVER COGNITIVE DETECTION SYSTEM',
                    textAlign:TextAlign.center,
                    style:TextStyle(
                      color:Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              const Center(
                child: Text(
                  "Your driver's safety is our priority"  ,
                  textAlign:TextAlign.center,
                  style:TextStyle(
                    color:Colors.teal,
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                  ),
                ),
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/Bus driver-rafiki (1).png'),
                  width: 220,
                  height: 220,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Your Drivers"  ,
                  textAlign:TextAlign.center,
                  style:TextStyle(
                    color:Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

              ),
              const SizedBox(
                height: 10,
              ),
      Center(
        child: ElevatedButton(
          onPressed:(){


          },
          style:

          ElevatedButton.styleFrom(
              fixedSize: Size(300, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5, backgroundColor: Colors.teal
          ), child: const Text(
          'Add a driver',
          style: TextStyle(
              color: Colors.white,
              fontSize:17
          ),
        ),
        ),
      ),
              const SizedBox(
                height: 10,
              ),
              buildContainer("Juma Musiu",'Tel : 0721581508',"DCDS: 0748708055", "Route : Superhighway"  , "Car : KAM 0918",'assets/Screenshot 2024-03-07 210642.png',context ),
              const SizedBox(
                height: 10,
              ),
              buildContainer('Charles Oguda','Tel : 0704303341',"DCDS: 0799229429", "Route : Meru"  , "Car : KAB 9012",'assets/Screenshot 2024-03-07 213039.png',context )

            ],
          ),
        )
      ),
    );
  }

  GestureDetector buildContainer(String name , String tel ,String dcds ,String route, String plate ,String imageString, BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Driver(name , dcds)),
        );
      },
      child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20 ,right:20),
                  child: Container(
                    width: 300,
                    height: 120,
                    decoration:  BoxDecoration(

                      color: Colors.white, // Container background color
                      borderRadius: BorderRadius.circular(10), // Rounded corners for a softer look
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Shadow color and opacity
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 3), // Shadow position, determines the direction of the shadow
                        ),
                      ],
                    ),
                    child:   Row(
                      children: [
                        Image(
                          image: AssetImage(imageString),
                          fit: BoxFit.contain,// Adjust the image to cover the transparent area
                          width: 100, // Adjust the image size to fit the container
                          height: 80, // Adjust the image size to fit the container
                        ),


                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                               name ,
                              textAlign:TextAlign.center,
                              style:TextStyle(
                                color:Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                               tel,
                              textAlign:TextAlign.center,
                              style:TextStyle(
                                color:Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              dcds,
                              textAlign:TextAlign.center,
                              style:TextStyle(
                                color:Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                             route,
                              textAlign:TextAlign.center,
                              style:TextStyle(
                                color:Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              plate,
                              textAlign:TextAlign.center,
                              style:TextStyle(
                                color:Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
