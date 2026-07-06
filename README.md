# Network Scanner

PowerShell GUI untuk scan IP, ports, dan services via Tailscale VPN - Tanpa install apapun!

## Features

- **Target IP Input** - Masukkan IP address target
- **Port Presets** - Common, Windows, Web, Database, SSH/FTP, Proxmox
- **Service Detection** - 28+ service types terdeteksi
- **Color-coded Results** - Green=Open, Red=Closed
- **Export CSV** - Simpan hasil scan ke file
- **Real-time Progress** - Progress bar saat scan

## Requirements

- Windows 10/11
- PowerShell 5.1 atau lebih baru
- **Tanpa install apapun!**

## Usage

### Cara Jalankan

```powershell
# Buka PowerShell
# Navigate ke folder
cd C:\path\to\folder

# Jalankan script
.\network-scanner.ps1
```

### atau dengan Execution Policy Bypass

```powershell
powershell -ExecutionPolicy Bypass -File network-scanner.ps1
```

## Fitur GUI

| Komponen | Keterangan |
|----------|------------|
| Target IP | Input IP address target |
| Ports | Input port (comma separated) |
| Presets | Quick select port groups |
| SCAN Button | Mulai scan |
| STOP Button | Hentikan scan |
| Progress Bar | Tampilkan progress |
| Results | Tabel hasil scan |
| EXPORT CSV | Simpan hasil ke file |

## Port Presets

| Preset | Ports |
|--------|-------|
| Common | 21,22,23,25,53,80,110,135,139,443,445,993,995,3389,5985,5986,8006,8080 |
| Windows | 135,139,445,3389,5985,5986 |
| Web | 80,443,8080,8443,8888,9090 |
| Database | 1433,1434,3306,5432,27017 |
| SSH/FTP | 21,22,23 |
| Proxmox | 22,8006 |

## Service Detection

| Port | Service |
|------|---------|
| 21 | FTP |
| 22 | SSH |
| 23 | Telnet |
| 25 | SMTP |
| 53 | DNS |
| 80 | HTTP |
| 110 | POP3 |
| 135 | RPC/DCOM |
| 139 | NetBIOS |
| 143 | IMAP |
| 443 | HTTPS |
| 445 | SMB |
| 993 | IMAPS |
| 995 | POP3S |
| 1433 | MSSQL |
| 1434 | MSSQL Browser |
| 3306 | MySQL |
| 3389 | RDP |
| 5432 | PostgreSQL |
| 5900 | VNC |
| 5985 | WinRM HTTP |
| 5986 | WinRM HTTPS |
| 8006 | Proxmox |
| 8080 | HTTP Alt |
| 8443 | HTTPS Alt |
| 8888 | HTTP Alt |
| 9090 | Webmin |
| 27017 | MongoDB |

## Screenshot

```
┌─────────────────────────────────────────┐
│           NETWORK SCANNER               │
├─────────────────────────────────────────┤
│  TARGET                                 │
│  Target IP: [100.74.88.110    ]         │
│  Ports:     [22,80,445,3389   ]         │
├─────────────────────────────────────────┤
│  PRESETS                                 │
│  [Common] [Windows] [Web] [Database]    │
├─────────────────────────────────────────┤
│  [SCAN]  [STOP]  [████████░░] 60%      │
├─────────────────────────────────────────┤
│  RESULTS                                 │
│  Port  | State | Service | Description  │
│  22    | Open  | SSH     |              │
│  80    | Open  | HTTP    |              │
│  445   | Closed| SMB     |              │
│  3389  | Open  | RDP     |              │
├─────────────────────────────────────────┤
│  [EXPORT CSV]  Last update: 20:30:15    │
└─────────────────────────────────────────┘
```

## How It Works

Script menggunakan PowerShell `Test-NetConnection` untuk test port:

```powershell
# Test single port
$result = Test-NetConnection -ComputerName $IP -Port $Port -WarningAction SilentlyContinue
if ($result.TcpTestSucceeded) {
    # Port is open
}
```

## Use Cases

- **Penetration Testing** - Reconnaissance phase
- **Network Audit** - Check open ports
- **Security Assessment** - Identify exposed services
- **Tailscale Lab** - Scan devices di VPN network

## License

MIT License - Free to use and modify
