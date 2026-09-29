# Changelog

## [1.0.1] - 2026-09-29
### Corretto
- **Explorer non ripartiva** dopo la ricostruzione cache icone / riavvio shell: lanciato da un prompt elevato,
  `explorer.exe` delega a una shell inesistente e si chiude in silenzio. Nuova routine `:STARTEXPLORER` che
  lo riavvia come utente normale (riavvio automatico Winlogon, attivita pianificata `/IT /RL LIMITED`,
  `runas /trustlevel`) e **verifica** che sia davvero partito prima di dare l'OK
- Glifo `▶` mostrato come riquadro in alcuni font della console: sostituito con `►`

## [1.0.0] - 2026-09-29
### Aggiunto
- Menu grafico ANSI con 17 funzioni e auto-elevazione ad amministratore
- Riparazione audio, icone, indicizzazione, Windows Update, shell (Start/Taskbar/Explorer)
- SFC/DISM, reset rete, pulizia, Microsoft Store, CHKDSK, punto di ripristino
- **Diagnosi automatica**: 11 gruppi di test con verdetto ordinato per gravità e rimando alla riparazione giusta
- Log di sessione e report di diagnosi su file

### Corretto
- Lettura stato WSearch (token errato di `sc query`)
- CHKDSK indipendente dalla lingua di sistema (`fsutil dirty set`)
- Allineamento del riquadro del menu (padding calcolato, niente caratteri a larghezza ambigua)
