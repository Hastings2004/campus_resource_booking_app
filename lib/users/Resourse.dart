import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resource_booking_app/components/AppBar.dart';
import 'package:resource_booking_app/components/ResourceDetails.dart';
import 'package:resource_booking_app/users/Booking.dart';
import 'package:resource_booking_app/users/Home.dart';
import 'package:resource_booking_app/users/Profile.dart';
import 'package:resource_booking_app/users/Settings.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  _ResourseScreenState createState() => _ResourseScreenState();
}

class _ResourseScreenState extends State<ResourcesScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  final CollectionReference items = FirebaseFirestore.instance.collection(
    "products",
  );

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  /*List<String> docIDs = [];

  Future<void> getDocIDs() async {
    final snapshot = await FirebaseFirestore.instance.collection('resources').get();
    docIDs = snapshot.docs.map((doc) => doc.id).toList();
    setState(() {}); // Trigger a rebuild to show the data
  }

  @override
  void initState() {
    super.initState();
    getDocIDs(); // Call getDocIDs when the widget is created
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Resources",
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 20, 148, 24),
              ),
              child: Column(

                children: [
                  Image.asset(
                      "assets/images/logo.png",
                      height: 50
                  ),
                  const Text(
                    'Mzuzu University',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Campus Resource Booking',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: const Text('Resources'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResourcesScreen()));
              },
            ),
            ListTile(
              title: const Text('Booking'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookingScreen()));
              },
            ),
            ListTile(
              title: const Text('Setings'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                logout();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Text(
                  "${user.email!}",
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),

              ),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: items.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document =
                  streamSnapshot.data!.docs[index];
                    String? photoUrl = document['image']; // Assuming your field name is 'photo'

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: InkWell( // <--- Added InkWell here
                      onTap: () {
                        // Navigate to the detail screen, passing the entire document
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResourceDetails(
                              resourceDocument: document, // Pass the document to ResourceDetails
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),

                          // Ensure photoUrl is not null before trying to use Image.asset
                          if (photoUrl != null && photoUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                photoUrl,
                                height: 300, // Adjusted height for better card appearance
                                width: double.infinity, // Make image take full width
                                fit: BoxFit.cover,
                                
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 100); // Fallback icon
                                },
                              ),
                            )
                          else
                            const SizedBox(
                              height: 200,
                              child: Center(child: Text("No Image Available")),
                            ),
                           
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    document['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green
                                    ),
                                  ),
                              ),
                              
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text(
                                    document['status'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue
                                    ),
                                  ),
                               ),
                             
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (streamSnapshot.hasError) {
            return Center(child: Text('Error: ${streamSnapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}