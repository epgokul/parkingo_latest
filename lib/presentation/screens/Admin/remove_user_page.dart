import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_parkingo/presentation/widgets/custom_circular_progress.dart';

class RemoveUserPage extends StatefulWidget {
  const RemoveUserPage({super.key});

  @override
  State<RemoveUserPage> createState() => _RemoveUserPageState();
}

List<Map<String, dynamic>> usersList = [];

class _RemoveUserPageState extends State<RemoveUserPage> {
  late Future<List<Map<String, dynamic>>> fetchUsersFuture;
  List<bool> isExpanded = [];

  @override
  void initState() {
    super.initState();
    fetchUsersFuture = fetchAndPopulateUsersWithDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                "Users",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchUsersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            CustomCircularProgress(),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Fetching User details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )
                          ]));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No users found."));
                    }

                    final users = snapshot.data!;

                    // Ensure `isExpanded` matches the length of `users`.
                    if (isExpanded.length != users.length) {
                      isExpanded = List.filled(users.length, false);
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var user = users[index];
                        var name = user["displayName"].toString();
                        var email = user["email"].toString();
                        return ExpansionTile(
                          backgroundColor: index % 2 != 0
                              ? Colors.amber[200]
                              : Colors.amber[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text(
                            name,
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: Icon(
                            isExpanded[index]
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                          collapsedBackgroundColor: index % 2 != 0
                              ? Colors.amber[200]
                              : Colors.amber[50],
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onExpansionChanged: (bool value) {
                            setState(() {
                              isExpanded[index] = value;
                            });
                          },
                          children: <Widget>[
                            ListTile(
                              subtitle: Text(
                                email,
                                style: const TextStyle(color: Colors.black87),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchAndPopulateUsersWithDelay() async {
    await Future.delayed(const Duration(seconds: 2)); // Add a 2-second delay
    return fetchAndPopulateUsers();
  }

  Future<List<Map<String, dynamic>>> fetchAndPopulateUsers() async {
    try {
      final ref = FirebaseFirestore.instance.collection('user');
      final querySnapshot = await ref.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint("Error fetching users: $e");
      return [];
    }
  }
}
