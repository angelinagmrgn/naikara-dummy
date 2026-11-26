-- ============================================================================
-- TABEL `scraped_jobs` UNTUK PIPELINE WEB SCRAPER ENGINEER NAIKARA
-- Jalankan SQL ini di Supabase -> SQL Editor -> New Query -> Run
-- ============================================================================

create table if not exists public.scraped_jobs (
  id uuid default gen_random_uuid() primary key,
  external_job_id text unique, -- ID unik dari portal asal (untuk mencegah duplikat saat upsert)
  source text not null, -- Contoh: 'Jobstreet Indonesia', 'Glints', 'LinkedIn', 'Kalibrr'
  title text not null,
  company text not null,
  location text,
  work_mode text default 'on-site', -- 'remote', 'hybrid', atau 'on-site'
  employment_type text default 'full-time', -- 'full-time', 'contract', 'internship', 'freelance'
  experience_level text default 'junior', -- 'entry', 'junior', 'mid', 'senior'
  salary_min numeric default 0,
  salary_max numeric default 0,
  salary_display text, -- Contoh: 'Rp 6.000.000 – 7.000.000' atau 'Rp 0 – 0'
  match_score integer default 50, -- Skor kecocokan AI (0 - 100)
  skills text[] default '{}', -- Array skill chips, misal: ARRAY['Microsoft', 'Attention', 'Collaboration']
  extra_skill_text text, -- Contoh: 'Microsoft Excel' atau 'Google Docs'
  description text,
  source_url text not null, -- Link langsung ke lowongan asli untuk tombol Lamar
  is_active boolean default true,
  scraped_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Aktifkan Row Level Security (RLS)
alter table public.scraped_jobs enable row level security;

-- Semua user yang login (maupun anonim untuk preview) bisa membaca daftar lowongan aktif
create policy "Anyone can read active scraped jobs"
  on public.scraped_jobs for select
  using (is_active = true);

-- Contoh insert data awal agar langsung tampil saat testing:
insert into public.scraped_jobs (
  external_job_id, source, title, company, location, work_mode,
  employment_type, experience_level, salary_min, salary_max, salary_display,
  match_score, skills, extra_skill_text, description, source_url
) values
(
  'js-sample-001',
  'Jobstreet Indonesia',
  'Field Maintenance Administrator (Offshore)',
  'PT Trilink Indonesia',
  'Jakarta',
  'on-site',
  'full-time',
  'junior',
  0, 0, 'Rp 0 – 0',
  58,
  ARRAY['Microsoft', 'Attention', 'Collaboration'],
  'Microsoft Excel',
  'Mengelola administrasi pemeliharaan lapangan (offshore), pencatatan laporan harian, dan koordinasi dokumen teknis.',
  'https://id.jobstreet.com/'
),
(
  'glints-sample-002',
  'Glints',
  'Secretary',
  'PT Atlas Reinsurance Broker',
  'Jakarta Pusat, DKI Jakarta, Indonesia',
  'on-site',
  'full-time',
  'junior',
  6000000, 7000000, 'Rp 6.000.000 – 7.000.000',
  55,
  ARRAY['Google', 'Google', 'Administration'],
  'Google Docs',
  'Mendukung jadwal direksi, korespondensi klien korporat, dan pengarsipan dokumen menggunakan Google Workspace.',
  'https://glints.com/id'
)
on conflict (external_job_id) do nothing;
