// ============================================================================
// KONFIGURASI SUPABASE NAIKARA
// ============================================================================
// Ganti 2 nilai di bawah ini dengan Project URL dan Anon Public Key dari
// Dashboard Supabase kamu (Project Settings -> API).

window.NAIKARA_SUPABASE_CONFIG = {
  SUPABASE_URL: "https://YOUR_PROJECT_ID.supabase.co",
  SUPABASE_ANON_KEY: "YOUR_SUPABASE_ANON_PUBLIC_KEY",
  // Halaman tujuan setelah user berhasil Login / Register (ubah sesuai kebutuhan):
  REDIRECT_AFTER_LOGIN: "/index.html"
};
