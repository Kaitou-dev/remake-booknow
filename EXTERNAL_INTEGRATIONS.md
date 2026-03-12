# External Integrations

## 1. MoMo Payment Gateway

| Attribute | Detail |
|-----------|--------|
| **Purpose** | Process customer payments for bookings |
| **Environment** | MoMo Sandbox (development/testing) |
| **Protocol** | HTTPS REST API |
| **Security** | HMAC-SHA256 signature verification |

### Integration Flow

```
System                           MoMo Sandbox API
  │                                    │
  │  createPaymentRequest(orderId,     │
  │      amount, info)                 │
  │ ──────────────────────────────────►│
  │                                    │
  │  ◄── Payment URL / QR Code ────── │
  │                                    │
  │  [Customer pays via MoMo app]      │
  │                                    │
  │  ◄── Callback (queryParams) ────── │
  │                                    │
  │  Verify HMAC-SHA256 signature      │
  │  Update Payment → SUCCESS          │
  │  Update Booking → PAID             │
  └────────────────────────────────────┘
```

### Key Methods

| Method | Description |
|--------|-------------|
| `MoMoGatewayService.createPaymentRequest(orderId, amount, info)` | Register transaction with MoMo, receive payment URL |
| `MoMoGatewayService.validateCallbackSignature(params)` | Verify HMAC-SHA256 signature from callback |
| `PaymentController.handleMoMoCallback(queryParams)` | Receive and process MoMo callback |

### Security Notes
- Signature is recalculated server-side using the secret key and compared with MoMo's provided signature.
- Payment window is limited to 15 minutes from booking creation.

---

## 2. Google OAuth2 Authentication

| Attribute | Detail |
|-----------|--------|
| **Purpose** | Allow customers to register/login using their Google account |
| **Protocol** | OAuth 2.0 / OpenID Connect |
| **Data Retrieved** | Email, full name, avatar URL |

### Integration Flow

```
Customer                System                  Google OAuth2
  │                       │                         │
  │  Click "Login with    │                         │
  │  Google"              │                         │
  │ ─────────────────────►│                         │
  │                       │  Redirect to Google ───►│
  │  [Google login flow]  │                         │
  │  ◄─── ID Token ──────────────────────────────── │
  │                       │                         │
  │                       │  verifyGoogleToken()    │
  │                       │ ───────────────────────►│
  │                       │  ◄── User Info ──────── │
  │                       │                         │
  │                       │  Check/Create Customer  │
  │                       │  Generate session       │
  │  ◄── Authenticated ──│                         │
  └───────────────────────┘                         │
```

### Key Methods

| Method | Description |
|--------|-------------|
| `GoogleAuthService.verifyGoogleToken(idToken)` | Validate ID Token integrity, extract user info |
| `CustomOauth2UserService.loadUser(userRequest)` | Process Google identity, coordinate with AuthService |
| `AuthService.processGoogleUser(googleEmail)` | Check/create customer, generate session |

### Behavior
- If email already exists in Customer table → login existing account.
- If email is new → auto-create Customer record (email, name, avatar) with status ACTIVE → login.

---

## 3. Google reCAPTCHA

| Attribute | Detail |
|-----------|--------|
| **Purpose** | Bot protection on customer login form |
| **Protocol** | HTTPS API |
| **Version** | v2 or v3 (implied) |

### Integration Flow

```
Customer (Browser)         System                 Google reCAPTCHA API
  │                          │                          │
  │  Complete reCAPTCHA      │                          │
  │  widget                  │                          │
  │  ──── responseToken ───► │                          │
  │                          │  verifyResponse(token)   │
  │                          │ ────────────────────────►│
  │                          │  ◄── valid/invalid ───── │
  │                          │                          │
  │  ◄── Proceed / Error ── │                          │
  └──────────────────────────┘                          │
```

### Key Methods

| Method | Description |
|--------|-------------|
| `RecaptchaService.verifyResponse(responseToken)` | Call Google API to validate the reCAPTCHA token |

---

## 4. Cloudinary (Media Storage)

| Attribute | Detail |
|-----------|--------|
| **Purpose** | Store and serve check-in video files |
| **Protocol** | HTTPS REST API (Cloudinary SDK) |
| **Content Types** | Video (check-in recordings) |

### Integration Flow

```
Customer                System                  Cloudinary
  │                       │                        │
  │  Upload check-in      │                        │
  │  video (MultipartFile)│                        │
  │ ─────────────────────►│                        │
  │                       │  uploadVideo(file)     │
  │                       │ ──────────────────────►│
  │                       │  ◄── video URL ─────── │
  │                       │                        │
  │                       │  Save URL in           │
  │                       │  CheckInSession record │
  └───────────────────────┘                        │
```

### Key Methods

| Method | Description |
|--------|-------------|
| `Cloudinary.uploadVideo(MultipartFile video)` | Upload video file, return public CDN URL |

---

## 5. WebSocket (Real-time Notifications)

| Attribute | Detail |
|-----------|--------|
| **Purpose** | Push real-time notifications for check-in approval workflow |
| **Protocol** | WebSocket (likely Spring WebSocket / STOMP) |
| **Scope** | Internal — browser to server bidirectional communication |

### Integration Flow

```
Customer Browser         Server (WebSocket)        Admin Browser
  │                          │                          │
  │  Submit check-in video   │                          │
  │ ────────────────────────►│                          │
  │                          │  notifyAdmin(session)    │
  │                          │ ────────────────────────►│
  │                          │                          │  Admin reviews
  │                          │                     approve │
  │                          │ ◄────────────────────────│
  │  notifyUser(bookingId)   │                          │
  │ ◄────────────────────────│                          │
  └──────────────────────────┘                          │
```

### Key Methods

| Method | Description |
|--------|-------------|
| `WebSocket.notifyAdmin(CheckInSession session)` | Push check-in request details to admin dashboard |
| `WebSocket.notifyUser(Long bookingId)` | Notify customer that check-in was approved |

---

## 6. Email Service (Internal)

| Attribute | Detail |
|-----------|--------|
| **Purpose** | Send OTP codes for registration and password reset |
| **Protocol** | SMTP (implied) |
| **Scope** | Internal service component |

### Usage

| Use Case | Trigger | Content |
|----------|---------|---------|
| Customer Registration | Email entered on registration form | OTP code (1-minute validity) |
| Password Reset | Email entered on forgot password form | OTP code (1-minute validity) |
| OTP Resend | Customer requests resend | New OTP code |

---

## Integration Summary Matrix

| Service | Direction | Auth Method | Used In |
|---------|-----------|-------------|---------|
| MoMo Gateway | Outbound + Callback | HMAC-SHA256 | Payment (UC-07) |
| Google OAuth2 | Outbound | OAuth 2.0 ID Token | Login, Registration (UC-01, UC-02) |
| Google reCAPTCHA | Outbound | API Key + Token | Customer Login (UC-01) |
| Cloudinary | Outbound | API Key/Secret | Check-in video upload (UC-09) |
| WebSocket | Internal bidirectional | Session-based | Check-in workflow (UC-09) |
| Email (SMTP) | Outbound | SMTP credentials | Registration, Password Reset (UC-01, UC-02) |
