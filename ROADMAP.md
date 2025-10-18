# Athloop - Product Roadmap

**Last Updated**: 2025-10-18
**Current Live Version**: 1.0 (App Store - Published Oct 13, 2025)
**In Review**: 1.2 (pending Apple review)
**Next Release**: 1.3 (Bug Fixes)
**Following Release**: 1.4 (Strava Integration)

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

**Known Issues**:
- Goal doesn't appear immediately after creation (GoalStore refresh issue)
- Missing delete goal functionality
- Missing edit goal target date functionality
- CoreGraphics NaN warnings in console
- AutoLayout constraint warnings

---

### v1.1 - First Update ✅ TAGGED
**Status**: Tagged in git (Oct 2025)
**Release Date**: N/A (skipped submission)

**Changes**: Minor improvements and fixes

---

### v1.2 - Improvements ⏳ IN REVIEW
**Status**: Submitted to Apple App Store (Oct 2025, pending review)
**Estimated Approval**: Late October 2025

**Changes**: Additional improvements and refinements

---

## 🚧 Upcoming Releases

### v1.3 - Critical Bug Fixes 🎯 NEXT
**Status**: Planned - Starting now
**Target Submission**: Early November 2025
**Estimated Effort**: 2-3 days development + testing

#### Objectives
Fix critical bugs affecting user experience in production.

#### Backend Changes
- None required (bugs are frontend-only)

#### Frontend Changes

1. **Fix Goal Creation Refresh Issue** ⭐ CRITICAL
   - **Problem**: After creating a goal, it doesn't appear in GoalView until app restart
   - **Root Cause**: GoalStore not refreshing after successful creation
   - **Solution**: Trigger GoalStore refresh in OnboardingView after goal creation
   - **Files**: `OnboardingView.swift`, `GoalView.swift`
   - **Test**: Create goal → verify immediate appearance in Goal tab

2. **Add Delete Goal Functionality** ⭐ CRITICAL
   - **Problem**: Users cannot delete obsolete goals
   - **Solution**: Add swipe-to-delete gesture on goal list
   - **Implementation**:
     - Add `.swipeActions` modifier to goal list items
     - Call DELETE `/api/goals/{id}` endpoint (already exists in backend)
     - Refresh GoalStore after deletion
   - **Files**: `GoalView.swift`, `BackendAPIService.swift`
   - **UI**: Swipe left → red "Delete" button → confirmation alert
   - **Localization**: Add delete confirmation strings (EN/FR/ES)

3. **Add Edit Goal Target Date** ⭐ HIGH
   - **Problem**: Users cannot modify goal target date after creation
   - **Solution**: Add date picker in goal detail/edit mode
   - **Implementation**:
     - Add "Edit" button in GoalView goal card
     - Show date picker modal/sheet
     - Call PUT `/api/goals/{id}` endpoint with updated target_date
     - Refresh GoalStore after update
   - **Files**: `GoalView.swift`, `BackendAPIService.swift`
   - **UI**: "Edit" button → Date picker sheet → "Save"/"Cancel"
   - **Localization**: Add edit-related strings (EN/FR/ES)

4. **Investigate CoreGraphics NaN Warnings** ⚠️ MEDIUM
   - **Problem**: Console shows CoreGraphics NaN errors
   - **Investigation**:
     - Check if crashes are reported in App Store Connect
     - Identify source (likely GeometryReader or animation frames)
     - Fix if causing visible bugs or crashes
   - **Action**: Low priority if no user-facing impact

5. **Fix AutoLayout Constraint Warnings** ⚠️ LOW
   - **Problem**: AutoLayout warnings in console
   - **Investigation**: Review constraint conflicts
   - **Action**: Fix if time permits, not blocking release

#### Testing Checklist
- [ ] Create new goal → verify immediate appearance in Goal tab
- [ ] Swipe to delete goal → verify deletion + confirmation alert
- [ ] Edit goal target date → verify update + immediate reflection
- [ ] Test in light and dark mode
- [ ] Test in EN/FR/ES languages
- [ ] Verify no regression in plan generation
- [ ] Test on iOS 17 and iOS 18 (if available)

#### Localization Additions
**New Keys Required**:
```
// Delete goal
"goal.delete" = "Delete"
"goal.delete.confirm.title" = "Delete Goal?"
"goal.delete.confirm.message" = "This action cannot be undone."
"goal.delete.confirm.delete" = "Delete"
"goal.delete.confirm.cancel" = "Cancel"

// Edit goal
"goal.edit" = "Edit"
"goal.edit.title" = "Edit Goal"
"goal.edit.save" = "Save Changes"
"goal.edit.cancel" = "Cancel"
```

#### Success Metrics
- ✅ Goal appears immediately after creation (100% success rate)
- ✅ Users can delete goals without app restart
- ✅ Users can modify target dates without recreating goals
- 📉 Reduce negative reviews related to goal management

---

### v1.4 - Strava Integration 🚀 MAJOR FEATURE
**Status**: Planned
**Target Submission**: Late November 2025
**Estimated Effort**: 5-7 days development + 2 days testing

#### Objectives
- Provide alternative to HealthKit for activity data
- Enable multi-platform support (iOS, Android future, Web future)
- Improve data quality from dedicated sports devices (Garmin, Wahoo, etc.)
- Maintain privacy-first approach (no activity storage)

#### Implementation Plan
**Full documentation**: See `STRAVA_INTEGRATION.md` for complete 17-phase plan

**High-Level Phases**:

1. **Phase 1-2**: Strava API Setup + Backend Database Migration
   - Create Strava app credentials
   - Add OAuth token fields to User model
   - Migration: `alembic revision --autogenerate -m "add strava integration"`

2. **Phase 3-6**: Backend Implementation
   - `app/strava_service.py`: OAuth flow, token management, activity fetching
   - API endpoints: `/api/strava/auth-url`, `/api/strava/callback`, `/api/strava/activities`, `/api/strava/disconnect`
   - Modify `/api/generate-plan` to use Strava data if connected
   - Unit tests for StravaService
   - Integration tests for OAuth flow

3. **Phase 7-12**: iOS Implementation
   - `StravaActivity.swift` model
   - `BackendAPIService.swift` additions for Strava endpoints
   - `StravaConnectionView.swift` with OAuth via ASWebAuthenticationSession
   - Modify `HealthDataView.swift`: Add segmented control (HealthKit | Strava)
   - Deep link handling: `athloop://strava-connected`
   - Settings integration for connected sources

4. **Phase 13-15**: Localization, UI Polish, Testing
   - Add Strava-related strings (EN/FR/ES)
   - Strava branding (logo, colors)
   - Activity type icons
   - End-to-end testing (OAuth, plan generation, disconnect)
   - Edge cases (no activities, expired tokens, rate limits)

5. **Phase 16-17**: Documentation + Deployment
   - Update CLAUDE.md with Strava integration details
   - Deploy to Railway with STRAVA_CLIENT_ID and STRAVA_CLIENT_SECRET
   - TestFlight beta testing
   - App Store submission

#### Architecture Decision
**On-Demand Fetching (No Storage)**:
- ✅ Privacy-first: consistent with "Your data is not stored" message
- ✅ Always fresh data (no sync issues)
- ✅ Simpler backend (no activity DB tables)
- ✅ GDPR compliant (minimal data retention)
- ✅ Viable: Strava API limits are generous (100/15min, 1000/day)

**Data Flow**:
```
iOS App → Backend API → Strava API (on-demand)
   ↓           ↓
Display     Summarize for AI
(no storage) (plan generation)
```

#### Success Metrics
- ✅ OAuth success rate > 95%
- ✅ Token refresh success rate > 99%
- ✅ API response time < 2s for activity fetch
- ✅ Zero activity data stored in database
- 📈 % of users connecting Strava vs HealthKit
- 📈 Plan generation success rate with Strava data

#### Testing Checklist
- [ ] OAuth flow end-to-end (authorize on Strava → callback → token storage)
- [ ] Token auto-refresh after 6h expiration
- [ ] Activity display in HealthDataView (Strava tab)
- [ ] Plan generation with Strava data vs HealthKit data
- [ ] Disconnect flow (removes tokens, clears UI)
- [ ] Switch between HealthKit and Strava tabs
- [ ] Edge cases: no activities, invalid tokens, network errors, rate limiting
- [ ] Privacy verification: confirm no activities in database
- [ ] Test in EN/FR/ES

---

## 🔮 Future Versions (Post v1.4)

### v1.5 - User Profiles & Personalization
**Estimated**: December 2025

**Backend**:
- Add user profile fields: age, height, weight, gender
- Migration to add profile columns to User table
- Update AI prompts to include profile data for better recommendations

**Frontend**:
- Profile configuration screen (Settings tab)
- Profile onboarding step (optional, after goal selection)
- Update AI plan generation to send profile data

**Features**:
- Better AI personalization based on user demographics
- Age-appropriate training intensity
- Weight-based calorie calculations

---

### v1.6 - Coach Personality Customization
**Estimated**: January 2026

**Backend**:
- Add `coach_personality` field to User model (enum: motivating, military, cool, supportive, balanced)
- Update AI prompts with personality-specific instructions
- Different tone/language based on personality

**Frontend**:
- Personality selection screen (onboarding or settings)
- Preview examples for each personality type
- UI elements reflecting chosen personality (colors, icons, language)

**Personalities**:
- **Motivating**: Encouraging, positive, celebrates wins
- **Military**: Direct, disciplined, challenging
- **Cool**: Laid-back, friendly, chill vibes
- **Supportive**: Empathetic, understanding, gentle
- **Balanced**: Mix of all (default)

---

### v1.7 - Offline Persistence
**Estimated**: February 2026

**Backend**:
- No changes required

**Frontend**:
- Local SQLite database (or Core Data)
- Cache goals, plans, workouts offline
- Sync with backend when online
- Offline-first architecture

**Benefits**:
- App works without internet
- Faster load times
- Better UX in low-connectivity areas

---

### v2.0 - Advanced Features & Production Hardening
**Estimated**: March-April 2026

**Backend**:
- JWT authentication (replace Device-ID for production)
- Rate limiting (protect API from abuse)
- Redis cache for frequently accessed plans
- Monitoring and observability (Sentry, logging)
- Webhooks for Strava real-time updates
- Usage analytics dashboard

**Frontend**:
- Multi-device sync (iCloud or backend sync)
- Extended HealthKit metrics: VO2 max, heart rate zones, sleep analysis
- Performance history charts (trends over weeks/months)
- Social features (share workouts, challenges)
- In-app notifications

**Production**:
- Multi-tenant architecture
- Credit system for monetization
- API versioning (/api/v1, /api/v2)

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

## 🐛 Known Issues Tracking

### Critical (Blocks users)
- ✅ Goal doesn't appear after creation → **v1.3**
- ✅ Cannot delete goals → **v1.3**
- ✅ Cannot edit goal date → **v1.3**

### High (Degrades UX)
- None currently identified

### Medium (Annoying but workarounds exist)
- ⚠️ CoreGraphics NaN warnings → **v1.3** (investigate)

### Low (Console noise, no user impact)
- ⚠️ AutoLayout constraint warnings → **v1.3** (if time permits)

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

## 📝 Notes

### Why Strava is High Priority (v1.4)
1. **Multi-platform strategy**: Opens door to Android/Web in future
2. **User demand**: Serious athletes use Garmin/Wahoo → sync to Strava
3. **Competitive advantage**: Most fitness apps support Strava
4. **Data quality**: Better than HealthKit for serious athletes with dedicated devices
5. **Privacy win**: Strengthens "we don't store your data" message

### Why User Profiles Before Coach Personality (v1.5 → v1.6)
- Profiles enable better AI recommendations immediately
- Personality requires profiles for best results (age-appropriate tone)
- Logical progression: Data → Personalization → Style

---

**Created**: 2025-10-18
**Maintained By**: Development Team
**Review Frequency**: After each release
