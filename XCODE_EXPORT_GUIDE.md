# Xcode'da App Olarak Export Etme Rehberi

## Yöntem 1: Mevcut Swift Package'ı Xcode'da Açma (Hızlı)

1. **Xcode'u açın**
2. **File > Open** seçin
3. `Package.swift` dosyasını seçin
4. Xcode package'ı açacak

### Executable'ı App Bundle'a Dönüştürme

Swift Package Manager executable'ları direkt app bundle olarak export edilemez. İki seçenek var:

#### Seçenek A: Yeni macOS App Target Eklemek

1. Xcode'da Package.swift açıkken
2. **File > New > Target** (veya Package.swift sağ tık > Add Target)
3. **macOS > App** seçin
4. Target adı: `AIWidgetApp` (veya istediğiniz isim)
5. Mevcut kodları bu target'a taşıyın

#### Seçenek B: Yeni Xcode Projesi Oluşturmak (Önerilen)

## Yöntem 2: Yeni Xcode Projesi Oluşturma (Önerilen)

### Adım 1: Yeni Proje Oluştur

1. Xcode'u açın
2. **File > New > Project**
3. **macOS** sekmesini seçin
4. **App** template'ini seçin
5. Proje bilgileri:
   - Product Name: `AIWidget`
   - Team: (Apple Developer hesabınız)
   - Organization Identifier: (örn: com.yourname)
   - Interface: SwiftUI
   - Language: Swift
   - ✅ "Include Tests" işaretleyin

### Adım 2: Widget Extension Eklemek

1. **File > New > Target**
2. **macOS > Widget Extension** seçin
3. Target adı: `AIWidgetExtension`
4. ✅ "Include Configuration Intent" işaretlemeyin (basit widget için)

### Adım 3: Dosyaları Taşıma

Mevcut dosyalarınızı yeni Xcode projesine kopyalayın:

```
AIWidget/
├── AIWidgetApp.swift → Yeni projenin App dosyasına kopyala
├── ContentView.swift → Yeni projeye kopyala
├── SettingsView.swift → Yeni projeye kopyala
└── AIWidgetExtension/
    ├── AIWidgetExtension.swift → Widget Extension target'ına kopyala
    ├── TimelineProvider.swift → Widget Extension target'ına kopyala
    └── WidgetView.swift → Widget Extension target'ına kopyala

Models/
└── UsageData.swift → Her iki target'a da ekle (shared)

Services/
├── APIKeyManager.swift → Ana app target'ına ekle
├── ClaudeService.swift → Ana app target'ına ekle
├── CursorService.swift → Ana app target'ına ekle
└── OpenAIService.swift → Ana app target'ına ekle
```

### Adım 4: Target Membership Ayarlama

Her dosya için:
1. File Inspector'da (sağ panel)
2. **Target Membership** bölümünde
3. Hangi target'larda olması gerektiğini işaretleyin:
   - Ana app dosyaları: `AIWidget` target
   - Widget dosyaları: `AIWidgetExtension` target
   - Shared dosyalar: Her iki target

### Adım 5: Build Settings

1. Ana app target'ı seçin
2. **Build Settings** sekmesine gidin
3. **Signing & Capabilities** sekmesinde:
   - Team seçin
   - Signing Certificate seçin

### Adım 6: Archive ve Export

1. **Product > Scheme > AIWidget** seçin
2. **Product > Destination > Any Mac** seçin
3. **Product > Archive** (⌘B sonra Product > Archive)
4. Archive tamamlandığında **Window > Organizer** açılır
5. Archive'ı seçin ve **Distribute App** butonuna tıklayın
6. Seçenekler:
   - **Development**: Test için
   - **App Store**: App Store'a yüklemek için
   - **Ad Hoc**: Belirli cihazlara dağıtmak için
   - **Export**: Manuel dağıtım için (.app veya .dmg)

## Yöntem 3: Script ile App Bundle Oluşturma (Hızlı Test)

Terminal'den direkt app bundle oluşturmak için bir script kullanabilirsiniz.
