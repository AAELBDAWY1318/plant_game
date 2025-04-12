class SQFLiteErrorModel {
  final int status;
  final String errorMessage;
  SQFLiteErrorModel({required this.status, required this.errorMessage});
  factory SQFLiteErrorModel.fromJson(Map<String, dynamic> json) {
    return SQFLiteErrorModel(
      status: json['status'] ?? 500,
      errorMessage: json['errorMessage'] ?? 'Unknown error',
    );
  }
}