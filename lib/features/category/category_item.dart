// All categories from both expense and income sections
import 'package:mactest/features/category/add_category_screen.dart';

final List<CategoryItem> allCategories = [
  // Expense Categories
  CategoryItem(
    title: 'Groceries',
    imagePath: 'assets/Groceries.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Transportation',
    imagePath: 'assets/Transportation.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Utilities',
    imagePath: 'assets/Utilities.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Mobile & Internet',
    imagePath: 'assets/Mobile & Internet.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Rent/Mortgage',
    imagePath:
        'assets/Home.png', // Assuming 'Rent/Mortgage' uses the 'Home' icon
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Healthcare',
    imagePath: 'assets/Healthcare.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Clothing & Shoes',
    imagePath: 'assets/Clothing & Shoes.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Entertainment',
    imagePath: 'assets/Entertainment.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Education',
    imagePath: 'assets/Education.png',
    type: 'Expense',
  ),
  CategoryItem(title: 'Home', imagePath: 'assets/Home.png', type: 'Expense'),
  CategoryItem(title: 'Gifts', imagePath: 'assets/Gifts.png', type: 'Expense'),
  CategoryItem(title: 'Pets', imagePath: 'assets/Pets.png', type: 'Expense'),
  CategoryItem(
    title: 'Sports & Fitness',
    imagePath: 'assets/Sports & Fitness.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Children',
    imagePath: 'assets/Children.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Insurances',
    imagePath: 'assets/Insurances.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Taxes & Fines',
    imagePath: 'assets/Taxes & Fines.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Travel',
    imagePath: 'assets/Travel.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Business Expenses',
    imagePath: 'assets/Business Expenses.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Charity',
    imagePath: 'assets/Charity.png',
    type: 'Expense',
  ),
  CategoryItem(
    title: 'Other',
    imagePath: 'assets/Charity.png',
    type: 'Expense',
  ),

  // Income Categories
  CategoryItem(
    title: 'Salary',
    imagePath:
        'assets/Salary.png', // Assuming 'Salaty.png' is a typo and should be 'Salary.png'
    type: 'Income',
  ),
  CategoryItem(
    title: 'Bonuses',
    imagePath: 'assets/Bonuses.png',
    type: 'Income',
  ),
  CategoryItem(
    title: 'Freelance',
    imagePath: 'assets/Freelance.png',
    type: 'Income',
  ),
  CategoryItem(title: 'Gifts', imagePath: 'assets/Gifts.png', type: 'Income'),
];
