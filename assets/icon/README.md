# App Icon Assets

## Required Files

Place the following image files in this directory:

### 1. app_icon.png
- **Size:** 1024x1024 pixels (minimum)
- **Format:** PNG with transparency
- **Purpose:** Main app icon for iOS and Android
- **Design:**
  - Finance-themed icon (wallet, money, chart, etc.)
  - Green color scheme (#4CAF50)
  - Simple, recognizable design
  - Works well at small sizes (48x48 to 512x512)

**Recommended Design:**
- Icon of a wallet with a dollar sign or coin
- Green gradient background
- White/light icon on green background
- Rounded corners (will be applied automatically by platforms)

### 2. app_icon_foreground.png
- **Size:** 1024x1024 pixels
- **Format:** PNG with transparency
- **Purpose:** Adaptive icon foreground for Android
- **Design:**
  - Same as app_icon.png but with transparent background
  - Icon should be centered
  - Safe area: 432x432 pixels in the center

## How to Generate Icons

After placing the images above, run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will automatically generate all required icon sizes for:
- Android (mipmap-hdpi, mipmap-mdpi, mipmap-xhdpi, etc.)
- iOS (AppIcon.appiconset)
- Web (favicon, apple-touch-icon, etc.)

## Design Tools

Free tools to create app icons:
- **Figma:** https://www.figma.com (Professional design tool)
- **Canva:** https://www.canva.com (Easy templates)
- **AppIconMaker:** https://appiconmaker.co (Quick icon generator)
- **Icons8:** https://icons8.com/icons (Free icon library)

## Current Status

**⚠️ PLACEHOLDER:** No icon images have been added yet.

To complete Task 3 (App Icon & Splash Screen), you need to:
1. Create or download an app icon image (1024x1024 PNG)
2. Place it as `app_icon.png` in this directory
3. Create foreground version as `app_icon_foreground.png`
4. Run `flutter pub run flutter_launcher_icons`
