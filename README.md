# xkcd-ios

### ✅ Prioritized areas  
Mainly focused on clean architecture, testability and SwiftUI idioms.
I emphasized a modular structure using MVVM to keep logic isolated and testable.
Effort was also put into making the app’s components composable and easy to evolve if features were added later.

---

### ⏱️ Time spent  
Main buckets of time spent on planning, coding, testing and polish with the following rough breakdown:
- Planning (0.5 hour)  
- Coding:
  - Initial project setup (0.5 hour)
  - Main screens’ UI (1 hour)
  - Networking layer (1 hour)
  - Improved implementation such as view models (0.5 hour)
  - Error handling (0.5 hour)
- Unit test (1 hours)
- Visual and project polish (0.5 hour)
- GitHub Actions setup (and troubleshooting) (1 hour)
- Accessibility features (0.5 hour)
- UI tests (1 hour)

Approximately a total of ~8 hours.

---

### ⚖️ Trade-offs  
I didn’t build persistence to stay within scope.
I also considered other relevant features such as a random or today’s comic iOS widget or Siri Intents all of which felt like it would go out of scope and potentially complicated the project to the point that it would affect the core concepts that need to be implemented and evaluated.
Planning for each of these features would have certain implications in terms of code modularization and architecture.

---

### ℹ️ Additional info  
I worked on the following features that were not exactly in the scope of the instructions:  
- Included “alt” from the XKCD JSON, which normally is displayed when users hover over the comics on the desktop so I added it as a caption which can be revealed to keep the same “easter egg” spirit of the alt caption.
- Added “transcript” found in the JSON as accessibility label for iOS voice over purposes.
- Added some accessibilityIdentifiers for UI testing purposes.
- Added some simple XCUITests to demonstrate the accessibility ID usage.
- I made sure the app/project compiles for and supports iOS 16+ so it supports at least two versions prior to the latest (16, 17 and 18).
- Worked on several UI/UX enhancements such as auto-focusing the input field and refining the overall look and feel, while sticking to native iOS system controls.
- Followed good practices for git workflows, including clear branching and commit history, even though all changes were made by a single contributor.
- Defined a GitHub Action CI workflow to run the XCTests when changes are pushed to remote branches and to ensure PRs do not include breaking changes.
- UI Tests are intentionally not included in GitHub Action workflow for now; they should be run manually when needed.