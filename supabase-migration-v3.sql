-- Run this once in Supabase SQL Editor. It creates the clean table used by the live site.
-- The older `predictions` table is left untouched so existing test entries are preserved.
create table if not exists public.competition_entries (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  first_name text not null,
  last_name text not null,
  email text not null,
  country_code text not null,
  mobile_number text not null,
  team_1 text not null,
  team_2 text not null,
  team_1_score smallint not null check (team_1_score between 0 and 20),
  team_2_score smallint not null check (team_2_score between 0 and 20),
  final_result text not null,
  winning_team text not null,
  penalty_winner text,
  first_goalscorer text,
  man_of_match text not null,
  golden_boot text not null,
  constraint competition_entries_phone_unique unique (country_code, mobile_number)
);

alter table public.competition_entries enable row level security;
-- No public policies: only the protected Vercel server function can write data.
