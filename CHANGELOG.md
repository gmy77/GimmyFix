# Changelog

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
