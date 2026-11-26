-- Jalankan script ini di Supabase -> SQL Editor -> New Query
-- Tujuannya agar setiap user baru yang mendaftar lewat halaman Register
-- otomatis dibuatkan data profilnya di tabel `public.profiles`.

create table if not exists public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  full_name text,
  email text,
  plan text default 'starter',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Aktifkan Row Level Security (RLS)
alter table public.profiles enable row level security;

-- Policy: User hanya bisa melihat & mengubah profil miliknya sendiri
create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Function & Trigger otomatis saat user Sign Up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, email)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.email
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
