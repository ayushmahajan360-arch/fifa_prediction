-- Only run this if you already ran the earlier version of supabase-schema.sql.
alter table public.predictions drop column if exists second_goalscorer;
alter table public.predictions add column if not exists result text;
alter table public.predictions alter column result set not null;
alter table public.predictions alter column first_goalscorer drop not null;
alter table public.predictions add column if not exists man_of_match text;
alter table public.predictions add constraint predictions_result_check
  check (result in ('Argentina', 'England', 'Spain', 'France', 'Draw'));
