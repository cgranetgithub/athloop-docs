# Strava Integration - Implementation Plan

**Status**: 📋 Planned - Not yet implemented
**Priority**: 🔥 High - Critical feature for multi-platform support
**Complexity**: ⭐⭐⭐ Medium

## 🎯 Objective

Integrate Strava to provide an alternative to HealthKit for activity data, enabling:
- Multi-platform support (iOS, Android, Web in future)
- Better data quality from dedicated sports devices (Garmin, Wahoo, etc.)
- Privacy-first approach (no storage of activity data)

## 🏗️ Architecture Decision

**CHOSEN APPROACH: On-Demand Fetching (No Storage)**

### Why No Storage?
✅ **Privacy-First**: Consistent with "🔒 Your data is not stored" message
✅ **Always Fresh**: No sync issues, always up-to-date
✅ **Simpler**: Less DB complexity, no migration needed
✅ **RGPD Compliant**: Minimal data retention
✅ **Viable**: Strava API limits are generous (100/15min, 1000/day)

### Data Flow
```
┌─────────┐          ┌─────────┐          ┌─────────┐
│   iOS   │─────────▶│ Backend │─────────▶│ Strava  │
│  App    │◀─────────│   API   │◀─────────│   API   │
└─────────┘          └─────────┘          └─────────┘
     │                     │
     │                     │
     ▼                     ▼
Display Only        Summarize for AI
(no storage)        (plan generation)
```

## 📋 Implementation Checklist

### Phase 1: Strava API Setup
- [ ] Create Strava Application at https://www.strava.com/settings/api
  - Application Name: Athloop
  - Website: https://athloop.com (or current URL)
  - Authorization Callback Domain: web-production-a0a77.up.railway.app
- [ ] Get CLIENT_ID and CLIENT_SECRET
- [ ] Add to backend .env:
  ```bash
  STRAVA_CLIENT_ID=your_client_id
  STRAVA_CLIENT_SECRET=your_client_secret
  ```
- [ ] Add to Railway environment variables

### Phase 2: Backend - Database Migration
- [ ] Create migration to add Strava fields to User model:
  ```python
  # Only tokens, NO activity storage
  strava_athlete_id = Column(String, nullable=True)
  strava_access_token = Column(String, nullable=True)
  strava_refresh_token = Column(String, nullable=True)
  strava_token_expires_at = Column(DateTime(timezone=True), nullable=True)
  strava_connected = Column(Boolean, default=False)
  ```
- [ ] Run migration: `alembic revision --autogenerate -m "add strava integration"`
- [ ] Apply: `alembic upgrade head`

### Phase 3: Backend - Strava Service
- [ ] Create `app/strava_service.py` with:
  - [ ] `StravaService` class
  - [ ] `get_authorization_url()` - Generate OAuth URL
  - [ ] `exchange_code_for_token()` - Exchange auth code for tokens
  - [ ] `refresh_access_token()` - Refresh expired tokens
  - [ ] `get_valid_token()` - Get valid token (auto-refresh)
  - [ ] `get_activities()` - Fetch activities from Strava API
  - [ ] `get_activities_summary()` - Format activities for AI prompt
- [ ] Add error handling for Strava API failures
- [ ] Add logging for OAuth flow debugging

### Phase 4: Backend - API Endpoints
- [ ] Add to `app/api.py`:
  - [ ] `GET /api/strava/auth-url` - Get OAuth authorization URL
  - [ ] `GET /api/strava/callback` - Handle OAuth callback
  - [ ] `GET /api/strava/activities` - Proxy endpoint for frontend (no storage)
  - [ ] `DELETE /api/strava/disconnect` - Disconnect Strava
- [ ] Modify `POST /api/generate-plan`:
  - [ ] Check if user has Strava connected
  - [ ] If yes, fetch activities on-demand for AI prompt
  - [ ] Use activity_summary from Strava instead of HealthKit
- [ ] Add response schemas in `app/schemas.py`:
  ```python
  class StravaAuthResponse(BaseModel):
      auth_url: str

  class StravaActivityResponse(BaseModel):
      id: int
      name: str
      type: str
      distance: float
      moving_time: int
      start_date: datetime
      average_heartrate: Optional[float]

  class StravaActivitiesListResponse(BaseModel):
      activities: List[StravaActivityResponse]
      connected: bool
      count: int
  ```

### Phase 5: Backend - CRUD Operations
- [ ] Add to `app/crud.py`:
  - [ ] `update_user_strava_credentials()` - Store OAuth tokens
  - [ ] `clear_user_strava_credentials()` - Remove tokens on disconnect
  - [ ] `get_user_by_strava_athlete_id()` - Optional: find user by Strava ID

### Phase 6: Backend - Testing
- [ ] Unit tests for StravaService:
  - [ ] Test token refresh logic
  - [ ] Test activity parsing
  - [ ] Mock Strava API responses
- [ ] Integration tests:
  - [ ] Test OAuth flow
  - [ ] Test plan generation with Strava data
  - [ ] Test disconnect flow
- [ ] Add to `test_api.py`:
  - [ ] Test Strava endpoints
  - [ ] Test error handling (expired tokens, API failures)

### Phase 7: iOS - Models
- [ ] Create `StravaActivity.swift` model:
  ```swift
  struct StravaActivity: Codable, Identifiable {
      let id: Int
      let name: String
      let type: String
      let distance: Double
      let movingTime: Int
      let startDate: Date
      let averageHeartrate: Double?
      let maxHeartrate: Double?
      let averageSpeed: Double?

      // Computed properties
      var distanceKm: Double { distance / 1000 }
      var durationFormatted: String { /* format movingTime */ }
  }

  struct StravaActivitiesResponse: Codable {
      let activities: [StravaActivity]
      let connected: Bool
      let count: Int
  }
  ```

### Phase 8: iOS - Backend API Service
- [ ] Add to `BackendAPIService.swift`:
  - [ ] `getStravaAuthURL() async throws -> StravaAuthResponse`
  - [ ] `getStravaActivities() async throws -> StravaActivitiesResponse`
  - [ ] `disconnectStrava() async throws`
  - [ ] `@Published var isStravaConnected: Bool = false`

### Phase 9: iOS - Strava Connection View
- [ ] Create `StravaConnectionView.swift`:
  - [ ] Strava branding (logo, colors)
  - [ ] "Connect Strava" button
  - [ ] OAuth flow via ASWebAuthenticationSession
  - [ ] Handle deep link callback: `athloop://strava-connected`
  - [ ] Success/error states
  - [ ] Disconnect button
- [ ] Add Strava logo assets to Assets.xcassets
- [ ] Add deep link URL scheme in Xcode project:
  - [ ] URL Types → Add `athloop`

### Phase 10: iOS - Data Source Picker
- [ ] Modify `HealthDataView.swift`:
  - [ ] Add segmented control: HealthKit | Strava
  - [ ] Show HealthKit workouts OR Strava activities (not both)
  - [ ] Add "Connect Strava" card if not connected
  - [ ] Fetch Strava activities on-demand when tab selected
  - [ ] Loading states
  - [ ] Error handling

### Phase 11: iOS - Activity Data Adapter
- [ ] Create `ActivityDataService.swift` enhancements:
  - [ ] Add `generateActivitySummaryFromStrava(activities: [StravaActivity]) -> String`
  - [ ] Unify summary format with HealthKit version
  - [ ] Handle empty/no data cases
- [ ] Modify plan generation to use Strava data if connected

### Phase 12: iOS - Settings Integration
- [ ] Add Data Sources section in Settings/Profile view:
  - [ ] Show connected sources (HealthKit ✓, Strava ✓)
  - [ ] Allow disconnect
  - [ ] Show sync status
  - [ ] Privacy notice

### Phase 13: Localization
- [ ] Add localization keys to all `.lproj/Localizable.strings`:
  ```
  // Strava Integration
  "strava.connect" = "Connect Strava";
  "strava.disconnect" = "Disconnect";
  "strava.connecting" = "Connecting...";
  "strava.connected" = "Connected to Strava";
  "strava.description" = "Import your activities from Strava for more accurate training recommendations";
  "strava.activities" = "Strava Activities";
  "strava.error.auth" = "Failed to connect to Strava. Please try again.";
  "strava.error.fetch" = "Failed to fetch activities from Strava.";
  "datasource.healthkit" = "HealthKit";
  "datasource.strava" = "Strava";
  ```
- [ ] Add French translations
- [ ] Add Spanish translations

### Phase 14: UI/UX Polish
- [ ] Add Strava brand colors to DesignSystem
- [ ] Activity type icons matching Strava types:
  - Run, Ride, Swim, Workout, Yoga, etc.
- [ ] Empty states for no activities
- [ ] Pull-to-refresh on activities list
- [ ] Activity detail view (optional)

### Phase 15: Testing & QA
- [ ] Manual testing:
  - [ ] OAuth flow end-to-end
  - [ ] Token refresh after expiration
  - [ ] Activity display
  - [ ] Plan generation with Strava data
  - [ ] Disconnect and reconnect
  - [ ] Switch between HealthKit and Strava
- [ ] Edge cases:
  - [ ] User with no Strava activities
  - [ ] Invalid/expired tokens
  - [ ] Network errors
  - [ ] Rate limiting
- [ ] Privacy verification:
  - [ ] Confirm no activities stored in DB
  - [ ] Check token security
  - [ ] Verify data deletion on disconnect

### Phase 16: Documentation
- [ ] Update CLAUDE.md with Strava integration
- [ ] Add API documentation for Strava endpoints
- [ ] Add user-facing help/FAQ about Strava
- [ ] Update privacy policy (if needed)

### Phase 17: Deployment
- [ ] Backend deployment:
  - [ ] Add STRAVA_CLIENT_ID and STRAVA_CLIENT_SECRET to Railway
  - [ ] Deploy migration
  - [ ] Monitor logs
- [ ] iOS deployment:
  - [ ] Update version number
  - [ ] TestFlight beta testing
  - [ ] Collect feedback
  - [ ] App Store submission

## 🔑 Strava API Details

### OAuth 2.0 Flow
```
1. User taps "Connect Strava"
2. App gets auth URL from backend: GET /api/strava/auth-url
3. App opens Safari/ASWebAuthenticationSession with auth URL
4. User authorizes on Strava
5. Strava redirects to: https://.../api/strava/callback?code=XXX&state=YYY
6. Backend exchanges code for tokens
7. Backend stores tokens in User model
8. Backend redirects to: athloop://strava-connected
9. App shows success message
```

### Token Management
- **Access Token**: Valid for 6 hours
- **Refresh Token**: Long-lived, used to get new access tokens
- **Auto-refresh**: Backend checks expiration and refreshes automatically

### API Endpoints Used
- `GET /oauth/authorize` - Authorization page
- `POST /oauth/token` - Token exchange/refresh
- `GET /athlete/activities` - List activities
- Rate Limits: 100 req/15min, 1000 req/day

### Scopes Needed
```
activity:read_all    # Read all activities (public + private)
profile:read_all     # Read profile data
```

## 💾 Data Model (Minimal Storage)

### User Table (Modified)
```sql
ALTER TABLE users ADD COLUMN strava_athlete_id VARCHAR;
ALTER TABLE users ADD COLUMN strava_access_token VARCHAR;
ALTER TABLE users ADD COLUMN strava_refresh_token VARCHAR;
ALTER TABLE users ADD COLUMN strava_token_expires_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE users ADD COLUMN strava_connected BOOLEAN DEFAULT FALSE;
```

### NO Activity Storage
❌ We do NOT store activities in the database
✅ Activities fetched on-demand from Strava API

## 🎨 UI Components

### StravaConnectionCard
```
┌────────────────────────────────────┐
│  [Strava Logo]                     │
│                                    │
│  Connect Strava                    │
│  Import your activities for better │
│  training recommendations          │
│                                    │
│  [Connect Strava Button]           │
└────────────────────────────────────┘
```

### Activity List Item
```
┌────────────────────────────────────┐
│ 🏃 Morning Run              12.5km │
│ Oct 17, 2025 • 1h 15min           │
│ ❤️ 142 bpm avg                     │
└────────────────────────────────────┘
```

### Data Source Picker
```
┌────────────────────────────────────┐
│ [HealthKit] [Strava]  ← Segmented  │
│                                    │
│ [Activity List Based on Selection] │
└────────────────────────────────────┘
```

## 🔒 Security Considerations

### Token Storage
- ✅ Tokens stored encrypted in DB (consider encryption at rest)
- ✅ Tokens never exposed to frontend
- ✅ Backend acts as proxy
- ✅ Automatic token refresh prevents exposure of refresh flow to frontend

### Privacy
- ✅ Activities NOT stored in DB
- ✅ Activities fetched on-demand only
- ✅ Clear disconnect flow removes all tokens
- ✅ User controls what data is shared

### Rate Limiting
- ✅ Backend caches activity summary during plan generation
- ✅ Frontend implements reasonable refresh intervals
- ✅ Error handling for rate limit exceeded

## 📊 Success Metrics

### Technical
- [ ] OAuth success rate > 95%
- [ ] Token refresh success rate > 99%
- [ ] API response time < 2s for activity fetch
- [ ] Zero activity data stored in DB

### User Experience
- [ ] Onboarding completion rate with Strava
- [ ] % of users connecting Strava vs HealthKit
- [ ] Plan generation success rate with Strava data
- [ ] User satisfaction with activity data accuracy

## 🚧 Known Limitations

### Strava API
- Rate limits: 100/15min, 1000/day (acceptable for our use case)
- Historical data: Limited to activities in user's account
- Privacy zones: Strava may hide location data in privacy zones

### Architecture
- Requires internet connection to fetch activities
- Slightly slower than local HealthKit data
- Dependent on Strava API uptime

### Mitigation
- Cache last fetch for offline viewing (optional future enhancement)
- Fallback to HealthKit if Strava unavailable
- Clear error messaging

## 🔄 Future Enhancements (v2)

### Short-term Cache
- Cache activities for 15-30 minutes to reduce API calls
- Implement in-memory cache in backend
- Add cache invalidation on manual refresh

### Webhook Integration
- Subscribe to Strava webhooks for real-time activity updates
- Automatically trigger plan updates on new activity
- Requires webhook endpoint setup

### Advanced Analytics
- Heart rate zones analysis
- Power data (cycling)
- Elevation profiles
- Training load calculation

### Multi-Source Support
- Combine HealthKit + Strava data
- Support other platforms (Garmin Connect, Polar Flow)
- Unified activity feed

## 📝 Notes

### Why Strava?
- Most popular training platform for serious athletes
- Better data quality than native HealthKit (from dedicated devices)
- Cross-platform (works on Android, web)
- Active developer community

### Alternative Approaches Considered
1. ❌ **Store all activities**: Privacy concerns, DB bloat, sync complexity
2. ❌ **HealthKit only**: iOS-only limitation
3. ✅ **On-demand fetch**: Best balance of privacy, simplicity, freshness

### Dependencies
- Backend: `requests` (already installed)
- iOS: `AuthenticationServices` framework (built-in)
- No additional external dependencies needed

## 🎯 Priority Justification

**Why High Priority:**
1. **Multi-platform Strategy**: Opens door to Android/Web
2. **User Demand**: Many athletes use dedicated devices → sync to Strava
3. **Competitive Advantage**: Most fitness apps support Strava
4. **Data Quality**: Better than HealthKit for serious athletes
5. **Privacy Win**: Strengthens "we don't store your data" message

**Estimated Effort:**
- Backend: 2-3 days
- iOS: 2-3 days
- Testing: 1 day
- **Total: ~1 week**

---

**Created**: 2025-10-17
**Last Updated**: 2025-10-17
**Status**: Ready for implementation
