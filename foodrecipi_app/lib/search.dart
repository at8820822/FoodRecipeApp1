import 'dart:convert';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodrecipe_app/model.dart';
import 'package:foodrecipe_app/recipeView.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  String searchQuery;
  Search(this.searchQuery);



  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[]; //List of Recipes
  TextEditingController searchController = TextEditingController();
  List recipeCatList = [{"imgUrl":"https://images.unsplash.com/photo-1680803226168-2e88b17fb35c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=327&q=80","heading":"Noodle"},
    {"imgUrl":"https://media.istockphoto.com/id/1257409635/photo/sweet-potato-banana-curry-with-peanut-butter.jpg?s=1024x1024&w=is&k=20&c=2CBfceQh0Z-USkazTubFINZ70mmOvI67qcC_04mu5rg=","heading":"Chilifoods"},
    {"imgUrl":"https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1887&q=80","heading":"Noodles"},
    {"imgUrl":"https://media.istockphoto.com/id/1474996626/photo/gulab-jamun-in-glass-bowl.jpg?s=2048x2048&w=is&k=20&c=NONRjGHXr52oXo2AbSkU0uzrYMR7_XO7O1y6dB52VOI=","heading":"GalabJamon"},
    {"imgUrl":"https://media.istockphoto.com/id/499932712/photo/raspberry-and-blueberry.jpg?s=2048x2048&w=is&k=20&c=6kL8q0raBXQuToA81rl-1RXqZlwqpjyS56KsOkmxceg=","heading":"Blueberry"},
    {"imgUrl":"https://images.unsplash.com/photo-1604349347116-c9eeaf23700f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1746&q=80","heading":"Rolls"},
    {"imgUrl":"https://media.istockphoto.com/id/1187353191/photo/samosa-famous-asian-snack-food.jpg?s=2048x2048&w=is&k=20&c=w3avHqXvPII1hduG9AmS1kWwNqTAtifdfquwEBvbb4w=","heading":"Samosa "},


  ];


  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=99642e6e&app_key=69abb283e80b6f7664fe0dd3ce369e70";
    var response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    log(data.toString());
    data["hits"].forEach((element) {
      RecipeModel recipeModel = RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      setState(() {
        isLoading = false;
      });
      recipeList.add(recipeModel);
    });
  }
  @override
  initState() {
    getRecipes(widget.searchQuery);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff213A50), Color(0xff071938)],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical ,
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search(
                                          searchController.text)));
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Cook Something!"),),
                        )
                      ],
                    ),
                  ),

                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WHAT DO YOU WANT TO COOK TODAY?",
                        style: TextStyle(fontSize: 33, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Cook Something New!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Container(
                  child: isLoading ?CircularProgressIndicator():  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipeList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeView(  recipeList[index].appurl
                            )));

                          },
                          child: Card(
                            margin: const EdgeInsets.all(20),
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    recipeList[index].appimgUrl,
                                    width: MediaQuery.of(context).size.width,
                                    height: 220,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7),
                                    child: Text(
                                      recipeList[index].applabel,
                                      style: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  height: 40,
                                  width: 100,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.local_fire_department,
                                            color: Colors.deepOrange,
                                          ),
                                          Text(
                                            recipeList[index].appcalories.substring(0,6),
                                            style: TextStyle(
                                              color: Colors.deepPurpleAccent,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  height: 100,
                  child: ListView.builder( itemCount: recipeCatList.length, shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){

                        return Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Search( recipeCatList[index]["heading"])));
                              },
                              child: Card(
                                  margin: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0.0,
                                  child:Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(18.0),
                                          child: Image.network( recipeCatList[index]["imgUrl"], fit: BoxFit.cover,
                                            width: 200,
                                            height: 250,)
                                      ),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    recipeCatList[index]["heading"],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  )
                              ),
                            )
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}



