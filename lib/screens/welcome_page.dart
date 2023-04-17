import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskrbuy/screens/home_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.white,
      body: Center( 
        child: Container( 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.center, 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              CircleAvatar( 
                radius: 80,
                backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL??'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRYzhNsqmP0EEMyFFaatZ08zR6n3crc01ZZlINvBzu9w&usqp=CAU&ec=48600113'),
              ), 
              SizedBox(height: 10,),
              Text("Welcome ${FirebaseAuth.instance.currentUser!.email}"), 
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){ 
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
              }, child: Text('Next'))
            ],
          ),
        ),
      ),
    );
  }
}