class DataEntry{
  final String date;
  final double value;

  DataEntry({required this.date, required this.value});

  // Function to create a DataEntry from a JSON map
  factory DataEntry.fromJson(Map<String, dynamic> json) {
    return DataEntry(
      date: json['date'],
      value: json['value'], 
      );
  }

  // Convert a DataEntry to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'value': value,
    };
  }
}