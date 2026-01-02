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
class IncomeEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final double amount;
  final String category;
  final String date;
  final bool recurringIncome;
  final String note;
  final String paymentMethod;
  final double taxDeducted;
  final String source;

  @ColumnInfo(name: 'userId')
  final int userId;

  final String createdAt;
  final String updatedAt;

  IncomeEntity({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.userId,
    this.recurringIncome = false,
    this.note = '',
    this.paymentMethod = '',
    this.taxDeducted = 0.0,
    this.source = '',
    required this.createdAt,
    required this.updatedAt,
  });
}
