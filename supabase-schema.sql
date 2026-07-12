-- Run this in Supabase → SQL Editor before deploying.
create table if not exists public.predictions (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  first_name text not null,
  last_name text not null,
  mobile text not null unique,
  semi_one text not null,
  semi_two text not null,
  score_one smallint not null check (score_one between 0 and 20),
  score_two smallint not null check (score_two between 0 and 20),
  result text not null check (result in ('Argentina', 'England', 'Spain', 'France', 'Draw')),
  champion text not null,
  penalty_winner text,
  first_goalscorer text,
  man_of_match text not null,
  golden_boot text not null
);
alter table public.predictions enable row level security;
-- No public policies: the secure Vercel function is the only writer/reader.
