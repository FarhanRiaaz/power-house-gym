# 💪 Power House Admin: Gym Operations Management System

## 🌟 Project Overview
**Power House Admin** is a high-performance desktop application built using **Flutter for Windows**.  
It provides a comprehensive, **role-based solution** for managing fitness club operations — focusing on **secure member management**, **biometric attendance**, and **accurate financial reporting**.

---

## ✨ Key Features

- **Biometric Attendance:**  
  Integration with **DigitalPersona 5100** for seamless, fast member check-in and attendance logging.  

- **Role-Based Data Access:**  
  Strict segregation of member data.  
  - Male/Female Admins → Access gender-specific records only.  
  - Super Admin → Full system oversight.  

- **Financial Tracking:**  
  Super Admin module for recording **bills/expenses** and generating **Profit/Loss** and **Expense Ratio** reports.  

- **Dynamic Reporting:**  
  Real-time statistics (Total Sales, Peak Hours, Active Members) with **customizable date range filters**.  

- **Data Utilities:**  
  Super Admin features for **Excel/CSV Import and Export**.  

- **Performance:**  
  Optimized for desktop with **Drift (SQLite)** for local persistence and **data paging** for large member lists.  

- **Cloud Integration:**  
  **Firebase Crashlytics** and **Analytics** for error tracking and usage monitoring.  

---

## 👥 Target Users (Role Definitions)

| **Role** | **Core Responsibilities** | **Data Scope** |
|-----------|----------------------------|----------------|
| **Super Admin** | Financials, Data Utilities, User Management, Global Reporting | Full System Access |
| **Male/Female Admin** | Member Registration, Updates, Fees Collection, Attendance Logging | Gender-Specific Data Only |

---

## 🛠️ Technical Stack

| **Component** | **Technology** | **Purpose** |
|----------------|----------------|--------------|
| **Application** | Flutter Desktop (Windows) | Primary platform and UI framework |
| **Local Database** | Drift (SQLite) | High-performance, reactive local data storage |
| **Biometrics** | DigitalPersona 5100 SDK | Fingerprint scanning via Platform Channels |
| **Cloud Services** | Firebase | Error tracking and usage monitoring |

---

## 🚀 Getting Started
The application is built for **local Windows deployment** and requires **local setup for the DigitalPersona biometric drivers** before use.
