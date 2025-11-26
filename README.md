
# Event Management System Database

## Project Overview

This project implements a relational database system designed for a corporate event planning company. It transitions data management from spreadsheets to a structured SQL environment, streamlining the tracking of clients, logistics, staffing, and finances.

The database is designed to handle core business operations including client registration, venue booking, task assignment, supplier procurement, and invoicing.

## Database Schema & Entities

The system uses a normalized relational model (MySQL) comprising the following key entities:

-   **Core Entities:**
    
    -   **CLIENT:** Stores contact details and organization information.
        
    -   **EVENT:** Central hub linking clients, venues, budgets, and dates.
        
    -   **VENUE:** Tracks capacity, location, and rental costs.
        
    -   **SUPPLIER:** Directory of vendors (catering, audio, etc.) and service ratings.
        
    -   **STAFF_MEMBER:** Internal employee records and salaries.
        
-   **Operational & Financial Entities:**
    
    -   **TASK:** specific activities with deadlines linked to events.
        
    -   **INVOICE:** Tracks payments (Advance/Final) and financial status.
        
    -   **SERVICE_PACKAGE:** Pre-defined bundles (e.g., Gold, Silver) for streamlined sales.
        
-   **Junction Tables (Many-to-Many Relationships):**
    
    -   **SUPPLIES:** Links Events to Suppliers (includes specific costs).
        
    -   **ASSIGNED:** Links Staff to specific Tasks.
        
    -   **SUBSCRIBES_TO:** Links Events to Service Packages.
        

## Technical Features

### Constraints & Integrity

The database utilizes Primary Keys and Foreign Keys to enforce referential integrity. `ON DELETE CASCADE`is employed on task assignments to ensure data consistency when parent records are removed.

### Automated Business Logic (Triggers)

Two triggers (`EVENT_BEFORE_INSERT`  and  `EVENT_BEFORE_UPDATE`) are implemented to enforce logistical feasibility. They automatically cross-reference the  `Expected_Attendees`  against the  `Venue Capacity`. If the attendees exceed capacity, the system prevents the entry and signals an error.

## Included SQL Scripts

The  `event_management.sql`  file contains:

1.  **DDL Commands:** Scripts to create the schema and all 11 tables.
    
2.  **Triggers:** Stored procedures for capacity validation.
    
3.  **DML Commands:** Sample data insertion for testing (10 records per entity).
    
4.  **Analytical Queries:** Pre-written queries for business reporting.
    

## Key Reports & Queries

The SQL file includes complex queries to answer the following business questions:

1.  **Vendor Logistics:** Identify events with the highest number of assigned vendors.
    
2.  **Venue Utilization:** List all venues currently booked for events.
    
3.  **Supplier Analysis:** Find suppliers serving at least two different events.
    
4.  **Financial Reporting:** Calculate total budget expenditure grouped by Client/Organization.
    
5.  **Staff Management:** Identify staff members currently unassigned to any tasks.
    

## Credits

*Prepared by Team Neuma for the Introduction to Database Management Systems (CS263), University of Sharjah (Submission Date: 10th November, 2025)*.


