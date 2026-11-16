-- =====================================================================
--  LONTAR CAKE PAPUA — Data awal (jalankan SETELAH schema.sql)
-- =====================================================================

-- Produk awal (sama dengan yang tampil di website saat ini).
-- image_url menunjuk ke folder images/ di proyek Vercel Anda.
-- Bisa diganti nanti lewat Admin Panel > Kelola Produk (upload foto).
insert into public.products (name, size, price, stock, image_url, description)
select * from (values
  ('Kue Lontar Original',      'Reguler (22cm)',  75000, 15, 'images/original.jpg',
   'Kue lontar original tradisional dengan susu segar dan telur pilihan, bertekstur lembut dan lumer di mulut.'),
  ('Kue Lontar Original Keju', 'Reguler (22cm)', 120000,  8, 'images/originalKeju.jpg',
   'Porsi lebih besar dengan isian fla susu ekstra tebal dan taburan keju lezat.'),
  ('Kue Lontar Coklat',        'Reguler (22cm)',  90000, 12, 'images/coklat.jpg',
   'Perpaduan manisnya fla susu lontar dengan cokelat premium pilihan yang menggugah selera.'),
  ('Kue Lontar Coklat Keju',   'Reguler (22cm)',  55000, 20, 'images/coklatKeju.jpg',
   'Kue lontar varian coklat keju dalam box cantik, praktis untuk camilan santai.')
) as v(name, size, price, stock, image_url, description)
where not exists (select 1 from public.products);

-- ---------------------------------------------------------------------
-- MENJADIKAN AKUN SEBAGAI ADMIN
-- 1) Daftar dulu lewat website (menu Login / Daftar) memakai email admin.
-- 2) Ganti email di bawah, lalu jalankan baris ini:
-- ---------------------------------------------------------------------
-- update public.profiles set role = 'admin' where email = 'admin@lontarcake.com';
