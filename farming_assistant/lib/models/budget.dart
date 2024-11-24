class Budget{
  String id;
  double revenue;
  double expenses;

  Budget(this.id, this.revenue, this.expenses);

  static fromJson(jsonData) {
    return Budget(
      jsonData['id'],
      jsonData['revenue'],
      jsonData['expenses'],
    );
  }
}
