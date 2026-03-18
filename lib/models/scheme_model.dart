class SchemeModel {
  final String id;
  final String title;
  final String description;
  final String eligibility;
  final String benefits;
  final String documents;
  final String applicationProcess;
  final String department;
  final DateTime lastDate;

  SchemeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eligibility,
    required this.benefits,
    required this.documents,
    required this.applicationProcess,
    required this.department,
    required this.lastDate,
  });
}