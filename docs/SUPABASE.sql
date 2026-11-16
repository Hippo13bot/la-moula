-- LA MOULA — stockage privé synchronisé par compte utilisateur
-- À exécuter dans Supabase > SQL Editor, avec le projet sélectionné.
create table if not exists public.moula_state (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{"docs":[],"clients":[],"profile":{}}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.moula_state enable row level security;
revoke all on public.moula_state from anon;
grant select, insert, update, delete on public.moula_state to authenticated;
drop policy if exists "moula_select_own" on public.moula_state;
drop policy if exists "moula_insert_own" on public.moula_state;
drop policy if exists "moula_update_own" on public.moula_state;
drop policy if exists "moula_delete_own" on public.moula_state;
create policy "moula_select_own" on public.moula_state for select to authenticated using (auth.uid() = owner_id);
create policy "moula_insert_own" on public.moula_state for insert to authenticated with check (auth.uid() = owner_id);
create policy "moula_update_own" on public.moula_state for update to authenticated using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "moula_delete_own" on public.moula_state for delete to authenticated using (auth.uid() = owner_id);
