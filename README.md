# Aisyah Syifa Karima H1D023043_Tugas7 – Portfolio App (Flutter)

Aplikasi **Portfolio Project** sederhana yang memungkinkan pengguna menambah, mengedit, melihat, dan menghapus proyek secara offline. Data disimpan menggunakan **SharedPreferences**, dengan navigasi berbasis **routes**, **drawer menu**, dan halaman login sederhana.

---

## ✨ Fitur Utama

* Login sederhana dengan penyimpanan profil lokal
* CRUD project (tambah, lihat, edit, hapus)
* Drawer navigasi: Home, Add Project, Settings, Logout
* Routing terpusat dengan `onGenerateRoute`
* Penyimpanan data lokal menggunakan SharedPreferences
* UI sederhana & mudah dikembangkan

---

## 📂 Struktur Proyek

```
lib/
├── main.dart
├── routes.dart
├── models/
│   └── project.dart
├── services/
│   └── storage_service.dart
├── widgets/
│   └── app_drawer.dart
└── screens/
    ├── login_page.dart
    ├── home_page.dart
    ├── add_project_page.dart
    ├── project_detail_page.dart
    └── settings_page.dart
```

---

🖼️ Screenshot
<table> <tr> <td align="center"><b>Login</b><br> <img width="260" src="https://github.com/user-attachments/assets/6c2e1869-4052-4f60-ae49-91dd5afb6849" /> </td> <td align="center"><b>Home</b><br> <img width="260" src="https://github.com/user-attachments/assets/c405cdb6-bce7-438a-a734-1703456de8b1" /> </td> </tr> <tr> <td align="center"><b>Sidebar</b><br> <img width="260" src="https://github.com/user-attachments/assets/858cf0bf-1a42-4870-bb8b-861bdc01f556" /> </td> <td align="center"><b>Add Project</b><br> <img width="260" src="https://github.com/user-attachments/assets/be4d36a4-9fca-4542-ae89-c596ece4cbaa" /> </td> </tr> <tr> <td align="center"><b>Detail</b><br> <img width="260" src="https://github.com/user-attachments/assets/70516678-885b-4576-ba4f-2fcfd367ba4d" /> </td> <td align="center"><b>Settings</b><br> <img width="260" src="https://github.com/user-attachments/assets/bbce41e0-396a-4aff-8d54-d772cf670c50" /> </td> </tr> </table>

---

## 🧩 Penjelasan Kode Penting

### **main.dart**

* `runApp(MyApp())` sebagai entry point.
* `MaterialApp` mengatur tema, route awal, dan routing generator.
* `initialRoute` bergantung pada status login di `StorageService`.

### **routes.dart**

* `Routes.generate()` mencocokkan nama route dan mengembalikan `MaterialPageRoute`.
* Halaman detail menerima argumen `Project`.

### **models/project.dart**

* Struktur data proyek: `id`, `title`, `description`, `tags`, `createdAt`.
* `fromMap/toMap` & `fromJson/toJson` untuk serialisasi SharedPreferences.

### **storage_service.dart**

* Mengelola SharedPreferences (mirip singleton).
* Auth: `is_logged_in`, `user_profile`.
* CRUD Project: `getProjects`, `addProject`, `updateProject`, `deleteProject`.

### **login_page.dart**

* Mode login/register otomatis.
* Login/register menyimpan profil user + flag `is_logged_in`.

### **home_page.dart**

* Menampilkan list project dari storage.
* Tap item → halaman detail.

### **add_project_page.dart**

* Form tambah/edit project.
* Parsing tag via `split(',')`.

### **project_detail_page.dart**

* Menampilkan detail + tombol edit & hapus.

### **settings_page.dart**

* Menampilkan profil user dan aksi logout.

---

## 📜 Catatan

* Seluruh data disimpan lokal (tanpa backend).
* Password tidak di-enkripsi karena hanya untuk kebutuhan praktikum.
* Aplikasi dapat dengan mudah dikembangkan (tambah gambar, kategori, export/import JSON, dsb).

---
