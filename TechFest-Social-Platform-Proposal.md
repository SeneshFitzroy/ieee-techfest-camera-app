# IEEE TechFest 2025 Social Platform
## Project Proposal

---

## 📋 Executive Summary

A custom-built, event-focused social media platform for IEEE TechFest 2025 that combines AR camera filters with user-generated content sharing. This web-based solution enables attendees to capture branded photos, share experiences, and compete for prizes while collecting valuable participant data for future events.

---

## 🎯 Platform Objectives

### Primary Goals
1. **Brand Amplification** - Enable viral sharing of TechFest-branded content across social media
2. **Data Collection** - Gather participant demographics (universities/companies) for future event planning
3. **Engagement** - Create interactive experience through AR filters and photo competitions
4. **Cost Efficiency** - Hosting and database solutions to be finalized based on scalability requirements

---

## 🛠️ Technical Stack

| Component | Technology |
|-----------|-----------|
| Frontend | Next.js 14 (React) |
| Backend/Database | Firebase (Firestore, Storage, Auth) |
| Hosting | Vercel |
| AR Filters | TensorFlow.js (Face Detection) |

---

## ✨ Core Features

### 1. AR Camera Studio
**Functionality:**
- Real-time face tracking with TechFest branded cap overlay
- Custom frame with IEEE TechFest branding (neon green #c0ff00)
- Multiple color filters available (if applicable): Original, B&W, Vintage, Neon, Cyberpunk, Glitch
- Snapchat-style swipeable filter interface
- Instant photo capture and download

**Brand Integration:**
- TechFest logo on AR cap accessory
- Event frame with tagline: "Powering Tomorrow's Innovation"
- Consistent color scheme matching official branding

### 2. User Authentication & Data Collection

**Registration Fields:**
- **For Students:**
  - Full Name
  - Email Address
  - University Name
  - Degree Program
  
- **For Professionals:**
  - Full Name
  - Email Address
  - Company Name
  - Position/Title

**Privacy Policy:**
- No phone numbers collected
- Terms & Conditions acceptance required
- Data usage consent for future TechVerse events
- GDPR-compliant data handling

### 3. Photo Gallery & Social Feed

**Upload System:**
- Maximum 5 photos per user (load control)
- Direct upload from AR camera or external sources
- Auto-tagging with #TechFestSL hashtag
- Image compression for optimal performance

**Engagement Features:**
- ❤️ Like button (no comments to control moderation)
- 🔗 Share button (copy link, download image)
- 📊 View count tracking
- 🏆 Real-time leaderboard

**Access Control:**
- Public viewing (no login required)
- Login required for: Posting, Liking, Downloading

### 4. Competition System

**Contest Rules:**
- Top 3 photos with highest likes win prizes
- Judging criteria: Creativity + Engagement
- Winners announced on December 20, 2025 at event
- Prize categories:
  1. 🥇 **1st Place:** Grand Prize
  2. 🥈 **2nd Place:** Runner-Up Prize
  3. 🥉 **3rd Place:** Excellence Award

**Leaderboard Display:**
- Live ranking updated in real-time
- Points Table:
  - 1 Like = 1 Point
  - 1 Share = 2 Points
  - Photo Quality Bonus = Up to 10 Points (IEEE judges)

### 5. Account Security & Load Management

**One Account Per User:**
- Email verification required
- Duplicate email prevention
- Account suspension for policy violations

**Load Control Mechanisms:**
- 5 photos maximum per user
- Image size limit: 5MB per photo
- Firebase Storage quota: 5GB (sufficient for 5,000+ photos)
- Firestore read/write optimization

---

## 🎨 Design System

### Color Palette (From Official Branding)
```
Primary Green: #c0ff00
Background Dark: #0a0a0a
Text White: #ffffff
Accent Lines: Neon green grid pattern
```

### UI/UX Principles
- **Single Theme:** Dark mode with neon green accents (no toggle)
- **Language:** English only
- **Mobile-First:** Responsive design for all devices
- **Accessibility:** WCAG 2.1 AA compliant

---



---

## 💰 Cost Analysis

*Note: Specific infrastructure costs are not finalized in this proposal and will be determined based on scalability requirements and platform performance needs.*

### Infrastructure Costs (Monthly)
| Service | Free Tier Limit | Est. Usage |
|---------|----------------|------------|
| Firebase Firestore | 50K reads/day | 30K reads/day |
| Firebase Storage | 5GB, 1GB/day transfer | 3GB, 500MB/day |
| Firebase Auth | Unlimited | 1,000 users |
| Vercel Hosting | 100GB bandwidth | 50GB bandwidth |

### Contingency Plan (If Free Tier Exceeded)
- **Firebase Blaze Plan:** Pay-as-you-go (~$20-50 if exceeded)
- **Cloudflare CDN:** Free tier for image optimization
- **Image Compression:** Auto-resize uploads to 1080x1080px

### Domain & SSL
- **Custom Domain:** techfest.lk or techfest2025.lk (~$15/year)
- **SSL Certificate:** Free via Vercel

**Total Project Budget:** $0-50 (excluding optional domain)

---

## 🎯 User Journey

### For New Visitors (No Login)
1. Land on homepage → See live photo gallery
2. Try AR camera → Capture photo with filters
3. Click "Post Photo" → Redirected to Registration
4. Complete registration → Agree to T&C
5. Upload photo → Photo goes live instantly
6. Share on social media → Track engagement

### For Returning Users
1. Login with email
2. View personal dashboard (5 photo slots)
3. View leaderboard with user-submitted images
4. Like/Share other photos
5. Monitor competition progress

---

## 📋 Terms & Conditions (User Agreement)

### Key Policies
1. **Content Ownership:** Users retain photo rights; IEEE TechFest gets usage rights for promotion
2. **Acceptable Content:** No offensive, harmful, or copyrighted material
3. **Data Usage:** Email/demographic data used only for TechVerse events
4. **Account Limits:** 1 account per email, 5 photos maximum
5. **Competition Rules:** Duplicate accounts disqualified; IEEE judges' decision is final

---

## � Technical Architecture

### Technical Architecture Diagram
```
┌─────────────────┐
│   Next.js App   │ (Vercel Hosting)
│   - AR Camera   │
│   - Gallery     │
│   - Auth Flow   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Firebase     │
│  - Firestore    │ (User Data + Photos Metadata)
│  - Storage      │ (Image Files)
│  - Auth         │ (Email/Password)
└─────────────────┘
```

---

**Document Version:** 1.0  
**Date:** November 15, 2025  
**Status:** Pending Approval  
**Next Review:** November 18, 2025
