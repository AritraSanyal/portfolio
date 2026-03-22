# Portfolio Agent Notes

## Project
Flutter Web portfolio with Gruvbox dark theme and interactive terminal UI.

## Stack
- Flutter 3.x (web target)
- google_fonts, url_launcher, provider packages

## Commands
```bash
flutter build web
flutter run -d chrome
```

## Deployment (Vercel)

### Method 1: CLI (Quick Deploy)
```bash
# 1. Build the web app
flutter build web

# 2. Install Vercel CLI
npm i -g vercel

# 3. Deploy
vercel --prod
```

### Method 2: GitHub + Vercel (Recommended - Auto Deploy)
1. Push code to GitHub
2. Go to https://vercel.com/new
3. Import your GitHub repo
4. Vercel auto-detects Flutter Web
5. Click Deploy
6. Every push to `main` auto-deploys

## Personal Info
- **Name**: Aritra Sanyal
- **City**: Jaipur, India
- **GitHub**: AritraSanyal
- **Email**: aritra.sanyal.official@gmail.com
- **Phone**: +91 7980769212

## Projects (Placeholder GitHub Links)
1. **Advertisement Generation App**: github.com/AritraSanyal/TODO_AD_PROJECT
2. **Mesure — Health App**: github.com/AritraSanyal/TODO_MESURE_PROJECT

## Key Files
| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point |
| `lib/features/terminal/terminal_controller.dart` | Core logic (autocomplete, history) |
| `lib/commands/builtin_commands.dart` | All terminal commands |
| `lib/config/colors.dart` | Gruvbox palette |
| `lib/filesystem/file_contents.dart` | Content for about.md, skills.md, projects.md, contact.md |

## Bug Fixes (for future reference)
1. Container cannot have both `color` and `decoration` - use BoxDecoration only
2. Terminal content clips rounded corners - wrap in ClipRRect
3. Ghost text RangeError - bounds check before `substring(input.length)`
