# Athloop - Product Roadmap

**Last Updated**: 2025-10-20
**Current Live Version**: 1.0 (App Store - Published Oct 13, 2025)
**In Review**: 1.1 (Goal Management + E2E Testing - Pending Apple review)
**Next Release**: 1.2 (Strava Integration)

---

## 📦 Version History

### v1.0 - Initial Release ✅ LIVE
**Status**: Published on App Store
**Release Date**: 2025-10-13

**Features**:
- Custom fitness goals with AI analysis
- AI-generated personalized training plans
- HealthKit integration (optional)
- Progress tracking system
- Multilingual support (EN/FR/ES)
- Dark mode support
- Guided onboarding flow

**Known Issues** (fixed in v1.1):
- ~~Goal doesn't appear immediately after creation~~ ✅ Fixed
- ~~Missing delete goal functionality~~ ✅ Fixed
- ~~Missing edit goal target date functionality~~ ✅ Fixed
- CoreGraphics NaN warnings in console (no user impact)
- AutoLayout constraint warnings (cosmetic)

---

### v1.1 - Goal Management + E2E Testing ⏳ IN REVIEW
**Status**: Submitted to Apple App Store (Oct 20, 2025)
**Estimated Approval**: Late October 2025
**Development Time**: 3 days
**Test Coverage**: Backend 77%, Frontend 55% (E2E tests)

#### Objectives
Fix critical bugs affecting user experience in production and establish comprehensive E2E testing infrastructure.

#### Backend Changes
1. **Test Endpoint for UI Testing** ✅
   - Added `/api/test/clear-user` endpoint to reset user data between tests
   - Protected by `ENABLE_TEST_ENDPOINTS` environment variable
   - Enables test isolation for onboarding flows

#### Frontend Changes

1. **Fix Goal Creation Refresh Issue** ✅ COMPLETED
   - **Problem**: After creating a goal, it doesn't appear in GoalView until app restart
   - **Solution**: Fixed GoalStore refresh in OnboardingView after goal creation
   - **Files**: `OnboardingView.swift`, `GoalView.swift`

2. **Add Delete Goal Functionality** ✅ COMPLETED
   - **Solution**: Added menu button on goal cards with delete action
   - **Implementation**:
     - Added contextual menu with delete option
     - Calls DELETE `/api/goals/{id}` endpoint
     - Refresh GoalStore after deletion
   - **Files**: `GoalView.swift`, `BackendAPIService.swift`
   - **UI**: Menu button (•••) → Delete → confirmation alert
   - **Localization**: Added delete strings (EN/FR/ES)

3. **Add Edit Goal Target Date** ✅ COMPLETED
   - **Solution**: Added edit functionality via menu with date picker
   - **Implementation**:
     - Edit option in goal card menu
     - CollapsibleDatePicker component for date selection
     - Calls PUT `/api/goals/{id}` endpoint
     - Refresh GoalStore after update
   - **Files**: `GoalView.swift`, `BackendAPIService.swift`, `CollapsibleDatePicker.swift`
   - **UI**: Menu → Edit → Date picker sheet → Save/Cancel
   - **Localization**: Added edit strings (EN/FR/ES)

4. **Multi-Goal Support** ✅ COMPLETED
   - Users can now create and manage multiple active goals simultaneously
   - Goal list properly displays all active goals
   - First goal (closest deadline) is used for plan generation

#### E2E Testing Infrastructure (NEW)

**Test Suites**:
1. **AthloopUITests.swift** - 12 tests covering:
   - Tab navigation
   - Goal view elements and accessibility
   - Plan view elements
   - Health tab basics
   - Performance testing

2. **OnboardingUITests.swift** - 6 tests covering:
   - Complete 4-step onboarding flow
   - Goal suggestions and custom input
   - Back navigation
   - HealthKit toggle

**Coverage Tracking**:
- **Backend**: 77% coverage via Python `coverage` tool
- **Frontend**: 55% coverage via Xcode code coverage
- Unified `run_e2e_tests.sh` script runs both with full coverage reporting

**Test Isolation**:
- Tests use fixed device ID (`UI-TEST-ONBOARDING-DEVICE`)
- Automatic data cleanup via `/api/test/clear-user` endpoint
- Each test starts with clean state

**Accessibility**:
- All UI elements use accessibility identifiers (language-independent)
- Tests are stable across translations

**Documentation**:
- `README_E2E.md` - Quick start guide
- `E2E_TESTING.md` - Comprehensive testing guide
- `XCODE_COVERAGE_SETUP.md` - Xcode coverage configuration

#### Testing Results
- ⚠️ E2E infrastructure complete, tests need environment variable fixes
- ✅ Manual testing: Goal appears immediately after creation
- ✅ Manual testing: Users can delete goals via menu
- ✅ Manual testing: Users can modify target dates via menu
- ✅ Manual testing: Multi-goal support working correctly
- ✅ Manual testing: All features tested in light/dark mode
- ✅ Manual testing: All features tested in EN/FR/ES languages
- 📊 Backend coverage: 77% (via E2E test run)

#### Known Remaining Issues
- ⚠️ CoreGraphics NaN warnings (no user-facing impact)
- ⚠️ AutoLayout constraint warnings (cosmetic)

---

## 🚧 Upcoming Releases

All detailed feature planning is tracked in GitHub Issues: https://github.com/cgranetgithub/athloop-docs/issues

### v1.2 - Strava Integration 🚀 MAJOR FEATURE
**Status**: Planned
**Target**: Late November 2025
**GitHub Issue**: [#4](https://github.com/cgranetgithub/athloop-docs/issues/4)
**Effort**: 5-7 days dev + 2 days testing

**Key Features**:
- OAuth integration with Strava
- Activity data fetching (on-demand, no storage)
- Alternative to HealthKit for multi-platform strategy
- Detailed spec: `STRAVA_INTEGRATION.md`

**Bug Fixes in v1.2**:
- [#1](https://github.com/cgranetgithub/athloop-docs/issues/1) - Remove days_remaining from backend API
- [#2](https://github.com/cgranetgithub/athloop-docs/issues/2) - Add missing Spanish translations
- [#3](https://github.com/cgranetgithub/athloop-docs/issues/3) - Fix goal/plan data inconsistency

---

## 🔮 Future Versions

### v1.3 - User Profiles & Personalization
**Target**: December 2025
**GitHub Issue**: [#5](https://github.com/cgranetgithub/athloop-docs/issues/5)
**Effort**: 3-4 days

Age, height, weight, gender for better AI personalization.

---

### v1.4 - Coach Personality Customization
**Target**: January 2026
**GitHub Issue**: [#6](https://github.com/cgranetgithub/athloop-docs/issues/6)
**Effort**: 4-5 days

Choose coach tone: Motivating, Military, Cool, Supportive, or Balanced.

---

### v1.5 - Offline Persistence
**Target**: February 2026
**GitHub Issue**: [#7](https://github.com/cgranetgithub/athloop-docs/issues/7)
**Effort**: 5-7 days

Local caching with Core Data for offline-first experience.

---

### v2.0 - Production Hardening & Advanced Features
**Target**: March-April 2026
**GitHub Issue**: [#8](https://github.com/cgranetgithub/athloop-docs/issues/8)
**Effort**: 3-4 weeks

JWT auth, rate limiting, Redis cache, monitoring, multi-device sync, extended HealthKit metrics, monetization.

---

## 📊 Development Guidelines

### Version Numbering
- **Major (X.0)**: Breaking changes, major features
- **Minor (1.X)**: New features, significant improvements
- **Patch (1.0.X)**: Bug fixes only (not currently used)

### Release Cycle
1. Development in `main` branch
2. Feature complete → Tag version (e.g., `v1.3`)
3. Build in Xcode → Archive → Upload to App Store Connect
4. Submit for review
5. Once approved → Release to App Store
6. Monitor crash reports and user feedback
7. Plan next version based on feedback

### Git Workflow
```bash
# Feature development
git checkout -b feature/goal-deletion
# ... make changes ...
git commit -m "Add goal deletion with swipe gesture"
git checkout main
git merge feature/goal-deletion

# Tag when ready for release
git tag -a v1.3 -m "Critical bug fixes: goal refresh, delete, edit date"
git push origin v1.3
```

### Testing Before Each Release
- [ ] Run backend tests: `./run_tests.sh` (must pass 100%)
- [ ] Manual testing on physical device (all flows)
- [ ] Test light/dark mode
- [ ] Test all supported languages (EN/FR/ES)
- [ ] Test with/sans HealthKit
- [ ] Check backend Railway stability
- [ ] Review Xcode warnings (address criticals)
- [ ] Update version/build number in Xcode
- [ ] Update CHANGELOG.md

### Deployment Checklist
- [ ] Backend: Deploy to Railway (if backend changes)
- [ ] Frontend: Archive in Xcode → Upload to App Store Connect
- [ ] Update App Store screenshots (if UI changes)
- [ ] Update "What's New" in App Store Connect
- [ ] Submit for review
- [ ] Monitor review status daily

---

## 📈 Success Metrics

### App Store Metrics (Monitor)
- ⭐ Rating: Target 4.5+ stars
- 📥 Downloads: Track monthly growth
- 💬 Reviews: Respond to feedback within 48h
- 🐛 Crash-free rate: Target 99%+

### User Engagement (Post v2.0 Analytics)
- Daily Active Users (DAU)
- Weekly Active Users (WAU)
- Goal creation rate
- Plan generation rate
- HealthKit vs Strava adoption

---

## 📞 Support & Feedback

**User Feedback Channels**:
- App Store reviews (monitor daily)
- Support email: support@athloop.app
- GitHub issues (for developers)

**Response SLA**:
- Critical bugs: Fix within 48h, hotfix release
- High priority: Fix in next minor version
- Feature requests: Evaluate and prioritize in roadmap

---

---

**Created**: 2025-10-18
**Maintained By**: Development Team
**Review Frequency**: After each release
