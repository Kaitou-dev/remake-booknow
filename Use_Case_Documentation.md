# Use Case Documentation
# Use Case List

## UC-01: Login System (Customer)

| Field | Description |
|------|------------|
| UC ID and Name | UC-01: Login System (Customer) |
| Created By | GitHub Copilot |
| Date Created | 17/03/2026 |
| Primary Actor | Customer |
| Secondary Actors | Authentication Service, JWT Service, CAPTCHA Validator (if enabled) |
| Brief Description | Customer logs in to access protected features such as booking history, booking details, and profile-related operations. |
| Trigger | Customer submits the customer login form with email and password. |
| Preconditions | 1. Customer has a registered active account.<br>2. Customer login page is available.<br>3. Authentication subsystem is operational. |
| Postconditions | 1. On success, customer is authenticated and redirected to home page.<br>2. Access token cookie is created for subsequent authenticated requests.<br>3. On failure, no session/token is established. |
| Normal Flow | 1. Customer opens login page.<br>2. System displays login form.<br>3. Customer enters email and password, then submits.<br>4. System validates required fields and credential format.<br>5. System authenticates customer credentials.<br>6. System confirms the authenticated principal is a customer account.<br>7. System issues access token in secure HTTP-only cookie.<br>8. System redirects customer to home page. |
| Alternative Flows | A1 - Invalid Credentials<br>1. Customer enters incorrect email or password.<br>2. System rejects authentication.<br>3. System redirects back to login page with error message.<br><br>A2 - Wrong Account Type<br>1. Credentials belong to a staff/admin account.<br>2. Customer login flow denies access for this account type.<br>3. System returns error and keeps customer unauthenticated.<br><br>A3 - CAPTCHA Validation Failure (if enforced)<br>1. CAPTCHA response is missing or invalid.<br>2. System blocks authentication attempt.<br>3. System shows CAPTCHA error and reloads login page. |
| Exceptions | E1 - Authentication Service Unavailable<br>Description: Authentication backend is down or throws runtime error.<br>System behavior:<br>1. System logs technical error details.<br>2. System returns generic login failure message without exposing internals. |
| Priority | High |
| Frequency of Use | High |
| Business Rules | BR1, BR2, BR3<br>BR1: Customer login requires valid credentials.<br>BR2: Only customer principals may complete customer login flow.<br>BR3: Access token cookie must be issued only after successful authentication. |
| Other Information | Include brute-force protection, secure cookie flags, and TLS/HTTPS in production. |

## UC-02: Logout System

| Field | Description |
|------|------------|
| UC ID and Name | UC-02: Logout System |
| Created By | GitHub Copilot |
| Date Created | 17/03/2026 |
| Primary Actor | Customer or Staff/Admin |
| Secondary Actors | JWT Service, Browser Cookie Store |
| Brief Description | Authenticated user logs out by invalidating the access token cookie and returning to login page. |
| Trigger | User clicks Logout action. |
| Preconditions | 1. User is currently authenticated or has a token cookie.<br>2. Logout endpoint is reachable. |
| Postconditions | 1. Access token cookie is removed/expired.<br>2. User is redirected to login page.<br>3. Protected pages require re-authentication. |
| Normal Flow | 1. User selects Logout.<br>2. System receives logout request.<br>3. System clears access token cookie by setting zero max-age.<br>4. System redirects user to login page.<br>5. User is no longer authenticated for protected operations. |
| Alternative Flows | A1 - Logout Without Active Session<br>1. User accesses logout endpoint without valid token.<br>2. System still clears cookie if present.<br>3. System redirects to login page without error.<br><br>A2 - User Opens Protected Page After Logout<br>1. User tries to access secured feature after logout.<br>2. System detects missing/invalid token.<br>3. System redirects user to login page. |
| Exceptions | E1 - Cookie Write Failure<br>Description: Response cannot persist cookie change due to client/network issue.<br>System behavior:<br>1. System still completes redirect response.<br>2. User may appear logged in until browser refresh or token expiry; reattempt logout recommended. |
| Priority | High |
| Frequency of Use | High |
| Business Rules | BR1, BR2<br>BR1: Logout must remove authentication token.<br>BR2: Logout endpoint is accessible even when token is invalid/expired. |
| Other Information | For stronger security, implement token blacklist/rotation in addition to client-side cookie removal. |

## UC-03: View Booking History

| Field | Description |
|------|------------|
| UC ID and Name | UC-03: View Booking History |
| Created By | GitHub Copilot |
| Date Created | 17/03/2026 |
| Primary Actor | Customer |
| Secondary Actors | Booking Service, JWT Service, Data Repository |
| Brief Description | Customer views a list of all bookings associated with their account and can navigate to booking details. |
| Trigger | Customer opens the Booking History page. |
| Preconditions | 1. Customer is authenticated with valid access token.<br>2. Customer account exists in system.<br>3. Booking data service is available. |
| Postconditions | 1. System displays booking list scoped to logged-in customer email.<br>2. If no bookings exist, system displays empty-state guidance.<br>3. No booking data from other users is exposed. |
| Normal Flow | 1. Customer requests Booking History page.<br>2. System reads access token and extracts customer identity.<br>3. System retrieves bookings belonging to that customer.<br>4. System maps booking data for UI presentation.<br>5. System displays booking history table including booking code, dates, amount, and status.<br>6. Customer selects a booking entry to view detail page. |
| Alternative Flows | A1 - Missing or Invalid Token<br>1. Request is made without valid token.<br>2. System cannot resolve customer identity.<br>3. System redirects customer to login page.<br><br>A2 - No Booking Records<br>1. Customer has no historical bookings.<br>2. System returns empty list.<br>3. UI shows No bookings available message and navigation option to search/book rooms.<br><br>A3 - Booking Detail Access from History<br>1. Customer clicks View for one booking item.<br>2. System opens booking detail page for selected booking.<br>3. System shows available actions based on booking status. |
| Exceptions | E1 - Repository/Database Error<br>Description: Booking retrieval fails due to data source or query issue.<br>System behavior:<br>1. System logs error and avoids exposing stack details.<br>2. System returns safe fallback response (error page or user-friendly message). |
| Priority | High |
| Frequency of Use | High |
| Business Rules | BR1, BR2, BR3<br>BR1: Booking history is strictly filtered by authenticated customer identity.<br>BR2: Booking statuses are shown with business-friendly labels.<br>BR3: Users can navigate to detail only for records visible in their own history. |
| Other Information | Pagination/filtering can be added for large booking volume; audit access to booking views for compliance. |

## UC-04: Make Payment

| Field | Description |
|------|------------|
| UC ID and Name | UC-04: Make Payment |
| Created By | GitHub Copilot |
| Date Created | 17/03/2026 |
| Primary Actor | Customer |
| Secondary Actors | MoMo Payment Gateway, Payment Service, Booking Service, Signature Verification Service |
| Brief Description | Customer pays for an eligible booking through MoMo, and the system updates booking/payment records after verified gateway response. |
| Trigger | Customer clicks Pay Now for a booking requiring payment. |
| Preconditions | 1. Booking exists and is eligible for payment (typically awaiting payment).<br>2. Payment amount is valid and greater than zero.<br>3. Payment gateway integration is operational.<br>4. Return/notify endpoints are reachable. |
| Postconditions | 1. On successful payment and valid signature, booking status is updated to Paid.<br>2. Payment transaction record is created with success status.<br>3. Customer is redirected to booking detail with updated information.<br>4. On failure, booking/payment status remains unchanged or marked failed according to result. |
| Normal Flow | 1. Customer opens booking detail for pending-payment booking.<br>2. Customer selects Pay Now.<br>3. System receives booking code and amount.<br>4. System validates amount is positive.<br>5. System creates payment request with gateway.<br>6. System receives gateway pay URL.<br>7. System redirects customer to gateway payment page.<br>8. Customer completes payment on gateway side.<br>9. Gateway redirects back with result parameters and signature.<br>10. System verifies response signature.<br>11. If result code indicates success, system updates booking status to Paid.<br>12. System saves successful payment record.<br>13. System redirects customer to booking detail page. |
| Alternative Flows | A1 - Invalid Amount<br>1. Amount is zero, negative, or malformed.<br>2. System rejects payment creation request.<br>3. System displays validation error on payment page.<br><br>A2 - Gateway Request Creation Failed<br>1. Gateway returns error or missing pay URL.<br>2. System shows Create payment failed message.<br>3. Customer remains on payment page and may retry.<br><br>A3 - Payment Completed but ResultCode Not Success<br>1. Gateway return is valid but indicates failure/cancellation.<br>2. System does not mark booking as paid.<br>3. Customer sees failure result and can retry if business policy allows.<br><br>A4 - Asynchronous Notification Arrives<br>1. Gateway sends notify callback (JSON or form).<br>2. System verifies signature and logs outcome.<br>3. System acknowledges gateway response code accordingly. |
| Exceptions | E1 - Invalid Signature from Gateway<br>Description: Returned callback data signature cannot be verified.<br>System behavior:<br>1. System treats transaction as invalid and does not update booking/payment success.<br>2. System displays invalid transaction message and logs security warning. |
| Priority | High |
| Frequency of Use | High |
| Business Rules | BR1, BR2, BR3, BR4<br>BR1: Payment request amount must be greater than zero.<br>BR2: Booking status may transition to Paid only when signature is valid and result code indicates success.<br>BR3: Payment record must be persisted for successful transaction.<br>BR4: Payment actions are enabled only for payment-eligible booking statuses. |
| Other Information | Use idempotency keys and duplicate callback handling to prevent double-processing. |

## UC-05: Authenticate Staff

| Field | Description |
|------|------------|
| UC ID and Name | UC-05: Authenticate Staff |
| Created By | GitHub Copilot |
| Date Created | 17/03/2026 |
| Primary Actor | Staff/Admin |
| Secondary Actors | Authentication Service, JWT Service, User Type Resolver, CAPTCHA Validator (if enabled) |
| Brief Description | Staff or admin user authenticates through admin login flow to access internal booking and operations screens. |
| Trigger | Staff/admin submits admin login form with credentials. |
| Preconditions | 1. Staff/admin account exists and is active.<br>2. Admin login page is accessible.<br>3. Authentication subsystem is available. |
| Postconditions | 1. On success, staff/admin is authenticated and redirected to staff/admin dashboard area.<br>2. Access token cookie is issued.<br>3. Customer accounts are not allowed through staff authentication path. |
| Normal Flow | 1. Staff/admin opens admin login page.<br>2. System renders staff login form.<br>3. Staff/admin enters email and password.<br>4. System validates input and authenticates credentials.<br>5. System verifies principal belongs to staff/admin domain.<br>6. System issues access token cookie.<br>7. System redirects to admin booking management page. |
| Alternative Flows | A1 - Invalid Credentials<br>1. Staff/admin enters invalid email/password.<br>2. System rejects authentication.<br>3. System redirects back to admin login with error message.<br><br>A2 - Customer Account Attempted on Staff Login<br>1. Credentials correspond to customer account.<br>2. System denies authentication in staff flow.<br>3. System returns login error and no token is issued.<br><br>A3 - CAPTCHA Validation Failure (if enforced)<br>1. CAPTCHA check fails.<br>2. System blocks login process.<br>3. System displays CAPTCHA error. |
| Exceptions | E1 - Authentication Runtime Error<br>Description: Unexpected exception during authentication process.<br>System behavior:<br>1. System logs exception message for troubleshooting.<br>2. System returns generic authentication failure to user. |
| Priority | High |
| Frequency of Use | High |
| Business Rules | BR1, BR2, BR3<br>BR1: Staff login flow accepts only staff/admin identities.<br>BR2: Authentication success results in JWT cookie creation.<br>BR3: Failed authentication never creates or refreshes token. |
| Other Information | Access control should enforce role-based authorization on all admin endpoints after authentication. |

## UC-06: Reset Password

| Field | Description |
|------|------------|
| UC ID and Name | UC-06: Reset Password |
| Created By | GitHub Copilot |
| Date Created | 17/03/2026 |
| Primary Actor | Customer |
| Secondary Actors | OTP Service, Redis Cache, Email Service, Password Encoder, Customer Account Service |
| Brief Description | Customer recovers account access using OTP verification and secure password reset token. |
| Trigger | Customer selects Forgot Password and submits email. |
| Preconditions | 1. Forgot password pages are available.<br>2. Redis and email service are operational.<br>3. Customer can access registered email inbox. |
| Postconditions | 1. On success, password hash is updated for the account.<br>2. Reset token is invalidated after use.<br>3. Customer is redirected to login with success message.<br>4. OTP and attempt counters are cleared appropriately. |
| Normal Flow | 1. Customer opens Forgot Password page.<br>2. Customer enters email and submits request.<br>3. System validates email format.<br>4. System processes request with generic response to avoid account enumeration.<br>5. If account exists, system generates OTP and stores it with expiration.<br>6. System sends OTP to customer email.<br>7. System redirects customer to OTP verification page.<br>8. Customer enters OTP and submits.<br>9. System validates OTP, attempt count, and expiration.<br>10. System generates reset token and redirects to reset password page.<br>11. Customer enters new password and confirm password.<br>12. System validates token, password match, and password strength.<br>13. System encodes new password and updates customer record.<br>14. System invalidates reset token.<br>15. System redirects to login with success confirmation. |
| Alternative Flows | A1 - Invalid Email Format<br>1. Customer submits malformed email.<br>2. System rejects input.<br>3. System shows validation message on forgot-password page.<br><br>A2 - OTP Incorrect<br>1. Customer enters wrong OTP.<br>2. System increments failed attempt counter.<br>3. System shows remaining attempts message.<br><br>A3 - OTP Expired or Missing<br>1. OTP is expired/not found in cache.<br>2. System rejects verification.<br>3. Customer must request new OTP.<br><br>A4 - OTP Resend Cooldown Active<br>1. Customer requests OTP resend too soon.<br>2. System checks cooldown window.<br>3. System returns wait-time message and blocks resend.<br><br>A5 - Reset Token Expired/Invalid<br>1. Customer opens reset link with invalid or expired token.<br>2. System rejects reset operation.<br>3. System returns to forgot-password flow with error message.<br><br>A6 - Password Policy Violation<br>1. New password fails complexity or length rules.<br>2. System rejects password update.<br>3. System keeps user on reset page and displays policy error.<br><br>A7 - Password Confirmation Mismatch<br>1. New password and confirm password differ.<br>2. System blocks reset.<br>3. System displays mismatch error. |
| Exceptions | E1 - Email Delivery Failure<br>Description: OTP cannot be sent due to SMTP/network error.<br>System behavior:<br>1. System logs technical error without exposing details.<br>2. User still receives safe generic response; may retry later.<br><br>E2 - Account Not Found for Valid Token<br>Description: Token maps to email but account record cannot be resolved.<br>System behavior:<br>1. System stops reset process safely.<br>2. System returns account-not-found message and asks user to restart flow. |
| Priority | High |
| Frequency of Use | Medium |
| Business Rules | BR1, BR2, BR3, BR4, BR5<br>BR1: OTP length is 6 digits with limited validity period.<br>BR2: OTP verification has max failed attempts before requiring a new OTP.<br>BR3: OTP resend is controlled by cooldown.<br>BR4: Reset token has separate expiration and must be single-use.<br>BR5: New password must satisfy complexity and minimum length requirements. |
| Other Information | Security controls should include HTTPS, rate limiting, audit logs, and non-disclosure of account existence. |

## UC-07: Cancel Booking

| Field | Description |
|------|------------|
| UC ID and Name | UC-07: Cancel Booking |
| Created By | GitHub Copilot |
| Date Created | 17/03/2026 |
| Primary Actor | Customer |
| Secondary Actors | Booking Service, Booking Repository, Notification/UI Layer |
| Brief Description | Customer cancels an existing booking from booking detail when booking status is cancellation-eligible. |
| Trigger | Customer clicks Cancel Booking in booking detail page and confirms action. |
| Preconditions | 1. Customer is authenticated.<br>2. Booking exists and belongs to the requesting customer.<br>3. Booking status allows cancellation (for example Pending or Pending Payment).<br>4. Booking is not already finalized (paid/checked-in/completed/rejected/failed). |
| Postconditions | 1. Booking status is updated to cancellation outcome status.<br>2. Cancellation note is stored for audit/history.<br>3. Booking detail/history reflects updated status.<br>4. Payment or downstream operational actions for that booking are prevented. |
| Normal Flow | 1. Customer opens booking detail page.<br>2. System determines available actions based on booking status.<br>3. Customer selects Cancel Booking.<br>4. System asks for confirmation.<br>5. Customer confirms cancellation.<br>6. System validates booking identity and cancellation eligibility.<br>7. System updates booking status and sets cancellation note.<br>8. System redirects back to booking detail with updated state. |
| Alternative Flows | A1 - Booking Not Found<br>1. Customer submits cancel for non-existent booking ID.<br>2. System cannot locate booking.<br>3. System redirects to not-found error page.<br><br>A2 - Invalid Booking ID Format<br>1. Booking ID is malformed.<br>2. System rejects request.<br>3. System redirects to not-found error page.<br><br>A3 - Status Not Eligible for Cancel<br>1. Booking is already paid or processed beyond cancel window.<br>2. System blocks cancellation.<br>3. System displays message that booking can no longer be cancelled.<br><br>A4 - Ownership Mismatch<br>1. Authenticated customer attempts to cancel another customer booking.<br>2. System denies operation.<br>3. System redirects to history/detail with authorization error. |
| Exceptions | E1 - Update Transaction Failure<br>Description: Database update fails while setting cancellation status.<br>System behavior:<br>1. System rolls back update transaction.<br>2. System displays generic failure message and keeps original booking state. |
| Priority | High |
| Frequency of Use | Medium |
| Business Rules | BR1, BR2, BR3, BR4<br>BR1: Cancel action is available only in cancellation-eligible statuses.<br>BR2: Booking must belong to currently authenticated customer.<br>BR3: Cancellation must record reason/note for traceability.<br>BR4: Cancelled/failed bookings cannot proceed to payment/check-in. |
| Other Information | Use optimistic locking or status re-check at commit time to prevent race conditions between pay and cancel actions. |
