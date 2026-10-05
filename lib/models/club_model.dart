class FootballClub {
  // 1. PRIVATE VARIABLES (Encapsulation - Variabel dibungkus agar aman)
  String _name;
  String _stadium;
  String _info;

  // 2. CONSTRUCTOR (Fungsi yang dipanggil pertama kali saat object dibuat)
  FootballClub(this._name, this._stadium, this._info);

  // 3. GETTER (Fungsi untuk membaca data yang diprivate)
  String get name => _name;
  String get stadium => _stadium;
  String get info => _info;

  // 4. SETTER (Fungsi untuk mengubah data dengan aman/ada validasi)
  set name(String value) {
    if (value.isNotEmpty) {
      _name = value;
    }
  }

  set stadium(String value) {
    if (value.isNotEmpty) {
      _stadium = value;
    }
  }

  set info(String value) {
    if (value.isNotEmpty) {
      _info = value;
    }
  }

  // 5. CUSTOM FUNCTION / METHOD (Perilaku khusus dari object ini)
  String getSummary() {
    return 'Klub $_name memiliki markas kebanggaan di $_stadium. $_info';
  }
}