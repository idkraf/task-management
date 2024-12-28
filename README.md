# task_management

A new Flutter project.

## Build model if there a changes on script with build_runner
```
flutter pub run build_runner build
```

# Studi Kasus Bangun aplikasi Task Management sederhana 

## Authentication:
- Login menggunakan email dan password. (Done)
- Validasi form login (contoh: email harus valid, password minimal 8 karakter). (Done)
- Gunakan mock API untuk endpoint login (contoh: https://reqres.in). (Done)

## Task Management: 
- Tampilkan daftar tugas dalam bentuk listview. (Done)
- Fitur CRUD (Create, Read, Update, Delete) untuk tugas. (Done)

### Task memiliki atribut berikut:
- Title (String, maksimal 50 karakter). (Done)
- Description (String, opsional). (Done)
- Due Date (Date, wajib diisi). (Done)
- Status (Enum: Pending, In Progress, Completed). (Done)
- Data disimpan menggunakan SQLite atau Hive (state lokal). (Done)

## Search and Filter:
- Implementasikan pencarian berdasarkan title. (Done)
- Filter daftar tugas berdasarkan status. (Done)

## Offline Mode:
- Aplikasi tetap dapat digunakan tanpa koneksi internet. (Done)
- Data akan disinkronkan ke mock API ketika koneksi internet kembali tersedia. (Done)
- Gunakan Bloc untuk manajemen state. (Done)
- UI/UX menggunakan Material Design dengan animasi dasar (contoh: animasi transisi halaman atau efek klik pada tombol).
- Penulisan unit test untuk logika utama (contoh: validasi form login, manipulasi status tugas). (Done)
- Implementasi JSON Serializeable (Done)
- Implementasi depedency injection (Done)

## Bonus (Opsional)
- Implementasi Push Notification untuk mengingatkan pengguna tentang tugas yang mendekati Due Date. (Done)
- Implementasi Dark Mode / Light Mode  (Done)
