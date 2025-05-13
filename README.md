## How to Run

### Frontend
1. Make sure you have Flutter 3.x installed.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` to launch the app.

### Backend (Local DB)
- No remote backend is required.
- The app uses a preloaded SQLite database located at:
  ```
  assets/database/devolver-digital.db
  ```
- The database is copied to the app's internal storage on first launch.

## Description
- The product list is static and loaded from a local SQLite file.
- Product `vendors` field may be either a single object or an array of objects as a JSON string.
- Search includes debounce logic and shows fake loading.
- No external API or auth is used.

## Project Structure
  - blocks # custom widget
  - config # app config ( router, config )
  - pages 
    - (name_page)
      - models 
      - widgets ( show item detail )
      - screen ( show page )
      - service ( http request, repository)
    - tab_main ( show tab when app startup )
  - state ( state management )

## Package Used
  - flutter_riverpods
  - hooks_riverpod # using hook to control local state
  - go_router # nested page
  - sqflite # store data from request network or get local DB from assets
  - path_provider # get link directory from app - desktop
  - extended_image # cache image