import 'package:isar/isar.dart';

// WAJIB: Baris ini memberitahu Flutter bahwa nanti akan ada file gaib
// yang dibuat oleh build_runner. Saat ini pasti akan error (garis merah), biarkan saja!
part 'todo_model.g.dart';

// Anotasi @collection memberitahu Isar bahwa ini adalah Tabel/Koleksi Database
@collection
class Todo {
  // Id adalah tipe data wajib dari Isar. autoIncrement artinya angkanya urut otomatis.
  Id id = Isar.autoIncrement;

  // Kolom-kolom data kita
  late String title;
  bool isCompleted = false;

  // --- JAWABAN TUGAS MANDIRI 2 (Eksplorasi Skema Isar) ---
  // Menambahkan kolom prioritas bertipe String
  String? prioritas; 
}