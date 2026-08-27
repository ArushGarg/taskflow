# TaskFlow — Flutter Developer Intern Assignment (Whatbytes)

A task management app for gig workers: Firebase email/password auth, task
CRUD with due date + priority, filtering by priority/status, and a list
sorted by due date. Built with clean architecture and `flutter_bloc`.

## Screenshots

### Authentication
| Sign up | Log in |
|---|---|
| ![Sign up screen](https://github.com/user-attachments/assets/604838b5-3e42-4739-aba6-86f52f5e4963) | ![Login screen](https://github.com/user-attachments/assets/c58bde48-ca65-45ac-814e-cc25a844880e) |

New users create an account with email + password on the **Sign up**
screen; returning users land on **Log in**. Both run through Firebase Auth
and show inline validation before submitting (see `Validators` in
`core/utils/validators.dart`), plus a snackbar with a readable message if
Firebase rejects the credentials (e.g. wrong password, email already in
use).

### Empty state
| No tasks yet |
|---|
| ![Empty task list](https://github.com/user-attachments/assets/e59c7628-4fbc-4494-b746-36642be860a6) |

A first-time user (or an active filter with no matches) sees a friendly
empty state instead of a blank screen, with a prompt to tap **+** to add a
task.

### Creating a task
| Add task form | Due date picker | Filled out |
|---|---|---|
| ![Add task form](https://github.com/user-attachments/assets/ef832169-7148-40e8-a7a5-943d3c4f9496) | ![Date picker](https://github.com/user-attachments/assets/2b684491-316d-41eb-bd77-96a65cb20d36) | ![Filled add task form](https://github.com/user-attachments/assets/75d72101-78c9-4db0-a95d-77943c35db3d) |

The **New task** screen collects title, description, due date (via the
native Material date picker), and priority (Low / Medium / High, selected
as a segmented control). Title is required; everything else is optional
except priority, which defaults to Medium.

### Task list, completion, and filtering
| Task list | Marked complete | Completed filter |
|---|---|---|
| ![Task list with a task](https://github.com/user-attachments/assets/a4b7874b-3b94-45da-aa01-b916b453f512) | ![Task marked complete](https://github.com/user-attachments/assets/a7955d0c-bb2a-4f22-8070-5f02baca3c83) | ![Completed filter, empty result](https://github.com/user-attachments/assets/f8265a42-cc9f-4239-86f2-460ffb99440d) |

Tasks are grouped by due date (Overdue / Today / Tomorrow / This week /
Later) and show their priority as a colored pill. Tapping the circle
toggles complete/incomplete instantly (strikethrough + green check) — no
need to open the task. The filter bar combines a status filter (All /
Incomplete / Completed) with a priority filter (Low / Medium / High); the
third screenshot shows the **Completed** filter applied while the one
existing task is still incomplete, so the list correctly shows the empty
state rather than a stale result.

### Account menu
| Sign out |
|---|
| ![Account menu with log out](https://github.com/user-attachments/assets/544a755d-29ff-4d53-98cc-fd468acfca70) |

The overflow menu in the top-right shows the signed-in email and a **Log
out** action, which routes back to the Login screen via `AuthGate`
reacting to Firebase's auth-state stream.

## Architecture

Clean architecture, split by feature:

```
lib/
├── core/                     # shared, feature-agnostic code
│   ├── di/injection.dart     # get_it service locator
│   ├── error/failures.dart   # Failure hierarchy
│   ├── theme/app_theme.dart  # colors, ThemeData
│   ├── usecases/usecase.dart # base UseCase<Type, Params> contract
│   ├── utils/result.dart     # tiny Either<Failure, T> replacement
│   └── widgets/               # shared widgets (PrimaryButton)
│
└── features/
    ├── auth/
    │   ├── data/          # FirebaseAuth data source + repo impl
    │   ├── domain/        # UserEntity, AuthRepository, use cases
    │   └── presentation/  # AuthBloc, login/signup pages, AuthGate
    │
    └── tasks/
        ├── data/          # Firestore data source, TaskModel, repo impl
        ├── domain/        # TaskEntity, TaskFilter, TaskRepository, use cases
        └── presentation/  # TaskBloc, list/add-edit pages, widgets
```

Each feature is independently layered — `domain` has zero Flutter/Firebase
imports, `data` implements the domain's repository contracts against
Firebase, and `presentation` only talks to `domain` (use cases + entities),
never to `data` directly. Dependencies are wired in `core/di/injection.dart`
with `get_it` and provided to the widget tree via `flutter_bloc`'s
`MultiBlocProvider` in `main.dart`.

State management is `flutter_bloc`: `AuthBloc` mirrors Firebase's
`authStateChanges()` stream, and `AuthGate` swaps between the auth flow and
the task list based on that state — no manual navigation calls needed.
`TaskBloc` subscribes to a live Firestore query (already sorted by
`dueDate`) and applies the active priority/status filter in the state's
`visibleTasks` getter, so filtering never re-queries Firestore.

Data model: tasks are stored per-user at `users/{uid}/tasks/{taskId}`
(see `firestore.rules`) so a single security rule guarantees users can only
ever read/write their own tasks.

## Setup

1. **Install dependencies**
```
   flutter pub get
```

2. **Create a Firebase project** at console.firebase.google.com.
    - Enable **Authentication → Sign-in method → Email/Password**.
    - Create a **Firestore Database** (start in test mode is fine locally).
    - In Firestore → Rules, paste the contents of `firestore.rules` from
      this repo and publish.

3. **Connect the app to your Firebase project**
```
   dart pub global activate flutterfire_cli
   flutterfire configure
```
This overwrites the placeholder `lib/firebase_options.dart` with your
real project's credentials and registers the Android/iOS apps. (The
placeholder file in this repo will not build against a real backend on
its own — this step is required.)

4. **Run**
```
   flutter run
```

## Features implemented

- Email/password sign up & login via Firebase Auth, with readable error
  messages for invalid credentials, weak passwords, etc.
- Create / edit / delete tasks (swipe-to-delete with confirmation, or from
  the edit screen).
- Task fields: title, description, due date, priority (low/medium/high).
- Toggle complete/incomplete from the list without opening the task.
- Filter by priority and by status (all / completed / incomplete),
  combinable.
- List sorted by due date (earliest first), grouped into Overdue / Today /
  Tomorrow / This week / Later.
- Material Design UI, tuned to the palette/spacing in the reference mocks,
  responsive across common phone sizes.

## Notes / trade-offs

- Used `get_it` for DI instead of `provider`/`riverpod`-based DI to keep
  the use-case boundary explicit; swapping to `riverpod` for state
  management instead of `flutter_bloc` would mainly touch the
  `presentation/bloc` folders — the domain/data layers are unaffected by
  that choice, which is the point of keeping them separate.
- No local offline cache (e.g. Hive) — Firestore's own offline persistence
  is enabled by default on mobile, which covers the "local storage" ask
  for typical gig-worker use (spotty connectivity, not fully offline-first).
  Given more time, I'd add an explicit offline-first cache layer and
  optimistic UI updates for add/edit/delete.
- No automated tests included given the assignment's time-box; the
  repository/use-case boundary is written specifically to make unit
  testing the bloc layer straightforward (mock the repository, no Firebase
  needed) if that's wanted next.
