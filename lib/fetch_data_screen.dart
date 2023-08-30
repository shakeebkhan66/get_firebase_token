import 'dart:convert';
import 'package:flutter/material.dart';
import 'Models/OrdersModel.dart';
import 'package:http/http.dart' as http;

class ComplexJsonApiCallScreen extends StatefulWidget {
  const ComplexJsonApiCallScreen({Key? key}) : super(key: key);

  @override
  _ComplexJsonApiCallScreenState createState() => _ComplexJsonApiCallScreenState();
}

class _ComplexJsonApiCallScreenState extends State<ComplexJsonApiCallScreen> {

  // Creating a List of UserModel
  List<OrdersModel> userList = [];
  String token = '6ff8c020bdef2f03c71d210a6cdcb1b1d05a1ec3';

  Future <List<OrdersModel>> getUserApi()async{
    final response = await http.get(
        Uri.parse('http://192.168.100.240:5000/api/myorders/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      }
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      for(Map i in data){
        userList.add(OrdersModel.fromJson(i));
        // // If you simple want to print one simple value then try this
        // print(i['name']);
      }
      return userList;
    }
    else{
      return userList;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Complex Json Api Call"),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getUserApi(),
                builder: (context, AsyncSnapshot<List<OrdersModel>> snapshot){
                  if(!snapshot.hasData){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else{
                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index){
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ReusableRow(
                                  title: "ID",
                                  value: snapshot.data![index].id.toString(),
                                ),
                                ReusableRow(
                                  title: "Username",
                                  value: snapshot.data![index].subTotal.toString(),
                                ),
                                ReusableRow(
                                  title: "Email",
                                  value: snapshot.data![index].discount.toString(),
                                ),
                                ReusableRow(
                                    title: "Quantity",
                                    value: snapshot.data![index].items![0].quantity.toString()
                                ),
                                ReusableRow(
                                    title: "Name",
                                    value: snapshot.data![index].items![0].product?.name.toString()
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        )
    );
  }
}


class ReusableRow extends StatelessWidget {
  String? title;
  String? value;
  ReusableRow({this.title, this.value});
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title!),
          Text(value!),
        ],
      ),
    );
  }
}
