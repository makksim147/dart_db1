import 'package:sqlite3/sqlite3.dart';
import '../../domain/technique.dart';

class TechniqueRepository {
  final Database db;

  TechniqueRepository(this.db);

  // --- CRUD Техника ---
  void insertTechnique(Technique technique) {
    db.execute(
      'INSERT OR REPLACE INTO techniques(id,company,country,color,type,model,price) VALUES(?,?,?,?,?,?,?)',
      [
        technique.id,
        technique.company,
        technique.country,
        technique.color,
        technique.type,
        technique.model,
        technique.price,
      ],
    );
  }

  List<Technique> getAllTechniques() {
    final rows = db.select(
      'SELECT id,company,country,color,type,model,price FROM techniques',
    );
    return rows.map((row) => Technique.fromMap(row)).toList();
  }

  void deleteTechnique(String id) {
    db.execute('DELETE FROM techniques WHERE id=?', [id]);
  }

  void updateTechnique(Technique technique) {
    db.execute(
      'UPDATE techniques SET company = ?, country = ?, color = ?, type = ?, model = ?, price = ? WHERE id = ?',
      [
        technique.company,
        technique.country,
        technique.color,
        technique.type,
        technique.model,
        technique.price,
        technique.id,
      ],
    );
  }
}
