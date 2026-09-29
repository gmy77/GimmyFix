<div align="center">

```
  ██████╗ ██╗███╗   ███╗███╗   ███╗██╗   ██╗███████╗██╗██╗  ██╗
 ██╔════╝ ██║████╗ ████║████╗ ████║╚██╗ ██╔╝██╔════╝██║╚██╗██╔╝
 ██║  ███╗██║██╔████╔██║██╔████╔██║ ╚████╔╝ █████╗  ██║ ╚███╔╝
 ██║   ██║██║██║╚██╔╝██║██║╚██╔╝██║  ╚██╔╝  ██╔══╝  ██║ ██╔██╗
 ╚██████╔╝██║██║ ╚═╝ ██║██║ ╚═╝ ██║   ██║   ██║     ██║██╔╝ ██╗
  ╚═════╝ ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝     ╚═╝╚═╝  ╚═╝
```

**Toolkit di riparazione e diagnosi per Windows 11 Insider**
*Repair & diagnostic toolkit for Windows 11 Insider builds*

![Windows 11](https://img.shields.io/badge/Windows-11%20Insider-0078D4?logo=windows11&logoColor=white)
![Batch](https://img.shields.io/badge/Batch%20%2B%20PowerShell-single%20file-4D4D4D)
![License](https://img.shields.io/badge/license-MIT-green)
![Version](https://img.shields.io/badge/version-1.0.0-blue)

*By Pignolo Gimmy e Fable 5.1*

[Italiano](#-italiano) · [English](#-english)

</div>

---

## 🇮🇹 Italiano

### Perché esiste
I canali Insider (Canary, Dev, Beta) rompono cose: l'audio sparisce dopo un flight, le icone impazziscono, Windows Update si pianta, lo Start non si apre. GimmyFix mette in un **unico file `.bat`** le riparazioni che servono davvero, e soprattutto una **diagnosi automatica** che ti dice *dove* guardare prima di mettere mano a qualcosa.

### Avvio rapido
1. Scarica `GimmyFix.bat`
2. Doppio clic → si auto-eleva ad amministratore
3. Consigliato come primo passo: **[17] Diagnosi automatica**

> Nessuna installazione, nessuna dipendenza: solo cmd e PowerShell già presenti in Windows 11.

### Menu
```
 ╔════════════════════════════════════════════════════════════════════════════╗
 ║  RIPARAZIONI                          SISTEMA                              ║
 ║   [1] Audio (servizi, driver)           [7] SFC + DISM (file sistema)      ║
 ║   [2] Icone / cache miniature           [8] Reset rete (DNS/Winsock/IP)    ║
 ║   [3] Indicizzazione on/off/rebuild     [9] Pulizia file temporanei        ║
 ║   [4] Windows Update (reset)           [10] Microsoft Store (reset)        ║
 ║   [5] Start / Taskbar / Explorer       [11] CHKDSK al riavvio              ║
 ║   [6] Associazioni file/immagini       [12] Punto di ripristino            ║
 ║  DIAGNOSI / INSIDER / INFO                                                 ║
 ║  [17] » DIAGNOSI AUTOMATICA  11 test, verdetto e consigli mirati           ║
 ║  [13] Info build / canale Insider     [14] Apri log                        ║
 ║  [15] Risoluzione problemi Windows    [16] Riavvia PC                      ║
 ╚════════════════════════════════════════════════════════════════════════════╝
```

### La diagnosi automatica
11 gruppi di test, ognuno con esito ✔ / ⚠ / ✖:

| # | Area | Cosa controlla |
|---|------|----------------|
| 1 | Disco | spazio libero, salute volume, SMART (errori, usura SSD, temperatura), eventi NTFS/storage |
| 2 | Servizi | 22 servizi critici mappati per area (audio, update, rete, shell, store) |
| 3 | Riavvio | riavvii in sospeso (WU, CBS, file rename) e uptime |
| 4 | Windows Update | ultima ricerca/installazione riuscita, installazioni fallite, cache download |
| 5 | Integrità | DISM CheckHealth, CBS.log, file che SFC non riesce a riparare |
| 6 | Stabilità | BSOD, spegnimenti anomali, errori hardware WHEA, crash app ed Explorer |
| 7 | Driver | dispositivi in errore con codice, controller audio vs endpoint |
| 8 | Rete | gateway, DNS, connettività TCP, proxy WinHTTP, VPN attive |
| 9 | Orologio | sfasamento NTP (oltre 60 s rompe TLS → Update e Store) |
| 10 | Risorse | CPU, RAM, processi più pesanti, TEMP, cache icone gonfia |
| 11 | Insider | build, canale, flag dei flight |

Il **verdetto finale** ordina i problemi per gravità (CRITICO / ATTENZIONE / NOTA), indica l'opzione del menu che li risolve e stabilisce una **priorità**:
- segnali hardware → *le riparazioni software non servono, parti da lì*
- component store danneggiato → *prima DISM + SFC, poi il resto*
- riavvio in sospeso → *riavvia prima di tutto*

Il report viene salvato in `GimmyFix_diagnosi.txt`.

### Avvertenze
- **Crea un punto di ripristino** (opzione 12) prima delle riparazioni pesanti.
- Il reset rete completo (8 → 2) azzera anche le regole del firewall.
- Su Canary/Dev controlla sempre i *Known Issues* del flight: se il problema è noto, nessuna riparazione lo risolve.
- Il file deve restare **UTF-8 senza BOM con fine riga CRLF** (il `.gitattributes` del repo lo garantisce).

---

## 🇬🇧 English

### Why
Insider channels break things: audio vanishes after a flight, icons go wrong, Windows Update gets stuck, Start won't open. GimmyFix packs the repairs that actually matter into **one `.bat` file**, plus an **automatic diagnosis** that tells you *where* to look before you touch anything.

### Quick start
1. Download `GimmyFix.bat`
2. Double-click → it self-elevates to administrator
3. Recommended first step: **[17] Automatic diagnosis**

No install, no dependencies. The UI is in Italian; option numbers match the table above.

### Automatic diagnosis
11 test groups (disk & SMART, critical services, pending reboot, Windows Update history, DISM/SFC integrity, BSOD/WHEA/crashes, device errors, network/DNS/proxy, clock drift, resources, Insider channel). The final verdict sorts findings by severity, maps each to the menu option that fixes it, and sets a priority (hardware first, then component store, then pending reboot).

### Warnings
Create a restore point (option 12) first. The full network reset also resets firewall rules. On Canary/Dev, check the flight's Known Issues before repairing.

---

## Licenza / License
[MIT](LICENSE) © 2026 Pignolo Gimmy

Contributi, segnalazioni e test su build diverse sono benvenuti: apri una *issue* allegando il file `GimmyFix_diagnosi.txt`.
