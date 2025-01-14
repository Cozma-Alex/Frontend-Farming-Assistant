/// Budget model
/// Represents the budget of the company in the database having the following fields:
/// - id: UUID (primary key)
/// - revenue: double (the money that the company makes)
/// - expenses: double (the money that the company spends)
class Budget{
  String id;
  double revenue;
  double expenses;

  Budget(this.id, this.revenue, this.expenses);

  static fromJson(Map <String, dynamic> jsonData) {
    return Budget(
      jsonData['id'],
      jsonData['revenue'],
      jsonData['expenses'],
    );
  }

  static toJson(Budget budget) {
    return {
      'id': budget.id,
      'revenue': budget.revenue,
      'expenses': budget.expenses,
    };
  }

}
