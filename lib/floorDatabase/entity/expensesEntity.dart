import 'package:floor/floor.dart';
import 'registerEntity.dart';

@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['userId'],
      parentColumns: ['id'],
      entity: RegisterEntity,
    ),
  ],
)
class ExpensesEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final double amount;
  final String? category;
  final String? date;

  @ColumnInfo(name: 'userId')
  final int userId;

  final String? paymentMethod;
  final String? description;
  final String? receiptImagePath;
  final bool? isRecurring;
  final String? tags;

  ExpensesEntity({
    this.id,
    this.category,
    required this.amount,
    this.date,
    required this.userId,
    this.paymentMethod,
    this.description,
    this.receiptImagePath,
    this.isRecurring,
    this.tags,
  });

  @override
  String toString() {
    return 'ExpensesEntity{id: $id, amount: $amount, category: $category, date: $date, userId: $userId, paymentMethod: $paymentMethod, description: $description, tags: $tags}';
  }
}
