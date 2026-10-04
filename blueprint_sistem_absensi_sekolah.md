# Blueprint Sistem Absensi & Monitoring Siswa Berbasis QR Code ID Card (SMP & SMA)

## 1. Pendahuluan & Latar Belakang
Sistem ini dirancang untuk mendigitalkan proses pencatatan kehadiran siswa di tingkat SMP dan SMA, sekaligus memberikan transparansi penuh kepada orang tua murid secara real-time. Dengan memanfaatkan kamera smartphone guru/petugas untuk memindai kartu pelajar (ID Card) ber-QR code, sekolah dapat menghemat biaya pengadaan alat pemindai fisik (*barcode scanner hardware*) tanpa mengurangi efisiensi dan akurasi absensi.

---

## 2. Aktor & Peran Pengguna (User Roles)

```mermaid
flowchart TD
    Admin["👨‍💼 Admin Sekolah / TU"] -->|Kelola Data & Cetak Kartu| Sys[Sistem Absensi Terpusat]
    Guru["👩‍🏫 Guru / Wali Kelas"] -->|Scan QR Siswa & Info Tidak Masuk| Sys
    Ortu["👨‍👩‍👧 Orang Tua Murid"] -->|Pantau Kehadiran & Jadwal Anak| Sys
    Sys -->|Notifikasi & Riwayat| Ortu
```

| Peran | Tanggung Jawab Utama | Platform Akses |
| :--- | :--- | :--- |
| **Admin Sekolah / Tata Usaha (TU)** | • Mengelola data master siswa, kelas, guru, dan mata pelajaran.<br>• Mengatur jadwal pelajaran mingguan (Senin–Jumat/Sabtu).<br>• Menghasilkan (generate) data QR Code dan mencetak ID Card siswa.<br>• Monitoring laporan kehadiran sekolah secara menyeluruh. | Web Dashboard |
| **Guru / Pengajar** | • Login ke aplikasi mobile.<br>• Melakukan *scanning* QR code ID Card siswa menggunakan kamera HP pada jam mata pelajaran atau jam piket gerbang.<br>• Melihat jadwal mengajar mingguan.<br>• Mengisi dispensasi/status kehadiran (Hadir, Sakit, Izin, Alpa).<br>• Mengirimkan notifikasi izin/berhalangan hadir jika guru tidak dapat mengajar ke sistem/orang tua. | Mobile App (Android/iOS) |
| **Orang Tua Murid** | • Login ke aplikasi mobile menggunakan kredensial khusus yang terhubung dengan akun siswa.<br>• Melihat status absensi harian anak (apakah sudah sampai di sekolah atau belum).<br>• Melihat absensi per mata pelajaran anak secara real-time.<br>• Memantau jadwal mata pelajaran mingguan anak.<br>• Menerima notifikasi jika ada guru mata pelajaran yang berhalangan hadir. | Mobile App (Android/iOS) |

---

## 3. Alur Proses Bisnis Utama (Core Workflows)

### 3.1. Alur Absensi Siswa via Scan QR Code
```mermaid
sequenceDiagram
    autonumber
    actor S as Siswa (Bawa ID Card)
    actor G as Guru Mapel / Guru Piket
    participant App as Mobile App Guru
    participant API as Backend Server
    participant DB as Database
    actor P as Orang Tua

    S->>G: Menunjukkan ID Card (QR Code)
    G->>App: Buka menu Scan & pilih Mapel/Piket
    App->>App: Kamera HP memindai QR Code
    App->>API: POST /api/attendance/scan (qr_token, schedule_id, timestamp)
    API->>DB: Validasi token siswa & jadwal aktif
    DB-->>API: Data valid & simpan record presensi
    API-->>App: Feedback status (Berhasil: "Siswa A - Hadir")
    API-->>P: Push Notification / Update Status ("Anak Anda telah hadir di kelas X")
```

### 3.2. Alur Pelaporan Guru Berhalangan Hadir
```mermaid
sequenceDiagram
    autonumber
    actor G as Guru
    participant App as Mobile App Guru
    participant API as Backend Server
    participant DB as Database
    actor P as Orang Tua

    G->>App: Pilih Jadwal Mengajar & Klik "Berhalangan Hadir"
    G->>App: Masukkan alasan (Sakit/Dinas) & tugas belajar mandiri (opsional)
    App->>API: POST /api/teacher-absence (schedule_id, date, reason, notes)
    API->>DB: Simpan status guru & flag jadwal hari tsb
    API-->>P: Kirim notifikasi: "Guru Mapel Matematika berhalangan hadir pada jam ke-3. Tugas telah dicatat."
```

---

## 4. Desain Struktur Data & Database (ERD)

```mermaid
erDiagram
    USERS ||--o{ TEACHERS : "has profile"
    USERS ||--o{ PARENTS : "has profile"
    PARENTS ||--|{ PARENT_STUDENTS : "connects"
    STUDENTS ||--|{ PARENT_STUDENTS : "belongs to"
    CLASSES ||--o{ STUDENTS : "contains"
    CLASSES ||--o{ SCHEDULES : "has"
    SUBJECTS ||--o{ SCHEDULES : "taught in"
    TEACHERS ||--o{ SCHEDULES : "teaches"
    SCHEDULES ||--o{ ATTENDANCES : "records"
    STUDENTS ||--o{ ATTENDANCES : "has"
    SCHEDULES ||--o{ TEACHER_ABSENCES : "has note"

    USERS {
        uuid id PK
        string email
        string password
        enum role "admin, teacher, parent"
    }

    STUDENTS {
        uuid id PK
        string nisn UK
        string full_name
        uuid class_id FK
        string qr_token UK
        string photo_url
    }

    PARENTS {
        uuid id PK
        uuid user_id FK
        string full_name
        string phone_number
    }

    TEACHERS {
        uuid id PK
        uuid user_id FK
        string nip UK
        string full_name
        string phone_number
    }

    CLASSES {
        uuid id PK
        string name "Contoh: VII-A, X-IPA-1"
        string grade "SMP / SMA"
        string academic_year
    }

    SUBJECTS {
        uuid id PK
        string name "Contoh: Matematika, B. Inggris"
        string code
    }

    SCHEDULES {
        uuid id PK
        uuid class_id FK
        uuid subject_id FK
        uuid teacher_id FK
        enum day_of_week "Senin-Sabtu"
        time start_time
        time end_time
    }

    ATTENDANCES {
        uuid id PK
        uuid student_id FK
        uuid schedule_id FK
        date date
        timestamp check_in_time
        enum status "hadir, izin, sakit, alpa"
        uuid scanned_by FK
    }

    TEACHER_ABSENCES {
        uuid id PK
        uuid schedule_id FK
        date date
        string reason
        text assignment_notes
    }
```

---

## 5. Fitur Rinci per Modul

### A. Modul Master & Kartu Siswa (Web Admin)
1. **Manajemen Pengguna & Rombel**: CRUD Siswa, Kelas, Guru, Jadwal Pelajaran (Senin s.d. Jumat/Sabtu).
2. **Generator Kartu Pelajar (ID Card Generator)**:
   - Membuat kartu siap cetak (ukuran standar ID Card CR80).
   - Menanamkan QR Code berisi hash unik (`qr_token`), bukan plain text NISN, untuk keamanan data.
   - Ekspor template ID Card ke format PDF untuk dicetak massal.

### B. Modul Guru (Mobile App)
1. **Scanner QR Kamera Bawaan HP**:
   - Deteksi cepat (*fast continuous scan*) tanpa perlu menekan tombol ulang setiap ganti siswa.
   - Umpan balik suara/getar jika siswa berhasil ter-scan.
2. **Presensi Manual & Rekap Kelas**:
   - Tombol pengganti manual jika kartu siswa tertinggal/hilang (pilih Sakit, Izin, atau Alpa).
3. **Pemberitahuan Guru Berhalangan Hadir**:
   - Form izin guru untuk jam mengajar tertentu, dilengkapi pesan/tugas pengganti yang diteruskan ke orang tua dan wali kelas.

### C. Modul Orang Tua (Mobile App)
1. **Dashboard Monitoring Real-time**:
   - Indikator status anak hari ini: *Belum Hadir*, *Di Sekolah*, *Sedang Mengikuti Mapel [X]*, atau *Izin/Sakit*.
2. **Jadwal Pelajaran Lengkap**:
   - Kalender/daftar mata pelajaran Senin s.d. Jumat/Sabtu.
   - Status kehadiran di tiap slot jam pelajaran (misal: Jam 1 Matematika - Hadir, Jam 2 Bahasa Indonesia - Hadir).
3. **Pusat Notifikasi**:
   - Riwayat notifikasi masuk sekolah.
   - Informasi resmi jika guru mata pelajaran berhalangan hadir.

---

## 6. Rekomendasi Arsitektur Teknologi

```mermaid
graph LR
    subgraph Client [Frontend & Mobile]
        AppGuru["Flutter App (Guru)"]
        AppOrtu["Flutter App (Orang Tua)"]
        WebAdmin["React / Blade Web (Admin TU)"]
    end

    subgraph Server [Backend & Storage]
        API["REST API (Laravel / Express / Go)"]
        DB[("PostgreSQL / MySQL")]
        FCM["Firebase Cloud Messaging (Notifikasi)"]
    end

    AppGuru -->|Scan & Absensi| API
    AppOrtu -->|Pantau Kehadiran| API
    WebAdmin -->|Kelola Data| API
    API --> DB
    API --> FCM
    FCM -->|Push Notif Realtime| AppOrtu
```

- **Mobile Client**: **Flutter** (Dart) – Dapat dibuat 1 aplikasi dengan multi-role login, atau 2 aplikasi terpisah. Mendukung pemindaian kamera cepat dengan library `mobile_scanner`.
- **Backend API**: **Laravel (PHP)** atau **Node.js (NestJS / Express)** – Laravel sangat cepat untuk integrasi Web Admin (menggunakan FilamentPHP) dan menyediakan API authentication (Sanctum/JWT).
- **Database**: **PostgreSQL** atau **MySQL** – Relasional, stabil untuk relasi data jadwal dan presensi.
- **Push Notification**: **Firebase Cloud Messaging (FCM)** – Gratis, efisien untuk notifikasi instan ke HP orang tua.
