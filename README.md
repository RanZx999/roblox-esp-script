# 🎮 Enhanced ESP Script - Roblox

> Advanced ESP & Exploit Script dengan fitur lengkap untuk Roblox!

![Status](https://img.shields.io/badge/Status-Working-brightgreen)
![Version](https://img.shields.io/badge/Version-2.0-blue)
![Roblox](https://img.shields.io/badge/Platform-Roblox-red)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📸 Screenshots

> *Upload screenshots di sini setelah testing!*

---

## ✨ Features

### 🔍 Advanced ESP System
- ✅ **ESP Boxes** - Box outline di sekeliling player dengan warna custom
- ✅ **Distance Indicator** - Tampilan jarak real-time dalam studs
- ✅ **Health Bar** - Bar kesehatan dengan color coding (hijau → kuning → merah)
- ✅ **Enhanced Name Tags** - Player names dengan outline yang jelas
- ✅ **Team Color Support** - Otomatis detect warna tim player
- ✅ **Adjustable Distance** - Atur max render distance (100-5000 studs)

### 🎯 Hitbox Expander
- ✅ **Custom Hitbox Size** - Perbesar hitbox musuh untuk aim lebih gampang
- ✅ **Transparency Control** - Atur transparansi hitbox
- ✅ **Team Check** - Pilih affect semua player atau cuma musuh
- ✅ **Visual Indicator** - Neon effect untuk hitbox yang aktif

### 🏃 Movement Features
- ✅ **WalkSpeed Changer** - Ubah kecepatan jalan + loop option
- ✅ **JumpPower Modifier** - Lompat lebih tinggi + loop option
- ✅ **TP Walk** - Teleport walk dengan speed yang bisa diatur
- ✅ **Noclip** - Tembus dinding dan objek
- ✅ **Infinite Jump** - Lompat tanpa batas di udara
- ✅ **FOV Slider** - Atur field of view (zoom in/out)

### 🎨 UI & Controls
- ✅ **Clean UI** - Interface yang rapih dan mudah dipake
- ✅ **Multiple Tabs** - Organized dalam 3 tabs (Home, Players, ESP Visuals)
- ✅ **Draggable Toggle** - Button toggle yang bisa dipindah-pindah
- ✅ **Keybind Support** - Press **F** untuk toggle UI
- ✅ **Dark Theme** - UI dengan tema gelap yang nyaman

---

## 📥 Installation

### 🚀 Loadstring (Recommended)
Copy dan paste ini ke executor kamu:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/RanZx999/roblox-esp-script/refs/heads/main/enhanced_esp_script.lua"))()
```

### 📝 Manual Installation
1. Download file `enhanced_esp_script.lua`
2. Buka executor favorit kamu
3. Paste seluruh script
4. Klik Execute

---

## 🎯 How to Use

### First Time Setup:
1. Execute script menggunakan loadstring
2. UI akan muncul otomatis
3. Press **F** untuk toggle UI kapan saja
4. Drag toggle button ke posisi yang nyaman

### Menggunakan ESP:
1. Buka tab **"ESP Visuals"**
2. Toggle **"Enable ESP"** untuk ON
3. Pilih fitur yang mau ditampilkan:
   - ☑️ Show Boxes
   - ☑️ Show Names
   - ☑️ Show Distance
   - ☑️ Show Health Bar
4. Atur **"Max ESP Distance"** sesuai kebutuhan
5. Toggle **"Use Team Colors"** untuk warna otomatis

### Menggunakan Hitbox Expander:
1. Buka tab **"Home"**
2. Set **"Hitbox Size"** (recommended: 10-20)
3. Set **"Hitbox Transparency"** (0.5 - 0.9)
4. Toggle **"Hitbox Status"** untuk activate
5. Optional: Enable **"Team Check"** untuk cuma affect musuh

### Movement Hacks:
1. Buka tab **"Players"**
2. Set nilai WalkSpeed/JumpPower yang diinginkan
3. Toggle **"Loop"** untuk auto-apply terus
4. Cobain fitur lain seperti Noclip, Infinite Jump, dll

---

## ⚙️ Configuration Guide

### ESP Settings
```lua
Max ESP Distance: 1000        -- Jarak maksimal ESP render (studs)
Show Boxes: ON                -- Tampilkan box outline
Show Names: ON                -- Tampilkan nama player
Show Distance: ON             -- Tampilkan jarak
Show Health Bar: ON           -- Tampilkan health bar
Use Team Colors: ON           -- Pakai warna tim
```

### Recommended Hitbox Settings
```lua
Hitbox Size: 15               -- Ukuran sweet spot untuk most games
Hitbox Transparency: 0.9      -- Almost invisible tapi masih keliatan
Team Check: ON                -- Cuma affect musuh (recommended)
```

### Movement Settings (Safe Values)
```lua
WalkSpeed: 20-25              -- Ga terlalu suspicious
JumpPower: 60-80              -- Natural looking
TP Speed: 2-4                 -- Smooth TP walk
```

---

## 🎮 Controls & Keybinds

| Key/Action | Function |
|------------|----------|
| **F** | Toggle UI (Show/Hide) |
| **Drag Toggle Button** | Pindah posisi toggle button |
| **UI Tabs** | Navigate antar Home/Players/ESP Visuals |

---

## 📱 Supported Executors

Script ini tested dan working di:

| Executor | Status | Drawing API | Notes |
|----------|--------|-------------|-------|
| ✅ **Synapse X** | Working | ✅ Yes | Full support |
| ✅ **Script-Ware** | Working | ✅ Yes | Recommended |
| ✅ **KRNL** | Working | ✅ Yes | Free, good |
| ✅ **Fluxus** | Working | ✅ Yes | Free option |
| ✅ **Oxygen U** | Working | ✅ Yes | All features |
| ✅ **Electron** | Working | ✅ Yes | ESP works |
| ⚠️ **JJSploit** | Partial | ❌ No | Use Highlight ESP |

**Note:** ESP Box features butuh Drawing API support. Kalau executor kamu ga support, pakai fallback "Character Highlight" ESP.

---

## 🎯 Game Compatibility

### ✅ Tested & Working:
- **Phantom Forces** - Full support
- **Arsenal** - Full support  
- **Bad Business** - Full support
- **Counter Blox** - Full support
- **Most FPS Games** - Usually works

### ⚠️ Limited Support:
- Games dengan strong anti-cheat
- Games yang block getgenv()
- Some Simulator games

### ❌ Not Recommended:
- Games dengan kernel-level anti-cheat
- Popular competitive games (high ban risk)

---

## 🐛 Troubleshooting

### ESP tidak muncul?
- ✅ Pastikan **"Enable ESP"** udah ON
- ✅ Check executor support Drawing API
- ✅ Coba pakai **"Character Highlight"** sebagai fallback
- ✅ Increase **Max ESP Distance** slider

### Script error saat execute?
- ✅ Re-copy loadstring dari sini (jangan dari sumber lain)
- ✅ Pastikan internet connection stabil
- ✅ Coba executor yang berbeda
- ✅ Check console untuk error message

### Hitbox tidak bekerja?
- ✅ Game mungkin punya anti-cheat
- ✅ Coba di game lain dulu
- ✅ Lower hitbox size (jangan terlalu besar)
- ✅ Enable Team Check

### UI tidak muncul?
- ✅ Press **F** untuk toggle
- ✅ Check kalau toggle button ada di pojok (drag ke tengah)
- ✅ Re-execute script

### Movement hack ga work?
- ✅ Toggle **"Loop"** untuk auto-apply
- ✅ Beberapa game block character modifications
- ✅ Coba value yang lebih kecil

---

## 📊 Performance Tips

### Untuk Low-End PC:
- Disable ESP Boxes (paling resource-heavy)
- Set Max ESP Distance ke 500-800
- Matikan fitur yang ga dipake

### Untuk Best Performance:
- Enable cuma ESP features yang perlu
- Jangan set Hitbox terlalu besar (max 20)
- Tutup UI saat main (Press F)

---

## 🔒 Safety & Detection

### Tips Aman Pakai Script:
- ⚠️ **Jangan terlalu obvious** - Pakai setting yang natural
- ⚠️ **Alt account** - Recommended untuk testing
- ⚠️ **Avoid main account** - Roblox bisa ban
- ⚠️ **Private servers** - Lebih aman untuk test

### Detection Risk:
- 🟢 **Low Risk** - ESP, Noclip, FOV
- 🟡 **Medium Risk** - Hitbox, Movement
- 🔴 **High Risk** - Using in popular/competitive games

**Disclaimer:** Use at your own risk. Script ini violates Roblox TOS.

---

## 📝 Credits

- **Enhanced Version:** RanZx999
- **Original Hitbox Script:** !vcsk0#1516
- **ESP Components:** Community ESP Scripts
- **UI Library:** Vcsk UI Library
- **Contributors:** Roblox Exploit Community

---

## 🤝 Contributing

Mau improve script ini? Contributions welcome!

1. Fork repository ini
2. Buat branch baru (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -am 'Add new feature'`)
4. Push ke branch (`git push origin feature/improvement`)
5. Create Pull Request

---

## 📜 License

MIT License - Free to use, modify, and distribute dengan credits.

---

## 🌟 Support the Project

Kalau script ini helpful:
- ⭐ **Star repository** ini
- 🍴 **Fork** untuk project kamu
- 📢 **Share** dengan teman
- 💬 **Report bugs** di Issues tab
- 🎥 **Bikin video** tutorial (dengan credit)

---

## 🔗 Links

- **Repository:** https://github.com/RanZx999/roblox-esp-script
- **Raw Script:** [Click here](https://raw.githubusercontent.com/RanZx999/roblox-esp-script/refs/heads/main/enhanced_esp_script.lua)
- **Issues/Bugs:** [Report here](https://github.com/RanZx999/roblox-esp-script/issues)

---

## 📞 Contact

Ada pertanyaan atau butuh help?
- **GitHub Issues:** Untuk bug reports
- **Discussions:** Untuk questions & ideas

---

## ⚠️ Important Disclaimer

Script ini dibuat untuk **educational purposes only**. Menggunakan exploits/scripts di Roblox melanggar [Roblox Terms of Service](https://en.help.roblox.com/hc/en-us/articles/115004647846-Roblox-Terms-of-Use) dan bisa mengakibatkan:
- Account termination/ban
- IP ban
- Loss of Robux/items

**USE AT YOUR OWN RISK!** Developer tidak bertanggung jawab atas konsekuensi penggunaan script ini.

---

## 📈 Changelog

### Version 2.0 (Current)
- ✨ Added advanced ESP system dengan boxes, distance, health bars
- ✨ Enhanced name tags dengan outline
- ✨ Team color detection otomatis
- ✨ Adjustable max ESP distance slider
- 🔧 Improved UI organization
- 🔧 Better error handling
- 🐛 Bug fixes dan performance improvements

### Version 1.0
- 🎉 Initial release
- Basic hitbox expander
- Movement features
- Simple ESP

---

<div align="center">

**Last Updated:** February 2026 | **Version:** 2.0 | **Status:** ✅ Working

Made with ❤️ for the Roblox community

⭐ **Don't forget to star this repo!** ⭐

</div>
