# GitHub Issues to Create for Athloop

This file contains all issues to be created in the athloop-docs GitHub repository.

---

## BUGS (3 issues)

### Issue #1: Remove days_remaining from backend API

**Labels**: `bug`, `backend`, `enhancement`
**Milestone**: v1.2
**Priority**: Medium

**User Story**:
As a developer
I want to remove server-side calculation of days_remaining
So that the backend has less unnecessary computation and the client has more control

**Context & Problem**:
Currently, the backend calculates `days_remaining` for each goal and sends it in the API response. This is inefficient because:
- The client can easily calculate this from `target_date`
- It adds unnecessary computation to every API response
- It's not a true backend responsibility (it's presentation logic)

**Acceptance Criteria**:
- [ ] Remove `days_remaining` field from Goal API responses (`/api/goals`, `/api/goals/{id}`)
- [ ] Update frontend GoalView to calculate days remaining client-side
- [ ] Verify all E2E tests still pass
- [ ] Update API documentation

**Technical Implementation Notes**:
- Backend: Remove `days_remaining` from `app/api.py` goal serialization
- Frontend: Add computed property in `Goal.swift`: `var daysRemaining: Int { ... }`
- Frontend: Update `GoalView.swift` to use local calculation

**Testing Requirements**:
- [ ] Backend API tests verify field is not present
- [ ] Frontend UI tests verify countdown still displays correctly
- [ ] Manual testing: goal cards show correct days remaining

---

### Issue #2: Add missing Spanish translations

**Labels**: `bug`, `frontend`, `i18n`
**Milestone**: v1.2
**Priority**: High

**User Story**:
As a Spanish-speaking user
I want all UI elements to be translated
So that I have a consistent experience in my language

**Context & Problem**:
Some UI strings in the iOS app are missing Spanish translations. English fallbacks are showing for Spanish users, creating an inconsistent user experience.

**Acceptance Criteria**:
- [ ] Audit all `Localizable.strings` files (en/fr/es) to identify missing Spanish strings
- [ ] Add missing translations for all identified strings
- [ ] Verify Spanish language in app displays 100% translated UI
- [ ] Update onboarding, goals, plan, and health tabs

**Technical Implementation Notes**:
- Files to check: `Athloop/Localizable/es.lproj/Localizable.strings`
- Use same structure as English/French versions
- Maintain tone consistency with existing Spanish strings

**Testing Requirements**:
- [ ] Manual testing: switch iOS system language to Spanish
- [ ] Verify all screens show Spanish text (no English fallbacks)
- [ ] Test onboarding flow, goal creation, plan view in Spanish

---

### Issue #3: Fix data inconsistency - goal without plan, plan without goal

**Labels**: `bug`, `backend`, `database`
**Milestone**: v1.2
**Priority**: High

**User Story**:
As a user
I want goals and plans to stay synchronized
So that I don't see orphaned plans or goals without plans

**Context & Problem**:
During testing, we've observed:
- A goal exists but has no plan
- The plan tab shows a plan, but that plan doesn't belong to any active goal

This suggests:
- Foreign key constraints may not be properly enforced
- Soft delete on goals might leave orphaned plans
- Plan generation might create plans for non-existent goals

**Acceptance Criteria**:
- [ ] Audit database schema for proper foreign key constraints
- [ ] Ensure cascading delete: when goal is deleted, associated plans are also deleted
- [ ] Verify plan generation always validates goal exists before creating plan
- [ ] Add database migration if schema changes needed
- [ ] Reproduce the bug and verify fix prevents it

**Technical Implementation Notes**:
- Check `app/models.py`: `Plan.goal_id` foreign key relationship
- Check `app/crud.py`: delete_goal should cascade to plans
- Check `app/api.py`: `/api/generate-plan` validates goal existence
- Potential fix: Add `CASCADE` to foreign key or explicit plan deletion in goal delete endpoint

**Testing Requirements**:
- [ ] Unit test: deleting a goal deletes its plans
- [ ] E2E test: create goal → create plan → delete goal → verify no orphaned plan
- [ ] Database integrity check after test runs

---

## FEATURES (5 major issues)

### Issue #4: [FEATURE] Strava Integration

**Labels**: `enhancement`, `major-feature`, `backend`, `frontend`
**Milestone**: v1.2
**Priority**: Critical

**User Story**:
As a serious athlete who uses Garmin/Wahoo devices
I want to connect my Strava account
So that Athloop can generate better training plans based on my real activity data

**Context & Problem**:
- HealthKit is iOS-only, limiting future Android/Web support
- Many athletes use dedicated devices (Garmin, Wahoo) that sync to Strava, not HealthKit
- HealthKit data quality for serious athletes is inferior to Strava data
- Strava integration enables multi-platform strategy

**Acceptance Criteria**:

**Backend**:
- [ ] Create Strava app credentials (client_id, client_secret)
- [ ] Database migration: add `strava_access_token`, `strava_refresh_token`, `strava_expires_at` to User model
- [ ] Implement `app/strava_service.py`:
  - [ ] OAuth flow (auth URL generation, token exchange)
  - [ ] Token refresh logic (auto-refresh when expired)
  - [ ] Fetch activities endpoint (last 30 days)
  - [ ] Activity summarization for AI
- [ ] API endpoints:
  - [ ] `GET /api/strava/auth-url` - returns OAuth URL
  - [ ] `GET /api/strava/callback?code=...` - handles OAuth callback
  - [ ] `GET /api/strava/activities` - fetches recent activities
  - [ ] `DELETE /api/strava/disconnect` - removes tokens
- [ ] Modify `/api/generate-plan` to check for Strava data if HealthKit not available
- [ ] Unit tests for StravaService (OAuth, token refresh, activity parsing)
- [ ] Integration tests for OAuth flow

**Frontend (iOS)**:
- [ ] Create `StravaActivity.swift` model
- [ ] Add Strava endpoints to `BackendAPIService.swift`
- [ ] Create `StravaConnectionView.swift`:
  - [ ] OAuth button
  - [ ] ASWebAuthenticationSession for OAuth flow
  - [ ] Deep link handling: `athloop://strava-connected`
  - [ ] Connection status display
- [ ] Modify `HealthDataView.swift`:
  - [ ] Add segmented control: HealthKit | Strava
  - [ ] Show Strava activities when Strava tab selected
  - [ ] Show connection status
- [ ] Settings integration: show connected sources, allow disconnect
- [ ] Add Strava branding (logo, brand colors per Strava guidelines)
- [ ] Localization: add Strava strings (EN/FR/ES)

**E2E Testing**:
- [ ] OAuth flow: authorize on Strava → callback → tokens stored
- [ ] Token refresh after 6h expiration
- [ ] Fetch activities and display in UI
- [ ] Generate plan with Strava data
- [ ] Disconnect flow: removes tokens, clears UI
- [ ] Edge cases: no activities, invalid tokens, network errors, rate limiting
- [ ] Privacy verification: NO activities stored in database
- [ ] Test in EN/FR/ES

**Deployment**:
- [ ] Add `STRAVA_CLIENT_ID` and `STRAVA_CLIENT_SECRET` env vars to Railway
- [ ] Deploy backend to Railway
- [ ] TestFlight beta testing
- [ ] App Store submission

**Technical Implementation Notes**:
- Strava API rate limits: 100 requests/15min, 1000/day (generous for our use case)
- Privacy-first: on-demand fetching, NO activity storage
- Data flow: iOS → Backend → Strava API (fetch) → Summarize for AI → Return to iOS
- OAuth flow uses standard `ASWebAuthenticationSession` on iOS

**Related**:
- Full spec: `STRAVA_INTEGRATION.md` (17-phase detailed plan)
- Estimated effort: 5-7 days dev + 2 days testing

---

### Issue #5: [FEATURE] User Profiles & Personalization

**Labels**: `enhancement`, `backend`, `frontend`
**Milestone**: v1.3
**Priority**: High

**User Story**:
As a user
I want to provide my age, height, weight, and gender
So that the AI coach can give me more personalized training recommendations

**Context & Problem**:
- Current AI recommendations are generic (don't account for age, fitness level demographics)
- Age-appropriate training intensity is important (50-year-old vs 25-year-old have different recovery needs)
- Weight-based calorie calculations would improve nutrition guidance
- Demographic data enables better AI personalization

**Acceptance Criteria**:

**Backend**:
- [ ] Database migration: add columns to User model:
  - [ ] `age` (integer, nullable)
  - [ ] `height_cm` (integer, nullable)
  - [ ] `weight_kg` (float, nullable)
  - [ ] `gender` (enum: male/female/other/prefer_not_to_say, nullable)
- [ ] API endpoints:
  - [ ] `PUT /api/user/profile` - update profile fields
  - [ ] `GET /api/user` returns profile fields
- [ ] Modify AI prompts in `app/ai_service.py` to include profile data when generating plans
- [ ] Unit tests for profile update endpoint
- [ ] Privacy: profile fields are optional, nullable

**Frontend (iOS)**:
- [ ] Create `ProfileView.swift` (new Settings tab or within Health tab)
- [ ] Profile configuration form:
  - [ ] Age picker (18-100)
  - [ ] Height picker (metric/imperial toggle)
  - [ ] Weight picker (metric/imperial toggle)
  - [ ] Gender segmented control
- [ ] Optional onboarding step after goal selection (can skip)
- [ ] Update `BackendAPIService.swift` with profile update method
- [ ] Update plan generation to send profile data
- [ ] Localization: profile strings (EN/FR/ES)

**E2E Testing**:
- [ ] Create user profile → verify stored in backend
- [ ] Update profile → verify changes reflected
- [ ] Generate plan with profile data → verify AI mentions age/demographics
- [ ] Skip profile step in onboarding → app works fine (nullable fields)
- [ ] Test in EN/FR/ES

**Technical Implementation Notes**:
- All fields are optional (nullable in DB)
- Privacy-first: profile data used only for AI personalization, never shared
- AI prompt example: "User is 35 years old, 175cm, 75kg male. Adjust training intensity accordingly."

**Benefits**:
- Better AI personalization (age-appropriate training)
- Weight-based calorie calculations (future nutrition feature)
- Injury risk reduction (older users get more recovery time)

**Related**:
- Enables future feature: Coach Personality (v1.4) - age affects tone/language

**Estimated Effort**: 3-4 days

---

### Issue #6: [FEATURE] Coach Personality Customization

**Labels**: `enhancement`, `backend`, `frontend`, `ai`
**Milestone**: v1.4
**Priority**: Medium

**User Story**:
As a user
I want to choose my coach's personality style
So that I get motivational language that resonates with me

**Context & Problem**:
- Different users respond to different motivational styles
- Some want tough love ("military"), others want gentle encouragement ("supportive")
- Current AI tone is generic/balanced for all users
- Personalized tone increases engagement and adherence

**Acceptance Criteria**:

**Backend**:
- [ ] Database migration: add `coach_personality` to User model (enum: `motivating`, `military`, `cool`, `supportive`, `balanced`)
- [ ] Default: `balanced`
- [ ] API endpoint: `PUT /api/user/personality` - update coach personality
- [ ] Modify AI prompts in `app/ai_service.py` to include personality instructions:
  - [ ] **Motivating**: "Use encouraging, positive language. Celebrate wins. Be enthusiastic."
  - [ ] **Military**: "Be direct, disciplined, challenging. No excuses. Push harder."
  - [ ] **Cool**: "Be laid-back, friendly, casual. Chill vibes. Supportive but relaxed."
  - [ ] **Supportive**: "Be empathetic, understanding, gentle. Focus on progress, not perfection."
  - [ ] **Balanced**: "Mix of all styles. Professional yet friendly."

**Frontend (iOS)**:
- [ ] Create `PersonalitySelectionView.swift`
- [ ] UI:
  - [ ] 5 personality options with icons and descriptions
  - [ ] Preview examples for each personality (sample AI text)
  - [ ] Selection updates user profile
- [ ] Integration points:
  - [ ] Onboarding: optional step after profile (can skip, defaults to balanced)
  - [ ] Settings: can change personality anytime
- [ ] UI elements reflect personality:
  - [ ] **Motivating**: Bright colors, encouraging emojis
  - [ ] **Military**: Dark colors, bold fonts, no-nonsense UI
  - [ ] **Cool**: Relaxed colors, friendly icons
  - [ ] **Supportive**: Warm colors, gentle language
- [ ] Localization: personality descriptions (EN/FR/ES)

**E2E Testing**:
- [ ] Select each personality → generate plan → verify tone matches
- [ ] Switch personalities → regenerate plan → verify tone changes
- [ ] Skip personality selection → verify default (balanced) works
- [ ] Test in EN/FR/ES

**Technical Implementation Notes**:
- AI prompt examples:
  - **Motivating**: "Great job this week! You're crushing it! Keep this momentum going! 💪"
  - **Military**: "You ran 3 times this week. That's good. Now do 4 next week. No excuses."
  - **Cool**: "Nice work this week, you're making solid progress. Keep it chill and consistent."
  - **Supportive**: "You're doing wonderfully! Even small steps are progress. I'm proud of you."
  - **Balanced**: "Good work this week. You're on track. Let's keep building on this."

**Benefits**:
- Increased user engagement (personalized motivation)
- Better adherence to training plans (resonates with user's preferred style)
- Differentiation from generic fitness apps

**Dependencies**:
- Requires User Profiles (v1.3) for age-appropriate tone

**Estimated Effort**: 4-5 days

---

### Issue #7: [FEATURE] Offline Persistence

**Labels**: `enhancement`, `frontend`, `infrastructure`
**Milestone**: v1.5
**Priority**: Medium

**User Story**:
As a user with unreliable internet
I want the app to work offline
So that I can view my plans and track progress without connectivity

**Context & Problem**:
- Current app requires internet for all operations
- Users in gyms/trails often have poor connectivity
- Slow load times frustrate users
- App feels sluggish compared to native apps with local caching

**Acceptance Criteria**:

**Backend**:
- [ ] No changes required (backend remains API-based)

**Frontend (iOS)**:
- [ ] Add local persistence layer:
  - [ ] Choose: SQLite, Core Data, or SwiftData
  - [ ] Recommended: **Core Data** (native, battle-tested)
- [ ] Cache entities:
  - [ ] Goals (with target_date, title, description)
  - [ ] Plans (with analysis, recommendations, generated_at)
  - [ ] User profile
  - [ ] HealthKit activity summaries (last 30 days)
- [ ] Sync strategy:
  - [ ] On app launch: fetch latest from backend, update local cache
  - [ ] On create/update: write to backend → update local cache on success
  - [ ] On delete: soft delete locally, sync to backend when online
  - [ ] Background refresh: periodic sync when app is in background (if online)
- [ ] Offline indicators:
  - [ ] Show "Offline" badge in UI when no connection
  - [ ] Disable features requiring backend (generate new plan, update plan)
  - [ ] Show last sync timestamp
- [ ] Conflict resolution:
  - [ ] Backend is source of truth
  - [ ] On conflict, prefer backend data
  - [ ] Warn user if local changes will be overwritten

**E2E Testing**:
- [ ] Launch app offline → verify goals/plans load from cache
- [ ] Create goal offline → goes to pending queue → syncs when online
- [ ] Delete goal offline → soft delete locally → syncs when online
- [ ] View plan offline → shows cached plan
- [ ] Attempt to generate plan offline → show "Requires internet" error
- [ ] Turn on airplane mode → app remains functional (view-only)
- [ ] Go back online → verify sync completes successfully

**Technical Implementation Notes**:
- Use Core Data with CloudKit for future iCloud sync (optional in v2.0)
- Cache invalidation: 24h for plans, immediate for goals
- Local schema must match backend API schema
- Network reachability monitoring: `NWPathMonitor`

**Benefits**:
- App works without internet (view cached data)
- Faster load times (no network round-trips)
- Better UX in low-connectivity areas (gyms, trails)
- Feels more like a native app

**Related**:
- Enables future feature: Multi-device sync (v2.0) via iCloud/backend

**Estimated Effort**: 5-7 days

---

### Issue #8: [FEATURE] Production Hardening & Advanced Features

**Labels**: `enhancement`, `backend`, `frontend`, `infrastructure`, `major-feature`
**Milestone**: v2.0
**Priority**: Low (future)

**User Story**:
As the product owner
I want a production-ready, scalable architecture
So that Athloop can handle thousands of users securely and reliably

**Context & Problem**:
Current architecture is MVP-level:
- Device-ID authentication is not secure for production scale
- No rate limiting (vulnerable to abuse)
- No monitoring/observability (can't debug production issues)
- No caching (every request hits database)
- No multi-device sync (users lose data when switching phones)
- No monetization infrastructure

**Acceptance Criteria**:

**Backend**:
- [ ] **JWT Authentication**:
  - [ ] Replace Device-ID with proper user accounts
  - [ ] Email/password signup and login
  - [ ] JWT token generation and validation
  - [ ] Refresh token rotation
- [ ] **Rate Limiting**:
  - [ ] Redis-based rate limiter
  - [ ] Limits: 100 requests/min per user, 10 plan generations/day
  - [ ] Return 429 Too Many Requests with Retry-After header
- [ ] **Redis Cache**:
  - [ ] Cache frequently accessed plans (24h TTL)
  - [ ] Cache user profiles (1h TTL)
  - [ ] Cache goal lists (5min TTL)
- [ ] **Monitoring & Observability**:
  - [ ] Integrate Sentry for error tracking
  - [ ] Structured logging (JSON logs)
  - [ ] APM: track endpoint response times
  - [ ] Alerts: notify on 5xx errors, slow queries
- [ ] **Webhooks for Strava**:
  - [ ] Real-time updates when user completes activity on Strava
  - [ ] Verify webhook signatures
  - [ ] Store last_activity_timestamp only (no activity data)
- [ ] **API Versioning**:
  - [ ] Endpoints: `/api/v1/goals`, `/api/v2/goals`
  - [ ] Maintain v1 compatibility for 6 months after v2 launch
- [ ] **Usage Analytics**:
  - [ ] Track: plan generations, goal creations, logins
  - [ ] Dashboard: daily/weekly/monthly active users
  - [ ] Export: CSV for analysis

**Frontend (iOS)**:
- [ ] **Multi-Device Sync**:
  - [ ] User accounts (email/password login)
  - [ ] Sync goals/plans across devices via backend
  - [ ] Conflict resolution: last-write-wins
- [ ] **Extended HealthKit Metrics**:
  - [ ] VO2 max
  - [ ] Heart rate zones
  - [ ] Sleep analysis
  - [ ] Resting heart rate
  - [ ] HRV (Heart Rate Variability)
- [ ] **Performance History Charts**:
  - [ ] Weekly/monthly progress charts
  - [ ] Distance/duration trends
  - [ ] Pace improvements over time
  - [ ] Charts library: Swift Charts (native)
- [ ] **Social Features** (optional):
  - [ ] Share workouts to social media
  - [ ] Challenges (e.g., "Run 50km this month")
  - [ ] Leaderboards (opt-in)
- [ ] **In-App Notifications**:
  - [ ] Push notifications: "Time for your run!"
  - [ ] Local notifications: reminders for scheduled workouts
  - [ ] Badge count: unread plan updates

**Monetization**:
- [ ] **Credit System**:
  - [ ] Free tier: 5 plan generations/month
  - [ ] Paid credits: $0.99 for 10 generations (no subscription)
  - [ ] In-app purchase integration (StoreKit 2)
  - [ ] Backend: credit balance tracking, consumption, purchase verification
- [ ] **Premium Features** (optional):
  - [ ] Coach personality: $1.99 one-time unlock
  - [ ] Advanced analytics: $1.99 one-time unlock
  - [ ] Nutrition plans: $2.99 one-time unlock

**Infrastructure**:
- [ ] **Database Backups**:
  - [ ] Automated daily backups (Railway PostgreSQL)
  - [ ] Point-in-time recovery (last 7 days)
- [ ] **CI/CD**:
  - [ ] GitHub Actions: run tests on every push
  - [ ] Auto-deploy to staging environment on merge to `main`
  - [ ] Manual approval for production deploy
- [ ] **Load Testing**:
  - [ ] Simulate 1000 concurrent users
  - [ ] Identify bottlenecks
  - [ ] Optimize slow queries

**E2E Testing**:
- [ ] JWT auth flow: signup → login → access protected endpoints
- [ ] Rate limiting: exceed limits → verify 429 response
- [ ] Multi-device sync: create goal on device A → verify appears on device B
- [ ] Extended HealthKit: fetch VO2 max, sleep data → display in UI
- [ ] In-app purchase: buy credits → verify balance updates
- [ ] Performance charts: view weekly progress → verify data accuracy

**Technical Implementation Notes**:
- JWT: Use `PyJWT` library, store secret in env var
- Rate limiting: Use `slowapi` or `fastapi-limiter` with Redis
- Caching: Use `redis-py` with TTL
- Monitoring: Sentry SDK for FastAPI + Sentry iOS SDK
- Multi-device sync: requires user accounts (JWT auth prerequisite)

**Benefits**:
- Production-ready architecture
- Scalable to 10k+ users
- Secure authentication
- Revenue generation (credits/IAP)
- Better monitoring and debugging

**Related**:
- Prerequisites: Strava (v1.2), User Profiles (v1.3), Offline Persistence (v1.5)

**Estimated Effort**: 3-4 weeks (phased approach)

---

## Summary

- **3 Bugs** (v1.2): days_remaining, Spanish translations, goal/plan inconsistency
- **5 Major Features**:
  - v1.2: Strava Integration (5-7 days)
  - v1.3: User Profiles (3-4 days)
  - v1.4: Coach Personality (4-5 days)
  - v1.5: Offline Persistence (5-7 days)
  - v2.0: Production Hardening (3-4 weeks)

**Next Steps**:
1. Push these templates to GitHub: `cd /Users/charles/coach-ai/athloop-docs && git add .github/ && git commit -m "Add GitHub issue templates" && git push`
2. Create issues manually on GitHub using the templates, or use this file as reference

---

**Created**: 2025-10-21
**Maintained By**: Development Team
