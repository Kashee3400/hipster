
# User Directory App

A Flutter application to display user profiles with infinite scrolling, detail view, and robust error handling. It includes features like pagination, state management, image fallback handling, and clean UI separation using custom models.

---

## 🚀 How to Run the App

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-repo/user-directory-app.git
   cd user-directory-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

4. **Recommended tools:**
   - Flutter 3.16.0 or above
   - Android Studio / VSCode
   - iOS Simulator / Android Emulator / Physical Device

---

## 🧠 Architectural Approach

### 🔄 Pagination

- **API Parameters:** `_page` and `_limit` are used to paginate user data.
- On reaching the bottom of the scroll, the app fetches the next page **only if** new data is available.
- Empty list response is interpreted as **no more data**, and pagination is marked `Status.completed`.


### 🔧 State Management

* **Flutter Riverpod** is used for efficient and scalable state management.
* A custom `Status` enum tracks `loading`, `success`, `error`, and `completed` states.
* State includes current `page`, list of `users`, and `loadingMoreStatus` to manage pagination and UI updates.
* Business logic is decoupled from the UI, enhancing testability and maintainability.

### 🧭 Routing

* **GoRouter** is used for declarative and type-safe routing.
* Supports deep linking, nested navigation, and route guards for a structured navigation experience.

### 💾 Local Storage

* **SharedPreferences** is used to persist the last opened user profile locally.
* Ensures that the app can restore user context even after restarts, improving user experience.

---

### 🧪 Example Error Response

When invalid field access occurs, the API may respond like this:

```json
{
  "name": "Michale Faker Attribute Error: person.astName is not supported"
}
```

You can use this error format to identify and surface descriptive backend issues gracefully in the frontend.

---


- The app can be extended to use:
  - `hive` or `isar` for offline-first capabilities
- Currently, the focus is on remote fetching and real-time pagination.

---

## 🧩 Features

- Responsive and clean UI
- Profile detail view with:
  - Personal details
  - Contact information
  - Address & company info
- Circular avatar image with graceful fallback
- Scroll listener with smart page loading
- Error handling using Dio error wrapper
- Modular and reusable model (`UserProfile`)

---

## ⚠️ Challenges & Resolutions

| Challenge | Resolution |
|----------|------------|
| API returned plain array instead of a paginated wrapper | Implemented logic to check `list.isEmpty` and halt pagination |
| Scroll jump on prepend pagination | Calculated item height offset manually and used `scrollController.jumpTo()` |
| Network image failure | Implemented `errorBuilder` in `Image.network()` with default icon fallback |

---
## 📡 Networking

> 📌 **Note:** This project uses the [`dio`](https://pub.dev/packages/dio) package for all HTTP requests instead of the default `http` package.

### 💡 Why Dio over http?

`dio` was chosen over `http` because it provides more flexibility and developer-friendly features for building scalable apps:

- 🛠️ **Interceptors** – Easily manage headers (e.g., auth tokens), log requests/responses, or inject behavior globally.
- 📝 **Logging** – Built-in request/response logging support via `LogInterceptor`.
- ⏱️ **Timeouts & retries** – Customizable timeout for requests, responses, and connections.
- 📦 **Form data & file uploads** – Supports `FormData`, making it easy to handle file uploads and multipart requests.
- ❌ **Request cancellation** – Cancel any in-flight requests using `CancelToken`.
- 🚨 **Structured error handling** – More detailed and structured error objects (`DioException`) make it easier to diagnose problems.
- 🔁 **Base options** – Centralize base URL, headers, timeouts, and more in one config.

> The Dio client is configured globally in the app and reused throughout, improving maintainability and consistency.
