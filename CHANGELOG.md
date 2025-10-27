# Changelog

All notable changes to Athloop will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### v1.2 - Auto-generation & AI Enhancements ✅ COMPLETED
**Status**: Development Complete - Ready for Release
**Target Release**: Early November 2025
**Development Time**: 5 days
**Test Coverage**: All integration tests passing

#### Added
- **Auto-generation on Plan Expiration** (#9) ✅
  - Plans automatically regenerate when expired (last_day_date < current_date)
  - Full-screen loading view with animated progress messages (8 rotating steps)
  - Automatic polling every 2 seconds until plan ready
  - Manual regeneration button moved to header as icon (matching Goal tab UX)
  - `PlanGeneratingCard` component in Goal tab during generation
  - Parallel loading of goals and plan data in GoalView
- **Plan History Context for AI** (#10) ✅
  - AI coach now receives context from up to 3 previous plans
  - Creates progressive training plans that build on previous recommendations
  - Plans reference user's actual activity vs recommended workouts
  - Maintains coaching consistency and continuity week-over-week
- **Goal Deletion with Cascade** (#3) ✅
  - Hard delete implementation for goals in backend
  - Automatic cascade deletion of all associated plans
  - Prevents orphaned plans in database
  - Added `is_active` filter to `get_user_goals()` for future Archive feature (see #21)
  - Comprehensive integration tests (4 new test cases in `test_goal_deletion.py`)
- **Translation Completeness Test** ✅
  - Automated test validates EN/FR/ES localization files are synchronized
  - Prevents missing translations from reaching production

#### Fixed
- Goal doesn't appear immediately after creation (GoalStore refresh issue)
- Backend crash when checking expiration on generating plans (null recommendations)
- Duplicate state management (`isGeneratingPlan` → centralized in PlanStore)
- Multiple polling loops bug (added `isPolling` protection)
- State synchronization issues when switching between tabs
- Goal/plan data inconsistency from orphaned plans (#3)

#### Changed
- **Backward Compatibility for days_remaining** (#1) ✅
  - Maintained `days_remaining` field in backend API for v1.0/v1.1 compatibility
  - v1.2 frontend uses local computed property in `Goal.swift`
  - Graceful migration path without breaking older app versions
  - Field marked for removal once v1.0/v1.1 usage drops below 5%
- Improved goal management UX
- Centralized state management in stores (PlanStore, GoalStore)
- Reorganized Services folder structure (ActivityDataService, BackendAPIService, HealthKitManager)
- Enhanced AI prompts with plan history context (~700 chars per historical plan)

#### Technical
- Created `PlanStore.swift` for centralized plan state management
- Backend: `is_plan_expired()` now handles null recommendations safely
- Backend: `/api/current-plan` auto-generates on expiration
- Backend: `crud.delete_goal()` performs hard delete with cascade
- Backend: `crud.get_user_goals()` filters by `is_active == True`
- Frontend: Full-screen `PlanGeneratingView` component with animations
- Localization: Added generation messages in EN/FR/ES
- Testing: New `test_goal_deletion.py` with comprehensive cascade tests

---

## [Released]

## [1.1] - October 2025 (In App Store Review)
**Status**: Submitted to Apple on Oct 20, 2025, pending approval

### Added
- Goal Management improvements (delete, edit target date)
- E2E Testing infrastructure with comprehensive coverage
- Bug fixes and stability improvements

---

## [1.0] - 2025-10-13 ⭐ INITIAL RELEASE
**Status**: Published on App Store

### Added
- **AI-Powered Goal Analysis**: Intelligent validation and reformulation of fitness goals
- **Personalized Training Plans**: AI-generated plans based on user goals and activity data
- **HealthKit Integration**: Optional sync with Apple Health for workout data
  - Workout analysis (type, duration, distance, calories)
  - Heart rate data
  - Sleep data (basic)
- **Progress Tracking System**:
  - Progression percentage (0-100%)
  - Progress status (on track, ahead, behind)
  - AI-generated progress feedback
  - Predicted completion date
- **Guided Onboarding Flow**:
  - Welcome screen with injury prevention philosophy
  - Goal selection (preset or custom)
  - Target duration selection
  - Optional HealthKit permissions
  - Automatic first plan generation
- **Multilingual Support**: Full localization in English, French, and Spanish
- **Dark Mode**: Complete adaptive UI with proper dark mode support
- **Data Sync Guide**: Instructions for connecting smartwatches (Garmin, Fitbit, Strava, Polar, Huawei)
- **Design System**: Centralized design tokens for consistent UI
  - Brand colors (turquoise, emerald, azure, coral)
  - Typography scales
  - Spacing and corner radius constants

### Backend
- **FastAPI REST API** with async plan generation
- **Claude AI Integration** (Sonnet 4) for personalized recommendations
- **PostgreSQL Database** with Alembic migrations
- **Device-ID Authentication** (no login required)
- **User Language Preference** management (en/fr/es)
- **Error Handling** with standardized error codes and responses
- **Background Task Processing** for plan generation
- **Activity Summary Fallback** for users without HealthKit data

### Frontend
- **Native iOS App** (iOS 17.0+)
- **SwiftUI** with @Observable state management
- **Three Main Tabs**:
  - Goal: Create and manage fitness goals
  - Plan: View current AI-generated training plan
  - Health: Visualize HealthKit data
- **Type-Safe Localization** (L10n system)
- **Adaptive Design** for light/dark mode
- **HealthKit Manager** for health data access
- **Backend API Service** with automatic URL selection (debug/release)

### Known Issues
- Goal doesn't appear immediately after creation (requires app restart) → Fixed in v1.3
- Missing delete goal functionality → Fixed in v1.3
- Missing edit goal target date → Fixed in v1.3
- CoreGraphics NaN warnings in console (no user-facing impact)
- AutoLayout constraint warnings in console

---

## Version Numbering

- **Major (X.0)**: Breaking changes, major features
- **Minor (1.X)**: New features, significant improvements
- **Patch (1.0.X)**: Bug fixes only (not currently used)

---

## Categories

- **Added**: New features
- **Changed**: Changes to existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security fixes

---

**Last Updated**: 2025-10-27
