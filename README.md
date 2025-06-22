# JobMarketPulse (JMP) - Mobile & Web Application

## Overview

JobMarketPulse is a cross-platform Flutter application that provides entry-level job seekers with AI-powered career insights, personalized skill analysis, and comprehensive job market visualizations. The app serves as the user-friendly frontend interface for the JMP system, connecting to the AI-powered backend for intelligent career guidance.

## Problem Statement

Recent graduates and entry-level job seekers often struggle to understand current job market trends, required skills, and how to position themselves effectively. JobMarketPulse addresses this challenge by providing an intuitive mobile and web interface that delivers personalized career insights and market analysis through AI-powered recommendations.

## System Architecture

JobMarketPulse operates as the frontend component of the complete JMP ecosystem:

```
JMP Ecosystem:
├── JMP_APP (This Repository)     # Flutter frontend application
│   ├── Mobile App (Android)      # Native Android application
│   ├── Web App                   # Progressive web application
│   └── Shared Components         # Cross-platform UI components
└── JMP_FYP                       # Python backend with AI services
    ├── Job Data Scraping         # Market data collection
    ├── AI Model Training         # Career advisor fine-tuning
    └── API Services              # RESTful endpoints for app
```

## Key Features

### 1. AI-Powered Career Report Generation
- **Personalized Analysis**: Generate comprehensive career reports based on individual skills and interests
- **Skill Gap Identification**: AI-driven analysis of missing competencies and development recommendations
- **Career Path Suggestions**: Tailored recommendations for suitable career trajectories
- **Market Alignment**: Insights aligned with current job market demands

### 2. Interactive Market Visualizations
- **Skill Trends Dashboard**: Dynamic charts showing emerging and declining skill demands
- **Programming Skills Analysis**: Detailed breakdown of required technical competencies
- **Job Type Distribution**: Visual representation of available entry-level positions
- **Skill Category Insights**: Categorized analysis of different skill domains
- **Top Skills Rankings**: Current market demand for specific skills

### 3. Historical Report Management
- **Report History**: Access to previously generated career reports
- **Progress Tracking**: Monitor skill development and career progression over time
- **Comparative Analysis**: Compare different reports to track growth
- **Export Capabilities**: Save and share career insights

### 4. Cross-Platform Experience
- **Responsive Design**: Optimized interface for both mobile and web platforms
- **Consistent UX**: Unified experience across Android and web browsers
- **Offline Capabilities**: Core features available without constant internet connection
- **Modern UI**: Material Design principles with custom JMP theming

## Technology Stack

### Frontend Framework
- **Flutter 3.2+**: Cross-platform UI framework
- **Dart**: Programming language for Flutter development
- **Material Design**: UI/UX design system

### State Management & Architecture
- **Provider**: State management solution
- **MVC Pattern**: Model-View-Controller architecture
- **Repository Pattern**: Data access abstraction

### Data Visualization
- **FL Chart**: Interactive charting library
- **Custom Visualizations**: Static chart assets for market insights
- **Responsive Charts**: Adaptive layouts for different screen sizes

### Backend Integration
- **HTTP Client**: RESTful API communication
- **JSON Serialization**: Data format handling
- **Error Handling**: Robust network error management

### UI/UX Components
- **Google Fonts**: Typography system
- **Custom Theme**: JMP-specific design system
- **Animations**: Smooth transitions and micro-interactions
- **Responsive Layout**: Adaptive design for multiple screen sizes

## Installation and Setup

### Prerequisites
- **Flutter SDK**: 3.2.3 or higher
- **Dart SDK**: Compatible with Flutter version
- **Android Studio** (for Android development)
- **VS Code** (recommended for development)
- **Chrome** (for web development)

### Environment Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd JMP_APP/jmp
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - **Important**: This repository does not include Firebase configuration files for security reasons
   - Follow the detailed setup guide: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   - Copy template files and configure with your Firebase project:
     - `jmp/android/app/google-services.json.template` → `jmp/android/app/google-services.json`
     - `jmp/lib/firebase_options.dart.template` → `jmp/lib/firebase_options.dart`

4. **Set up backend connection**
   - Update API endpoint in `lib/common/api_service.dart`
   - Ensure JMP_FYP backend is running on specified port

### Platform-Specific Setup

#### Android Development
```bash
# Check Android setup
flutter doctor

# Run on Android device/emulator
flutter run
```

#### Web Development
```bash
# Enable web support
flutter config --enable-web

# Run web application
flutter run -d chrome
```

## Usage Guide

### 1. Career Report Generation

1. **Navigate to Report Generation**
   - Access the report generation feature from the main menu
   - Fill in educational background and experience details

2. **Select Skills and Interests**
   - Choose from categorized skill options:
     - Programming Languages (Python, JavaScript, Java, etc.)
     - Frameworks & Libraries (React, Angular, Django, etc.)
     - Databases (MySQL, MongoDB, PostgreSQL, etc.)
     - Cloud & DevOps (AWS, Azure, Docker, etc.)
     - Soft Skills (Communication, Leadership, etc.)
     - Data & Analytics (Machine Learning, Statistics, etc.)

3. **Generate AI-Powered Report**
   - Submit form to receive personalized career analysis
   - View comprehensive insights including:
     - Career opportunities based on skills
     - Skill gap analysis and recommendations
     - Market demand for selected skills
     - Suggested career paths
     - Professional development recommendations

### 2. Market Visualization Dashboard

1. **Access Dashboard**
   - View comprehensive market insights through interactive charts
   - Explore different visualization categories

2. **Available Visualizations**
   - **Skill Trends**: Emerging and declining skill demands
   - **Top Programming Skills**: Most in-demand technical skills
   - **Skill Categories**: Breakdown by skill domains
   - **Job Types**: Distribution of entry-level positions
   - **Skill Combinations**: Popular skill pairings in job market

### 3. Historical Reports

1. **View Report History**
   - Access previously generated career reports
   - Track progress over time

2. **Compare Reports**
   - Analyze changes in career recommendations
   - Monitor skill development progress

## API Integration

### Backend Connection
The app connects to the JMP_FYP backend through RESTful APIs:

```dart
// Example API call for report generation
final response = await http.post(
  Uri.parse('$baseUrl/analyze'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'skills': 'python, javascript, react, sql',
    'areas': 'web development, data science',
  }),
);
```

### Data Flow
1. **User Input**: Skills and interests collected from UI
2. **API Request**: Data sent to JMP_FYP backend
3. **AI Processing**: Llama model generates personalized analysis
4. **Response**: Structured career advice returned to app
5. **Display**: Formatted insights presented to user

## Project Structure

```
lib/
├── main.dart                    # Application entry point
├── app_state/                   # Global state management
├── common/                      # Shared utilities and components
│   ├── api_service.dart        # Backend API integration
│   ├── jmp_theme.dart          # Custom theme definitions
│   ├── jmp_widgets.dart        # Reusable UI components
│   ├── jmp_util.dart           # Utility functions
│   └── jmp_animations.dart     # Animation definitions
├── models/                      # Data models
│   ├── report.dart             # Report data structure
│   └── skill_visualization.dart # Visualization data models
├── services/                    # Business logic services
│   └── report_service.dart     # Report management logic
├── report_generate/            # Career report generation
├── historical_reports/         # Report history management
├── home_screen/                # Main dashboard
├── home_page/                  # Home page components
├── welcome/                    # Welcome screen
├── splash/                     # Splash screen
├── join_page/                  # User onboarding
├── login_with_email/           # Email authentication
├── signup_with_email/          # User registration
└── forgot_password/            # Password recovery
```

## Development Workflow

### Adding New Features

1. **UI Components**: Extend `jmp_widgets.dart` for reusable components
2. **API Integration**: Update `api_service.dart` for new backend endpoints
3. **Data Models**: Add new models in `models/` directory
4. **Business Logic**: Implement services in `services/` directory
5. **Screens**: Create new screens following existing patterns

### Testing

The JMP app includes a comprehensive testing suite with unit tests, widget tests, and integration tests. For detailed testing information, see [TESTING_GUIDE.md](jmp/TESTING_GUIDE.md).

#### Quick Start

```bash
# Navigate to the Flutter app directory
cd jmp

# Install dependencies
flutter pub get

# Generate mock classes
flutter packages pub run build_runner build

# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

#### Using Test Runner Scripts

**Linux/macOS:**
```bash
# Make script executable (first time only)
chmod +x run_tests.sh

# Run all tests
./run_tests.sh all

# Run unit tests only
./run_tests.sh unit

# Run tests with coverage and HTML report
./run_tests.sh coverage --coverage-html

# Run tests on specific platform
./run_tests.sh widget --platform=android
```

**Windows:**
```cmd
# Run all tests
run_tests.bat all

# Run unit tests only
run_tests.bat unit

# Run tests with coverage
run_tests.bat coverage --coverage-html

# Run tests on specific platform
run_tests.bat widget --platform=web
```

#### Test Types

1. **Unit Tests** (`test/unit/`)
   - Test business logic, API services, and data models
   - Example: `flutter test test/unit/api_service_test.dart`

2. **Widget Tests** (`test/widget/`)
   - Test UI components and user interactions
   - Example: `flutter test test/widget/report_generation_test.dart`

3. **Integration Tests** (`test/integration/`)
   - Test complete app flows and user journeys
   - Example: `flutter test test/integration/app_flow_test.dart`

#### Test Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage in browser (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

#### Testing Best Practices

- Write tests for all critical functionality
- Use descriptive test names
- Mock external dependencies (HTTP, Firebase)
- Test edge cases and error conditions
- Maintain good test coverage (>80% recommended)
- Run tests before committing code

## Academic Context

### Research Contributions
- **User Experience Design**: Intuitive interface for AI-powered career guidance
- **Cross-Platform Development**: Unified experience across mobile and web
- **Data Visualization**: Effective presentation of complex market insights
- **Accessibility**: Inclusive design for diverse user groups

### Technical Innovations
- **Responsive Architecture**: Adaptive design for multiple platforms
- **Real-time Data Integration**: Seamless connection with AI backend
- **Interactive Visualizations**: Engaging presentation of market data
- **Personalized User Experience**: Tailored interface based on user needs

## Platform Support

### Android
- **Minimum SDK**: API level 21 (Android 5.0)
- **Target SDK**: API level 33 (Android 13)
- **Features**: Full native Android experience with Material Design

### Web
- **Browser Support**: Chrome, Firefox, Safari, Edge
- **Progressive Web App**: Installable web application
- **Responsive Design**: Optimized for desktop and tablet screens

## Troubleshooting

### Common Issues

1. **API Connection Errors**
   - Verify JMP_FYP backend is running
   - Check API endpoint configuration
   - Ensure network connectivity

2. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter and Dart SDK versions
   - Verify platform-specific configurations

3. **Performance Issues**
   - Optimize image assets
   - Implement lazy loading for visualizations
   - Use efficient state management

### Debug Mode
```bash
# Enable debug mode
flutter run --debug

# View debug information
flutter logs
```

## Security and Configuration

### Important Security Notes

This repository is configured for public access with the following security measures:

1. **Firebase Configuration Excluded**: All Firebase configuration files containing API keys and sensitive data are excluded from the repository
2. **Template Files Provided**: Use `.template` files as starting points for your configuration
3. **Environment Variables**: Sensitive data should be stored in environment variables or secure configuration files
4. **Setup Guide**: Follow [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for secure configuration

### Required Configuration Files

Before running the application, you must create these files from their templates:

- `jmp/android/app/google-services.json` (from `google-services.json.template`)
- `jmp/lib/firebase_options.dart` (from `firebase_options.dart.template`)

### Development vs Production

- Use separate Firebase projects for development and production
- Never commit actual API keys or sensitive configuration to version control
- Implement proper Firebase Security Rules for production deployment

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow Flutter coding standards
4. Add appropriate tests
5. **Never commit sensitive configuration files**
6. Submit a pull request with detailed description

## License

This project is developed as part of academic research. Please refer to the proposal document for detailed project information.

## Contact

For questions or support:
- **Academic**: 
- **Technical**: 
- **Project Repository**: 

---

**Note**: This application is currently in development. For production deployment, additional security measures, error handling, and performance optimizations should be implemented.
