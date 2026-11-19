# Foundation Tutorials

A responsive PWA starter with an AI Doubt Desk, student profile flow, Google Identity Services integration point, and Capacitor Android wrapper configuration.

## Run locally

```bash
npm install
npm run dev
```

## Real Google sign-in

Create a Google OAuth **Web application** client in Google Cloud Console, add `http://localhost:8080` (and the deployed HTTPS origin) to Authorized JavaScript origins, then open the app at `http://localhost:8080` rather than double-clicking `index.html`. The Google button uses the official Google Identity Services account chooser. For production, validate the returned ID token on a server and persist users in a database; localStorage is only a demo profile store.

## Android APK

Install Android Studio and the Android SDK, then run `npm install`, `npm run android:add`, `npm run android:sync`, and `npm run android:open`. In Android Studio use Build > Generate App Bundles or APKs. The generated Android project is intentionally not committed until it is created by Capacitor.

The web UI no longer exposes an APK/download button. The native Android project is kept separately under `native-android`.

## Real Google sign-up and admin detection

In Google Cloud Console, create an OAuth 2.0 **Web application** client. Add the exact site origin (for example `http://localhost:8080`) under Authorized JavaScript origins, then replace `REPLACE_WITH_YOUR_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com` in `APP_STATE.googleClientId` inside `index.html`. The official Google account chooser will then appear. The ID token email is normalized and compared exactly against `ekamsingh4293@gmail.com`; only that address unlocks the Owner Admin CRM. All other Google accounts remain students.

## AI configuration

The client currently tries Groq first and falls back to OpenRouter's `baidu/ernie-5.5-flash-preview:free` model. Browser-exposed API keys are not safe for production; move these calls behind a server-side proxy before publishing.
