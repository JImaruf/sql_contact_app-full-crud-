import 'package:flutter/material.dart';
import 'package:sqlpractice2/DB/my_db_helper.dart';
import 'package:sqlpractice2/model/contact_model.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameET = TextEditingController();
  TextEditingController numberET = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              future: MyDBHelper.readAllContact(),
              builder: (context, AsyncSnapshot<List<ContactModel>> snapshot) {
                if (snapshot.data == null) {
                  return Text("bye");
                } else {
                  return ListView.builder(
                      reverse: false,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                            color: Colors.orangeAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text("Name:" +
                                              snapshot
                                                  .data![index].contactName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                          Text("Number:" +
                                              snapshot.data![index].contactNo,style: TextStyle(color: Colors.white),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              _showForm(context,
                                                  snapshot.data![index]);
                                            },
                                            icon: Icon(Icons.edit,color: Colors.blue,)),
                                        IconButton(
                                            onPressed: () {
                                              MyDBHelper.deleteContact(
                                                  snapshot.data![index]);
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.delete,color: Colors.red,)),
                                      ],
                                    ),
                                  ),

                                  // IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nameET.text = '';
          numberET.text = '';
          setState(() {});

          _showForm(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showForm(BuildContext cntxt, [ContactModel? contact]) {
    int? targetID = contact?.id;
    bool isEdit = false;
    if (contact != null) {
      isEdit = true;
      if (contact.contactName != "") {
        nameET.text = contact.contactName.toString().trim();
        numberET.text = contact.contactNo.toString().trim();
      }
    }

    showModalBottomSheet(
      context: cntxt,
      backgroundColor: Colors.white,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(cntxt).viewInsets.bottom, //**,
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, //*******
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: nameET,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 3, color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 3, color: Colors.white)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 3, color: Colors.white)),
                  hintText: 'Contact Name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: numberET,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 3, color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 3, color: Colors.white)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 3, color: Colors.white)),
                  hintText: 'Contact Number',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (isEdit) {
                      ContactModel updatedContact = ContactModel(
                          id:targetID,
                          contactName: nameET.text.toString(),
                          contactNo: numberET.text.toString());
                      MyDBHelper.updateContact(updatedContact);
                    } else {
                      ContactModel singleContact = ContactModel(
                          contactName: nameET.text.toString(),
                          contactNo: numberET.text.toString());
                      MyDBHelper.createContact(singleContact);
                    }
                    Navigator.of(context).pop();
                    nameET.text = '';
                    numberET.text = '';
                    setState(() {});
                  },
                  child: Text("Add")),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
