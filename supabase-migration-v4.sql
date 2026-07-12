-- Run this only if you already ran supabase-migration-v3.sql.
alter table public.competition_entries drop column if exists email;
alter table public.competition_entries add column if not exists device_fingerprint text;
create unique index if not exists competition_entries_device_fingerprint_unique
  on public.competition_entries (device_fingerprint);
