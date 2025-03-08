String formatDate(DateTime date, {bool stringMonth = false}){
  List<String> yearMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  String day = date.day < 10 ? '0${date.day}'  : date.day.toString();
  String month = "";
  if (stringMonth) {
    month = yearMonths[date.month - 1];
  } else {
    month = date.month < 10 ? '0${date.month}'  : date.month.toString();
  }
  return "$day/$month/${date.year}";
}