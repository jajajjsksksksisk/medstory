# MedStory – Start Here (No Coding Needed)

You do **not** need to know programming.
Just follow these steps one by one.

---

## What you need

1. A computer (Windows, Mac, or Linux)
2. Internet connection
3. About 30–60 minutes the first time

---

## Step 1 – Install Flutter (only once)

### On Windows:
1. Go to this website: https://docs.flutter.dev/get-started/install/windows
2. Download the Flutter SDK zip
3. Extract it (for example to `C:\flutter`)
4. Follow the instructions on that page to add Flutter to PATH
5. Open **PowerShell** or **Command Prompt** and type:

```
flutter doctor
```

Fix any red errors it shows (it will tell you what to install).

### On Mac:
1. Go to: https://docs.flutter.dev/get-started/install/macos
2. Follow the instructions (using Homebrew is easiest)
3. In Terminal run:

```
flutter doctor
```

---

## Step 2 – Download the MedStory app code

Open Terminal (Mac) or PowerShell (Windows) and copy-paste these commands one by one:

```
git clone https://github.com/jajajjsksksksisk/medstory.git
```

```
cd medstory
```

```
flutter pub get
```

---

## Step 3 – Run the app

### Option A – On your phone (easiest to feel real)

**Android phone:**
1. On your phone: Settings → About phone → tap Build number 7 times (Developer options)
2. Enable USB debugging
3. Connect phone to computer with USB cable
4. In the terminal (inside medstory folder) type:

```
flutter run
```

**iPhone:**
- Needs a Mac + free Apple ID. A bit more steps. Tell me if you have a Mac and I will give exact steps.

### Option B – On computer (for testing)

```
flutter run -d chrome
```

This opens the app in your browser. Good enough to test everything.

---

## Step 4 – (Optional but recommended) Real AI

1. Go to: https://aistudio.google.com/app/apikey
2. Create a free Gemini API key (Google account needed)
3. Copy the key
4. Run the app like this (replace with your real key):

```
flutter run --dart-define=GEMINI_API_KEY=PASTE_YOUR_KEY_HERE
```

Without the key the app still works in **demo mode**.

---

## How to use the app (once it is running)

1. Open **Upload / Paste Notes**
2. Choose subject (Anatomy, Pharma, etc.)
3. Paste your lecture notes
4. Tap **Generate Summary + Cards + Stories**
5. Go to **Review** and study the flashcards
6. Before exams open **Last Day Revision**

That is the whole main flow.

---

## Important

- You do **not** need to write any code.
- I will keep improving the app on GitHub.
- When I add new features, you only need to run these two commands again:

```
git pull
flutter pub get
```

Then run the app again with `flutter run`.

---

## If something does not work

Just copy the error message and send it to me.
I will tell you exactly what to do (or fix it myself in the code).

You are not alone in this.
