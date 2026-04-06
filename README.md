<img width="1532" height="566" alt="Image" src="https://github.com/user-attachments/assets/db67503f-108b-4260-9aa5-e351d41b74f3" />

ChipKing is a SwiftUI iOS app for tracking poker series results.  
You can manage multiple series, add players, record games, and view leaderboard/stat trends over time.

## Features

- Create and manage multiple poker series
- Add players with profile images
- Record game buy-ins and results
- Track historical games per series
- View player stats and leaderboard rankings
- Persist data locally on device (JSON files in Documents)

<img width="701" height="246" alt="Image" src="https://github.com/user-attachments/assets/532c589b-1e77-4092-9b23-05b06881e2a3" />

## Tech Stack

- Swift
- SwiftUI
- Xcode project (`Chipking.xcodeproj`)
- Local file persistence using `Codable` + JSON

## Project Structure

```text
ChipKing/
├── Kingpin/                         # Main app module
│   ├── system/                      # App entrypoint, ContentView, assets
│   ├── Tabbar/                      # Main tab container + Series model
│   ├── NewGame/                     # New game flow and related UI/components
│   ├── players/                     # Player management, profile, charts
│   ├── Leaderboard/                 # Leaderboard screen
│   └── *.swift                      # Shared/supporting views and models
├── Chipking.xcodeproj/              # Xcode project settings and schemes
├── LICENSE
└── README.md
```

## Getting Started

### Requirements

- macOS
- Xcode 15+
- iOS Simulator or iOS device

### Run Locally

1. Clone the repo:
   ```bash
   git clone <your-repo-url>
   cd Kingpin
   ```
2. Open the project in Xcode:
   - `Chipking.xcodeproj`
3. Select an iOS Simulator
4. Build and run (`Cmd + R`)

## Data Storage

ChipKing currently stores data locally using JSON files:

- `series_data.json` (all series metadata)
- `players_<series>.json` (players for a series)
- `past_games_<series>.json` (games for a series)
- `<player>_gameStats.json` (per-player history)

## Testing

This project includes both unit tests and UI tests:

- `KingpinTests` for model/statistics logic
- `KingpinUITests` for launch and basic UI smoke coverage


## License

This project is licensed under the MIT License.  
See `LICENSE` for details.
