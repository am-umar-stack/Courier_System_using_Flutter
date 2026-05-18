# AMU Courier Database Schema (Prisma & MySQL)

This folder contains the complete relational schema configuration and migrations setup for AMU Courier.

## Prerequisites

1. Install **Node.js** (v16+)

2. Install and run a **MySQL Server** (port 3306)

3. Create a database named `amu_courier_db` inside MySQL

## Setup Instructions

1. Configure your database connection string in the local `.env` file:

   ```env
   DATABASE_URL="mysql://<user>:<password>@localhost:3306/amu_courier_db"
   ```

2. Install the Prisma Client CLI:

   ```bash
   npm install prisma --save-dev
   npm install @prisma/client
   ```

3. Run the initial database migration to generate the tables:

   ```bash
   npx prisma migrate dev --name init
   ```

4. Open the Prisma Studio GUI to interactively view and insert records:

   ```bash
   npx prisma studio
   ```

## Database Models

- **User**: Represents AMU Courier operators (`ADMIN`, `DRIVER`, `CUSTOMER`).

- **Parcel**: Represents shipment packages with values, addresses, status, and secure handover codes.

- **TimelineEvent**: Represents the historical logs of parcel transitions (Pending, In Transit, etc.).
