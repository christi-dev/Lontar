# Database Lontar Cake Papua (Supabase)

Website sekarang memakai **Supabase**: PostgreSQL + login email/password + realtime + penyimpanan foto.

## Isi paket

| File | Fungsi |
|---|---|
| `index.html` | Website versi baru, sudah terhubung ke Supabase (ganti `index.html` lama) |
| `supabase/schema.sql` | Membuat tabel, keamanan (RLS), fungsi checkout, realtime, storage foto |
| `supabase/seed.sql` | Mengisi 4 produk awal + perintah menjadikan akun admin |

## Struktur tabel

```
auth.users (bawaan Supabase: email + password)
   │ 1:1 (otomatis lewat trigger saat daftar)
profiles ── id, full_name, email, phone, role ('user' | 'admin')
   │ 1:N
orders ──── id (ORD-XXXXXX), user_id, customer_name, address, payment_method,
   │        subtotal, shipping_fee, total, status, created_at, updated_at
   │ 1:N
order_items ─ order_id, product_id, product_name, price, quantity   (snapshot harga saat beli)
                 │ N:1
products ──── id, name, size, price, stock, image_url, description, is_active

notifications ─ user_id (untuk customer) / for_admin (untuk admin), text, is_read
```

**Aturan keamanan yang berlaku di database (bukan hanya di tampilan):**
- Pengunjung bisa melihat produk; harus login untuk memesan.
- Pesanan hanya bisa dibuat lewat fungsi `place_order`: harga diambil dari tabel produk, stok dicek & dikurangi otomatis, gagal semua jika stok kurang.
- Customer hanya melihat pesanan & notifikasinya sendiri, tidak bisa mengubah status, harga, atau menjadikan dirinya admin.
- Admin melihat semua pesanan, mengubah status (customer otomatis dapat notifikasi), dan mengelola produk + foto.

## Langkah pemasangan (±15 menit)

1. **Buat proyek** di <https://supabase.com> → *New project* (pilih region Singapore agar cepat dari Papua).
2. **Jalankan SQL**: menu *SQL Editor* → *New query* → tempel isi `supabase/schema.sql` → **Run**. Lalu ulangi untuk `supabase/seed.sql`.
3. **Ambil kunci API**: *Project Settings → API*. Salin **Project URL** dan **anon public key**, lalu isi di `index.html` (sekitar baris 65):
   ```js
   const SUPABASE_URL = "https://xxxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJhbGciOi...";
   ```
   *anon key* memang aman ditaruh di website. **Jangan** pernah menaruh *service_role key*.
4. **Pengaturan login**: *Authentication → URL Configuration* → isi *Site URL* dengan `https://lontarpapua.vercel.app`.
   Untuk uji coba cepat, Anda bisa mematikan *Authentication → Sign In / Providers → Email → Confirm email* agar akun baru bisa langsung login tanpa verifikasi email.
5. **Foto produk**: buat folder `images/` di proyek, isi dengan 4 foto bernama `original.jpg`, `originalKeju.jpg`, `coklat.jpg`, `coklatKeju.jpg` (lihat cara cepat di bawah). Alternatifnya, upload foto lewat *Admin Panel → Kelola Produk → Edit*.
6. **Buat akun admin**: buka website → *Login / Daftar* → daftar dengan email admin Anda. Lalu di *SQL Editor* jalankan:
   ```sql
   update public.profiles set role = 'admin' where email = 'email-admin-anda@contoh.com';
   ```
   Logout lalu login lagi; menu **Admin Dashboard** akan muncul.
7. **Deploy**: commit `index.html` + folder `images/` ke repo, Vercel akan deploy otomatis.

### Cara cepat mengambil 4 foto dari website lama
Sebelum mengganti `index.html`, buka <https://lontarpapua.vercel.app>, tekan **F12 → Console**, tempel lalu Enter:
```js
const s=[...document.scripts].find(s=>s.type==='text/babel').textContent;
[...s.matchAll(/(\w+):\s*"(data:image\/jpeg;base64,[^"]+)"/g)].forEach(([_,n,d])=>{const a=document.createElement('a');a.href=d;a.download=n+'.jpg';a.click();});
```
Browser akan mengunduh 4 file dengan nama yang sudah sesuai. Pindahkan ke folder `images/`.

## Yang berubah di website

- **Login sungguhan** dengan email + password (+ lupa password). Mode admin tidak lagi bisa dibuka hanya dengan mengetik `admin@lontarcake.com`.
- Produk, stok, pesanan, dan notifikasi tersimpan permanen di database dan tetap ada setelah refresh.
- Tracking & notifikasi **real-time**: customer melihat status berubah begitu admin mengubahnya.
- Tombol "Stok Habis" otomatis; keranjang tetap tersimpan saat refresh.
- Tracking menampilkan rincian item & riwayat pesanan.
- Admin Panel: ringkasan (total pesanan, omzet, stok menipis) + tab baru **Kelola Produk** (tambah/edit/hapus, ubah harga & stok, upload foto).
- Integrasi Google Sheets lama dihapus.

## Melihat data
Buka *Table Editor* di dashboard Supabase untuk melihat & mengekspor (CSV) semua pesanan dan produk.
