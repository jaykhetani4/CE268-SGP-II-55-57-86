class User
{
  // int user_id;
  String user_name;
  String user_mobile_num;
  String parents_mobile_num;
  String user_password;

  User(
      // this.user_id,
      this.user_name,
      this.user_mobile_num,
      this.parents_mobile_num,
      this.user_password,
      );
  Map<String,dynamic> toJson()=>
      {
        // 'user_id' :user_id.toString(),
        'user_name' :user_name,
        'user_mobile_num' :user_mobile_num,
        'parents_mobile_num' :parents_mobile_num,
        'user_password' :user_password,
      };
}