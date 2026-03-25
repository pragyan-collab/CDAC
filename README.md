# Complete Description for the Flutter Civic Kiosk App

## 📱 App Overview

**Civic Kiosk** is a comprehensive mobile application designed to provide citizens with easy access to various government and civic services through a single, user-friendly platform. The app serves as a digital kiosk that allows users to apply for services, make payments, track applications, and access important information all from their mobile devices.

---

## 🎯 Purpose & Objectives

The Civic Kiosk app aims to:
- **Simplify access** to government services
- **Reduce paperwork** by digitizing application processes
- **Provide transparency** in application tracking
- **Enable quick payments** for bills and fees
- **Offer multi-lingual support** for diverse users
- **Ensure security** through Aadhaar-based authentication

---

## 🏗️ Architecture & Technology Stack

### Frontend Framework
- **Flutter 3.0+** - Cross-platform mobile development
- **Dart** - Programming language

### Backend Integration
- **RESTful APIs** for service catalog and data
- **Offline support** with local caching
- **CircuitDigest Cloud SMS API** for OTP (optional)

### Key Dependencies

```yaml
dependencies:
  # Core
  flutter:
  flutter_localizations:
  
  # UI Components
  webview_flutter: ^4.4.2          # Payment gateway integration
  image_picker: ^1.0.4              # Document upload
  
  # Storage
  shared_preferences: ^2.2.2       # Local preferences
  flutter_secure_storage: ^9.2.2   # Secure token storage
  
  # Network
  http: ^1.6.0                      # API calls
  url_launcher: ^6.2.1              # External links
  
  # Device & Payments
  device_info_plus: ^9.1.1          # Device information
  razorpay_flutter: ^1.4.1          # Payment integration
```

---

## 📂 Project Structure

```
lib/
├── main.dart                        # App entry point
├── screens/                         # All UI screens
│   ├── auth/                        # Authentication screens
│   │   ├── login_screen.dart        # Aadhaar login
│   │   └── otp_screen.dart          # OTP verification
│   ├── user/                        # User area screens
│   │   ├── home_screen.dart         # Dashboard
│   │   ├── services_screen.dart     # Services catalog
│   │   ├── status_screen.dart       # Application status
│   │   ├── payment_screen.dart      # Payment gateway
│   │   └── profile_screen.dart      # User profile
│   └── services/                    # Service-specific screens
│       ├── electricity/             # Electricity services
│       ├── gas/                     # Gas services
│       ├── water/                   # Water services
│       └── municipal/               # Municipal services
├── widgets/                         # Reusable components
│   ├── header_widget.dart           # App header with logo
│   ├── bottom_nav.dart              # Bottom navigation
│   ├── status_card.dart             # Application status card
│   ├── kiosk_busy_overlay.dart      # Loading overlay
│   └── skeleton/                    # Loading skeletons
├── models/                          # Data models
│   ├── application_model.dart       # Application data
│   ├── service_model.dart           # Service catalog
│   └── user_model.dart              # User information
├── services/                        # Business logic
│   ├── auth_service.dart            # Authentication
│   ├── data_service.dart            # Data management
│   ├── service_catalog_service.dart # Service catalog
│   └── payment_service.dart         # Payment processing
├── utils/                           # Utilities
│   ├── constants.dart               # App constants
│   ├── routes.dart                  # Navigation routes
│   └── helpers.dart                 # Helper functions
└── assets/                          # Static assets
    ├── images/                      # App images
    │   ├── App.png                  # App icon/logo
    │   ├── emblem.png               # Government emblem
    │   └── icons/                   # Service icons
    └── fonts/                       # Custom fonts
        ├── Poppins-Regular.ttf
        ├── Poppins-Bold.ttf
        └── Poppins-Medium.ttf
```

---

## 🔐 Authentication Flow

1. **Aadhaar Entry**
   - User enters 12-digit Aadhaar number
   - Validation checks for format and existence

2. **OTP Verification** (Bypassed for demo)
   - OTP generated for demo purposes
   - Any OTP works for testing
   - No actual SMS sent (saves quota)

3. **Session Management**
   - User session created with unique session key
   - Login timestamp recorded
   - Audit log maintained

---

## 📱 Core Features

### 1. **Service Catalog**
- **Electricity Services**
  - Bill payment
  - Duplicate bill download
  - New connection application
  - Name transfer request
  - Meter replacement
  - Load enhancement
  - Solar net metering
  - Complaint registration

- **Gas Services**
  - Cylinder booking
  - Subsidy status check
  - New connection application
  - Bill payment
  - Complaint registration
  - Booking status tracking

- **Water Services**
  - Bill payment
  - Consumer lookup

- **Municipal Services**
  - Property tax payment
  - Professional tax payment
  - Trade license application
  - Building plan approval
  - Grievance registration
  - Birth certificate application
  - Death certificate application
  - Marriage registration

### 2. **Application Status Tracking**
- View all applications in one place
- Filter by: All, Pending, Approved, Rejected
- Detailed view with status and reference numbers
- Payment pending actions

### 3. **Payment Integration**
- Multiple payment methods (UPI, Card, Net Banking)
- Payment history with transaction IDs
- Digital receipt generation
- Secure payment gateway integration

### 4. **Document Management**
- QR code document upload
- Pen drive document upload
- Camera capture for documents
- File validation (size, type, format)

### 5. **User Features**
- Multi-language support (upcoming)
- Notifications
- Profile management
- Session timeout and logout

---

## 🎨 UI/UX Design

### Color Scheme
```dart
primaryBlue: Color(0xFF1E88E5)      // Main brand color
secondaryBlue: Color(0xFF64B5F6)    // Accent color
textDark: Color(0xFF333333)          // Primary text
textMedium: Color(0xFF666666)        // Secondary text
white: Color(0xFFFFFFFF)             // Background
pageBg: Color(0xFFF5F5F5)            // Page background
```

### Typography
- **Font Family:** Poppins
- **Regular:** Body text, labels
- **Medium:** Subheadings, important text
- **Bold:** Headings, titles

### Components
- **HeaderWidget:** App header with emblem and logo
- **BottomNavWidget:** 5-tab navigation (Home, Services, Status, Notifications, Profile)
- **StatusCardWidget:** Application status display
- **KioskBusyOverlay:** Loading indicators
- **Skeleton Loaders:** Loading placeholders

---

## 🔄 Data Flow

```
User Action → Service Call → Data Service → API/Storage
     ↓
UI Update ← State Management ← Response
```

### Offline Support
- Service catalog cached locally
- Application status stored in local database
- Offline-first approach with sync when online

---

## 🔒 Security Features

1. **Aadhaar-based authentication**
2. **Session management** with inactivity timeout
3. **Secure storage** for sensitive data
4. **Input sanitization** for all user inputs
5. **File validation** for uploads
6. **Audit logs** for all critical actions

---

## 📊 Database Schema

### Consumer Table
- Aadhaar number (primary)
- Name, mobile, email
- Address
- Last login timestamp
- Active status

### Application Tables (per service)
- Application number
- Status (pending/approved/rejected)
- Submitted date
- Amount (if applicable)
- User reference

### Audit Logs
- User action
- Timestamp
- IP address
- Device information
- Changes made

---

## 🚀 Deployment

### Build Commands
```bash
# Debug build
flutter run

# Release build (Android)
flutter build apk --release

# Release build (iOS)
flutter build ios --release
```

### Environment Setup
1. **Clone repository**
2. **Install Flutter SDK 3.0+**
3. **Run `flutter pub get`**
4. **Add assets to `assets/images/`**
5. **Configure API keys in settings**
6. **Build and run**

---

## 📱 Device Requirements

### Minimum Requirements
- **Android:** 5.0 (API 21) or higher
- **iOS:** 11.0 or higher
- **RAM:** 2GB minimum
- **Storage:** 100MB free space

### Recommended
- **Android:** 8.0+ with 4GB RAM
- **iOS:** 13.0+ with 3GB RAM
- **Internet:** 4G/WiFi connection

---

## 🧪 Testing

### Types of Testing
1. **Unit Tests** - Business logic
2. **Widget Tests** - UI components
3. **Integration Tests** - Full flows
4. **Device Testing** - Multiple screen sizes

### Test Coverage
- Authentication flow
- Service applications
- Payment processing
- Status tracking
- Document uploads

---

## 📈 Future Enhancements

1. **Biometric Authentication**
   - Fingerprint login
   - Face recognition

2. **Advanced Features**
   - Push notifications
   - Chat support
   - Video consultation
   - Digital signature

3. **More Services**
   - Vehicle registration
   - Passport services
   - Pension schemes
   - Scholarship applications

4. **AI Integration**
   - Chatbot for queries
   - Document OCR
   - Smart form filling

5. **Analytics**
   - Usage tracking
   - Service popularity
   - User behavior insights

---

## 📞 Support & Maintenance

### Contact Information
- **Developer:** [Your Name]
- **Email:** support@civickiosk.com
- **Documentation:** [Link to docs]
- **Issue Tracker:** [GitHub issues]

### Maintenance Schedule
- Weekly: Security updates
- Monthly: Feature releases
- Quarterly: Performance optimization
- Yearly: Major version updates

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Government of India for Aadhaar API documentation
- CircuitDigest for SMS service
- All contributors and testers

---

**Last Updated:** March 2026
**Version:** 1.0.0
**Status:** Production Ready
