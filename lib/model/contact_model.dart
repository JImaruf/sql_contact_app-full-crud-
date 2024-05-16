class ContactModel {
final int? id;
final String contactName;
final String contactNo;

ContactModel({this.id, required this.contactName, required this.contactNo});

ContactModel.fromMap(Map<String, dynamic> res):
      id = res["id"],
      contactName = res["contactName"],
      contactNo = res["contactNumber"];


  Map<String, dynamic> toMap()
{
  return {
    'id':id,
      'contactName':contactName,
       'contactNumber':contactNo
};
}


}