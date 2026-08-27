-- =============================================================================
-- Joyo — allinea i valori di rooms.tone alle modalità di gioco.
--
-- 0001 creava tone con i valori storici ('soft', 'piccante', 'cattivo'), ma
-- dall'introduzione delle modalità (0010) il client scrive 'normal' | 'mix'
-- | 'hot' (ContentTone). Il vecchio check rifiutava la scrittura e cambiare
-- modalità falliva sempre con "riprova".
-- =============================================================================

alter table public.rooms drop constraint if exists rooms_tone_check;

update public.rooms
  set tone = case tone
    when 'soft'     then 'normal'
    when 'piccante' then 'mix'
    when 'cattivo'  then 'hot'
    else tone
  end
  where tone in ('soft', 'piccante', 'cattivo');

alter table public.rooms alter column tone set default 'normal';

alter table public.rooms
  add constraint rooms_tone_check check (tone in ('normal', 'mix', 'hot'));
