-- =============================================================================
-- Joyo — codice stanza da 4 a 6 caratteri + l'host può chiudere la stanza.
--
-- ATTENZIONE: la prima riga cancella tutte le stanze esistenti. Sono solo le
-- stanze di test create durante lo sviluppo, e serve perché il vincolo nuovo
-- (6 caratteri) non è compatibile con i codici a 4 già salvati.
-- I giocatori collegati a quelle stanze spariscono in cascata.
-- =============================================================================

delete from public.rooms;

alter table public.rooms drop constraint if exists rooms_code_check;
alter table public.rooms
  add constraint rooms_code_check check (code ~ '^[A-Z0-9]{6}$');

-- 6 caratteri su un alfabeto di 32 senza simboli ambigui = ~1 miliardo di
-- combinazioni: le collisioni diventano trascurabili.
create or replace function public.gen_room_code()
returns text
language plpgsql
volatile
as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  result text := '';
  i int;
begin
  for i in 1..6 loop
    result := result || substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1);
  end loop;
  return result;
end;
$$;

-- Quando l'host esce, la stanza si chiude per tutti: i client vedono sparire
-- la riga e mostrano "stanza chiusa" invece di restare appesi.
drop policy if exists rooms_delete_host on public.rooms;
create policy rooms_delete_host on public.rooms
  for delete to authenticated
  using (public.is_room_host(id));

-- Se un giocatore chiude l'app senza uscire, la sua riga resta lì: l'host deve
-- poterlo rimuovere a mano dalla lobby.
drop policy if exists players_delete_by_host on public.players;
create policy players_delete_by_host on public.players
  for delete to authenticated
  using (public.is_room_host(room_id));
