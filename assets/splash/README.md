# Splash Screen Assets

## Required Files

Place the following image files in this directory:

### 1. splash_logo.png
- **Size:** 1200x1200 pixels (recommended)
- **Format:** PNG with transparency
- **Purpose:** Main splash screen logo for light mode
- **Design:**
  - App logo or brand name
  - White or light color (will show on green background)
  - Simple, clean design
  - Transparent background

**Recommended Design:**
- App name "Finance Tracker" in white text
- Or icon + app name combination
- Centered composition
- High contrast against green background (#4CAF50)

### 2. splash_logo_dark.png
- **Size:** 1200x1200 pixels
- **Format:** PNG with transparency
- **Purpose:** Splash screen logo for dark mode
- **Design:**
  - Same as splash_logo.png
  - Optimized for dark green background (#1B5E20)
  - Light colors for contrast

### 3. splash_branding.png (Optional)
- **Size:** 400x100 pixels (recommended)
- **Format:** PNG with transparency
- **Purpose:** Bottom branding text (e.g., company name, tagline)
- **Design:**
  - "Powered by [Your Name]" or tagline
  - White text
  - Small, subtle design

## Background Colors

- **Light Mode:** #4CAF50 (Green - Material Design primary color)
- **Dark Mode:** #1B5E20 (Dark Green)

## How to Generate Splash Screen

After placing the images above, run:

```bash
flutter pub get
flutter pub run flutter_native_splash:create
```

This will automatically generate:
- Android splash screens (drawable folders)
- iOS launch screens (LaunchScreen.storyboard)
- Web splash screen
- Android 12+ splash screens

## Splash Screen Behavior

- **Duration:** Shown while app initializes (1-3 seconds)
- **Animation:** Fade in logo, maintain during loading
- **Transition:** Smooth fade to main app

## Design Guidelines

### Android
- Center logo
- Solid background color
- No animations (handled by OS)

### iOS
- Center logo
- Solid background color
- Follows iOS design guidelines

### Android 12+
- Uses new splash screen API
- Adaptive icon in center
- Branded launch experience

## Current Status

**⚠️ PLACEHOLDER:** No splash images have been added yet.

To complete Task 3 (App Icon & Splash Screen), you need to:
1. Create splash screen logo (1200x1200 PNG with transparency)
2. Place it as `splash_logo.png` and `splash_logo_dark.png` in this directory
3. (Optional) Create branding image as `splash_branding.png`
4. Run `flutter pub run flutter_native_splash:create`

## Quick Start (Without Custom Images)

If you want to test the app without custom splash screens, you can:

1. Temporarily use the app icon as the splash logo:
   ```bash
   cp ../icon/app_icon.png splash_logo.png
   cp ../icon/app_icon.png splash_logo_dark.png
   ```

2. Generate splash screens:
   ```bash
   flutter pub run flutter_native_splash:create
   ```

3. Replace with proper splash design later.
