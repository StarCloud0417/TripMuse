# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.5] - 2025-09-10

### ✨ Added / 新增功能
- **Gemini AI Integration**: Integrated Google Gemini AI for intelligent trip planning using API Key authentication
- **GCP Cloud Run Deployment**: Complete deployment pipeline with Secret Manager integration
- **Environment Configuration**: Secure environment variable management with .env support
- **Health Check Endpoint**: Added `/health` endpoint for service monitoring
- **Structured Trip Response**: Comprehensive JSON response format with coordinates, activities, and cost estimates

### 🔄 Changed / 功能改進
- **Authentication System**: Updated to support development tokens and Firebase authentication
- **API Architecture**: Migrated from Vertex AI to direct Gemini API Key usage for better flexibility
- **Containerization**: Optimized Dockerfile for production deployment
- **Error Handling**: Enhanced error handling and logging throughout the application

### 🛠️ Technical Improvements / 技術改進
- **Security**: Implemented Secret Manager for API key storage
- **Performance**: Optimized container build and runtime performance
- **Monitoring**: Added comprehensive logging with Winston
- **Documentation**: Complete deployment and usage documentation

### 📦 Dependencies / 依賴更新
- Added `@google/generative-ai` for Gemini AI integration
- Updated to latest stable versions of all dependencies
- Removed `@google-cloud/vertexai` in favor of direct API usage

### 🚀 Deployment / 部署
- **GCP Cloud Run**: Fully configured for production deployment
- **Secret Management**: Secure API key handling with GCP Secret Manager
- **Auto-scaling**: Configured for automatic scaling based on demand
- **Health Checks**: Built-in health monitoring and automatic recovery

---

## [0.1.0] - 2025-09-01

### ✨ Added
- Initial TripMuse API implementation
- Basic trip planning functionality
- Express.js server setup
- Firebase authentication integration

---

## Types of changes / 變更類型
- `Added` for new features / 新增功能
- `Changed` for changes in existing functionality / 功能改進
- `Deprecated` for soon-to-be removed features / 即將移除的功能
- `Removed` for now removed features / 已移除功能
- `Fixed` for any bug fixes / 錯誤修復
- `Security` in case of vulnerabilities / 安全更新

---

## Version History / 版本歷史
- **0.1.5**: Production-ready with Gemini AI and GCP deployment
- **0.1.0**: Initial release with basic functionality

---

*For more details, please refer to the commit history and documentation.*
