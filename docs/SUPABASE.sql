-- LA MOULA — configuration Supabase
-- Projet : pwvjybylbobqibvtpkiw
-- À exécuter une seule fois dans Supabase > SQL Editor > New query.
-- Script réexécutable : il crée/actualise la table et ses règles d'accès.
-- IMPORTANT : les utilisateurs ne peuvent accéder qu'à leur propre ligne.

create table if not exists public.moula_state (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{"docs": [], "clients": [], "profile": {}}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.moula_state
  add column if not exists payload jsonb not null default '{"docs": [], "clients": [], "profile": {}}'::jsonb;
alter table public.moula_state
  add column if not exists updated_at timestamptz not null default now();

alter table public.moula_state enable row level security;

-- La table ne doit jamais être accessible aux visiteurs non connectés.
revoke all on table public.moula_state from anon;
grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.moula_state to authenticated;

-- Nettoyage des anciennes versions des politiques de La Moula.
drop policy if exists "moula_select_own" on public.moula_state;
drop policy if exists "moula_insert_own" on public.moula_state;
drop policy if exists "moula_update_own" on public.moula_state;
drop policy if exists "moula_delete_own" on public.moula_state;

-- Chaque compte ne lit que sa propre ligne.
create policy "moula_select_own"
  on public.moula_state for select to authenticated
  using ((select auth.uid()) = owner_id);

-- Un compte ne peut créer qu'une ligne qui lui appartient.
create policy "moula_insert_own"
  on public.moula_state for insert to authenticated
  with check ((select auth.uid()) = owner_id);

-- Un compte ne peut modifier que sa propre ligne ni transférer sa propriété.
create policy "moula_update_own"
  on public.moula_state for update to authenticated
  using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);

-- Un compte ne peut supprimer que sa propre ligne.
create policy "moula_delete_own"
  on public.moula_state for delete to authenticated
  using ((select auth.uid()) = owner_id);

comment on table public.moula_state is
  'Données La Moula synchronisées, isolées par utilisateur via RLS.';
