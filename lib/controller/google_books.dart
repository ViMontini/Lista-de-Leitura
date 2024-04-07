import 'package:google_books_api/google_books_api.dart';

Future<List<Book>> fetchBooks() async {
  final List<Book> books = await const GoogleBooksApi().searchBooks(
    'book',
    maxResults: 20,
    printType: PrintType.books,
    orderBy: OrderBy.relevance,
  );

  return books;
}
