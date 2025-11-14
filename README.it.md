# ![WireGuard](images/wireguard_logo.png) wgc - WireGuard Connection Manager

![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)

**[🇬🇧 English](README.md) | [🇮🇹 Italiano](README.it.md)**

> Esegui e monitora più tunnel WireGuard isolati utilizzando i namespace di rete Linux.

`wgc` è uno script bash per gestire connessioni WireGuard multiple e simultanee su un sistema Linux. La sua funzionalità principale è l'uso dei **namespace di rete Linux** (`ip netns`).

Ogni connessione VPN viene avviata all'interno di un namespace isolato, che ottiene la propria interfaccia di rete, tabella di routing e configurazione DNS. Questo permette a più VPN di essere attive contemporaneamente senza conflitti di routing, e isola il traffico VPN dalla rete principale del sistema host.

---

## Caratteristiche

* **Isolamento Totale:** Esegui più VPN contemporaneamente. Il traffico di ogni VPN è completamente separato dall'host e dalle altre VPN.
* **Esecuzione Mirata:** Esegui comandi o applicazioni specifiche (come `curl`, `ssh` o un browser) *all'interno* di un namespace VPN. Questo instrada solo il traffico di quell'applicazione attraverso il tunnel, mentre il resto del sistema usa la connessione predefinita.
* **DNS Automatico:** Imposta automaticamente i server DNS specificati nel file `.conf` (tramite la chiave `DNS =`) per il namespace scrivendo in `/etc/netns/<nome_vpn>/resolv.conf`.
* **Interfaccia Semplice:** Un singolo script con comandi chiari per avviare, fermare, elencare e monitorare i tunnel.

## Requisiti

* `bash`
* Accesso `sudo` (lo script si auto-eleva se non eseguito come root)
* `wireguard-tools` (fornisce il comando `wg`)
* `iproute2` (fornisce il comando `ip`)

## Installazione

1. Scarica il file ![wgc](https://github.com/colemar/wgc/raw/refs/heads/main/wgc)

2. Rendi lo script eseguibile:
   
   ```bash
   chmod +x wgc
   ```

3. Sposta lo script in una directory nel tuo `$PATH`, come `/usr/local/bin`:
   
   ```bash
   sudo cp wgc /usr/local/bin/wgc
   ```

## Configurazione

I tuoi file di configurazione WireGuard (`.conf`) devono essere posizionati in `/etc/wireguard/`.

Lo script usa il nome del file (senza l'estensione `.conf`) come identificatore VPN. Ad esempio, un file in `/etc/wireguard/work-vpn.conf` sarà gestito come VPN `work-vpn`.

Lo script analizza il file e si aspetta le chiavi standard di WireGuard.

* **Chiavi Obbligatorie:** Lo script terminerà se manca una qualsiasi di queste chiavi:
  * `Address`
  * `PrivateKey`
  * `DNS`
  * `PublicKey`
  * `Endpoint`
  * `AllowedIPs`
* **Chiavi Opzionali:** Lo script supporta anche:
  * `MTU`
  * `PresharedKey`
  * `PersistentKeepalive`

---

## Utilizzo

La sintassi generale è `wgc [comando] <nome_vpn>`.

Lo script richiede accesso `sudo` o root perché manipola interfacce di rete e namespace.

  ![](images/wgc.png)

### Comandi Principali

* **`start <vpn>`**
  Avvia la connessione VPN specificata.
  
  ```bash
  wgc start work-vpn
  ```
  
  ![](images/start.png)

* **`stop <vpn>`**
  Ferma la connessione VPN.
  
  ```bash
  wgc stop work-vpn
  ```
  
  ![](images/stop.png)

* **`status <vpn>`**
  Mostra lo stato dettagliato della connessione.
  
  ```bash
  wgc status work-vpn
  ```
  
  ![](images/status.png)

* **`exec <vpn> <comando...>`**
  Esegue un comando *all'interno* del namespace della VPN.
  
    *Esempio: Controlla il tuo IP pubblico come visto dalla VPN.*
  
  ```bash
  wgc exec work-vpn curl ifconfig.me
  ```
  
    *Esempio: Avvia una shell interattiva che usa la VPN.*
  
  ```bash
  wgc exec work-vpn bash
  ```
  
  ![](images/exec.png)

* **`list`**
  Elenca tutti i file `.conf` disponibili trovati in `/etc/wireguard/`.
  
  ```bash
  wgc list
  ```
  
  ![](images/list.png)

* **`active`**
  Elenca tutte le VPN *attualmente attive* controllando i namespace di rete in esecuzione che contengono un'interfaccia WireGuard omonima.
  
  ```bash
  wgc active
  ```
  
  ![](images/active.png)

### Completamento Bash

Lo script può installare il proprio file di completamento bash.

1. Esegui il seguente comando:
   
   ```bash
   wgc completion
   ```

2. Questo creerà il file `/etc/bash_completion.d/wgc`.

3. Carica il file (`source /etc/bash_completion.d/wgc`) o avvia una nuova shell per usare il completamento.

4. Lo script fornisce istruzioni opzionali per le regole `sudoers` per rendere il completamento fluido.

## Licenza

Questo progetto è concesso in licenza con la GNU General Public License v3.0 (GPL-3.0).
Vedi il file [LICENSE](LICENSE) per i dettagli.
