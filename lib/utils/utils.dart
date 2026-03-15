String formatText(String text) {
  List<String> parts = text.split(RegExp(r'[ _-]'));
  String formattedText = parts.map(
      (part) => part[0].toUpperCase() + part.substring(1)).join(" ");
  return formattedText;
}

double round(num number, int dp) {
  return double.parse(number.toStringAsFixed(dp));
}

String month_index_to_str(int index) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return months[index-1];
}