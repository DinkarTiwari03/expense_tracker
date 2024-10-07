//convert Datetime object to a string yyyymmdd
String convertDateTineToString(DateTime dateTime){
  //year in the formate -> yyyy
  String year = dateTime.year.toString();
  
  //month in the formate -> mm
  String month = dateTime.month.toString();
  if(month.length == 1){
    month='0$month';
  }

  //day in the formate ->
  String day = dateTime.day.toString();
  if(day.length==1){
    day= '0$day';
  }

//final formate -> yyyymmdd
String yyyymmdd = year + month + day;
 
 return yyyymmdd;

}