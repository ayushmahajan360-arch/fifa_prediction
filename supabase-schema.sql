-- Run this in Supabase → SQL Editor before deploying.
create table if not exists public.competition_entries (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  first_name text not null,
  last_name text not null,
  country_code text not null,
  mobile_number text not null,
  device_fingerprint text not null unique,
  team_1 text not null,
  team_2 text not null,
  team_1_score smallint not null check (team_1_score between 0 and 20),
  team_2_score smallint not null check (team_2_score between 0 and 20),
  final_result text not null check (final_result in ('Argentina', 'England', 'Spain', 'France', 'Draw')),
  winning_team text not null,
  penalty_winner text,
  first_goalscorer text,
  man_of_match text not null,
  golden_boot text not null,
  constraint competition_entries_phone_unique unique (country_code, mobile_number)
);
alter table public.competition_entries enable row level security;
-- No public policies: the secure Vercel function is the only writer/reader.
