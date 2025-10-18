# Changelog

All notable changes to Athloop will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### v1.3 - Critical Bug Fixes (In Development)
**Target Release**: Early November 2025

#### Added
- Delete goal functionality with swipe-to-delete gesture
- Edit goal target date with date picker
- Confirmation alerts for destructive actions

#### Fixed
- Goal doesn't appear immediately after creation (GoalStore refresh issue)
- Missing delete goal functionality
- Missing edit goal target date functionality

#### Changed
- Improved goal management UX

---

## [Released]

## [1.2] - October 2025 (In App Store Review)
**Status**: Submitted to Apple, pending approval

### Added
- Additional improvements and refinements

---

## [1.1] - October 2025 (Tagged, not submitted)
**Status**: Tagged in git, skipped App Store submission

### Added
- Minor improvements and fixes

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

**Last Updated**: 2025-10-18
