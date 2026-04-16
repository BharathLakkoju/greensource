<div align="center">

<h1>
  <span style="color:#22c55e">Green</span><span style="color:#3b82f6">Source</span>
</h1>

**A microservices-based agricultural marketplace connecting farmers directly with consumers.**

[![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-20232A?style=flat-square&logo=react&logoColor=61DAFB)](https://reactjs.org/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=flat-square&logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Express](https://img.shields.io/badge/Express-000000?style=flat-square&logo=express&logoColor=white)](https://expressjs.com/)
[![Vite](https://img.shields.io/badge/Vite-646CFF?style=flat-square&logo=vite&logoColor=white)](https://vitejs.dev/)

</div>

---

## Overview

GreenSource is a full-stack agricultural marketplace built on a microservices architecture. It enables farmers to list and sell their produce directly to consumers, cutting out middlemen and improving margins on both sides. The platform includes role-based portals for consumers, farmers, delivery agents, and admins — each with its own dedicated frontend.

Live market commodity price data is pulled from India's government open data API, giving farmers and consumers real-time price intelligence.

---

## Architecture

GreenSource is composed of 7 backend microservices, a central API Gateway, and 3 frontend applications — all communicating through a single entry point.

```
                        ┌─────────────────────────────────────────┐
                        │            API Gateway (:3800)           │
                        │    JWT Auth · Role-Based Routing         │
                        └──────────────┬──────────────────────────┘
                                       │
        ┌──────────────┬───────────────┼───────────────┬──────────────┐
        ▼              ▼               ▼               ▼              ▼
  Auth Service   Farmer Service  Customer Service  Product Service  Orders Service
    (:3804)        (:3805)          (:3806)          (:3807)         (:3808)

                               Delivery Service
                                  (:3809)

  ┌──────────────────┐   ┌───────────────────┐   ┌─────────────────────┐
  │  Consumer/Farmer │   │  Delivery Portal  │   │    Admin Portal     │
  │  Frontend (:3801)│   │     (:3802)       │   │      (:3803)        │
  └──────────────────┘   └───────────────────┘   └─────────────────────┘
```

### Services

| Service              | Port | Responsibility                               |
| -------------------- | ---- | -------------------------------------------- |
| **API Gateway**      | 3800 | Token validation, role-based proxy routing   |
| **Auth Service**     | 3804 | User registration, JWT issuance & validation |
| **Farmer Service**   | 3805 | Farmer profiles, products, earnings          |
| **Customer Service** | 3806 | Consumer profiles, cart, wishlist, addresses |
| **Product Service**  | 3807 | Product catalog, images, reviews             |
| **Orders Service**   | 3808 | Order lifecycle management                   |
| **Delivery Service** | 3809 | Delivery agents, delivery tracking           |

### Frontends

| App                 | Port | Audience                |
| ------------------- | ---- | ----------------------- |
| **Main App**        | 3801 | Consumers & Farmers     |
| **Delivery Portal** | 3802 | Delivery Agents         |
| **Admin Portal**    | 3803 | Platform Administrators |

---

## Features

### For Consumers

- Browse and search the product catalog with category filters
- Add products to cart and wishlist
- Checkout with saved delivery addresses
- Track orders through the full delivery lifecycle (Pending → Confirmed → On the Way → Shipped → Delivered)
- View real-time agricultural commodity market prices (Mandi data)

### For Farmers

- Register and manage a product catalog with image uploads (Cloudinary)
- Accept, confirm, or reject incoming orders
- Delivery automatically assigned upon order confirmation
- Earnings dashboard showing today, weekly, monthly, and all-time revenue
- View live market prices alongside own listed prices

### For Delivery Agents

- View assigned deliveries
- Step-by-step delivery status updates (Picked Up → On the Way → Delivered)
- Order detail view with pickup and drop-off addresses

### For Admins

- Full user management — verify farmers, add/remove admins and delivery agents
- Platform-wide order management with filters by date, status, and order ID
- Analytics dashboard — consumer activity, farmer verification, product stats, revenue and platform commission
- Manage all products with delete capabilities

---

## Tech Stack

**Frontend:** React 18, TypeScript, Vite, Tailwind CSS, Redux Toolkit, React Router, Framer Motion, Recharts, Lucide React

**Backend:** Node.js, Express, TypeScript, Mongoose (MongoDB Atlas)

**Auth:** JWT (jsonwebtoken), bcryptjs, role-based middleware

**File Uploads:** Cloudinary (product images)

**External Data:** [data.gov.in Mandi Prices API](https://data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070) — real-time commodity prices across Indian markets

---

## Getting Started

### Prerequisites

- Node.js 18+
- npm or yarn
- MongoDB Atlas account (or local MongoDB instance)

### Installation

Clone the repository and install all dependencies at once using the provided script:

```powershell
# Windows (PowerShell)
.\install.ps1
```

Or manually install in each service directory:

```bash
cd auth-service && npm install
cd ../Farmer_Service && npm install
cd ../customer-service && npm install
cd ../product-service && npm install
cd ../orders-payments-backend && npm install
cd ../delivery-service && npm install
cd ../apigateway && npm install
cd ../frontend && npm install
cd ../deliveryFrontend && npm install
cd ../adminFrontend && npm install
```

### Environment Variables

Each service reads from a `.env` file. Create one in each backend service directory:

```env
MONGO_URI=your_mongodb_connection_string
PORT=service_port
```

Ports follow the convention in the Architecture table above.

### Running the Platform

Start each service in a separate terminal:

```bash
# Backend services
cd auth-service              && npm run dev   # :3804
cd Farmer_Service            && npm run dev   # :3805
cd customer-service          && npm start     # :3806
cd product-service           && npm start     # :3807
cd orders-payments-backend   && npm start     # :3808
cd delivery-service          && npm start     # :3809
cd apigateway                && npm run dev   # :3800

# Frontend apps
cd frontend                  && npm run dev   # :3801
cd deliveryFrontend          && npm run dev   # :3802
cd adminFrontend             && npm run dev   # :3803
```

### Default Credentials (Dev)

| Role                                   | Default Password                                  |
| -------------------------------------- | ------------------------------------------------- |
| Delivery Agent (auto-created by admin) | `agent@123`                                       |
| Admin                                  | Set via `/api/auth/register` with `role: "admin"` |

---

## Key Flows

**Order lifecycle:**

1. Consumer adds products to cart and checks out with a saved address
2. Order created with `PENDING` status; farmer receives it in their dashboard
3. Farmer accepts → status becomes `CONFIRMED`; a delivery record is auto-created and an available agent is assigned
4. Delivery agent steps the status through `ONTHEWAY` → `SHIPPED` → `DELIVERED`
5. Agent's active order count decrements; farmer earnings update

**Farmer verification:**

- New farmers register and are initially unverified
- Admin reviews and verifies (or rejects) through the Admin Portal
- Only verified farmers can list products

**Platform commission:**

- Admin analytics calculates a 5% platform commission on all delivered orders across the platform

---

## Project Structure

```
greensource/
├── apigateway/                 # Central proxy + JWT middleware
├── auth-service/               # Auth: register, login, validate
├── Farmer_Service/             # Farmer profiles, products, earnings
├── customer-service/           # Customer profiles, cart, orders, wishlist
├── product-service/            # Product catalog, images, reviews
├── orders-payments-backend/    # Order lifecycle
├── delivery-service/           # Delivery agents + delivery tracking
├── frontend/                   # Consumer + Farmer React app (Vite) :3801
├── deliveryFrontend/           # Delivery Agent React app (Vite) :3802
├── adminFrontend/              # Admin React app (Vite) :3803
└── install.ps1                 # Batch npm install script (Windows)
```

---

## Screenshots

_(Add screenshots of the consumer marketplace, farmer dashboard, admin portal, and order tracker here)_

---

## License

This project is for educational and portfolio purposes.

---

<div align="center">
Built with TypeScript · React · Node.js · MongoDB · Hyderabad, India
</div>
