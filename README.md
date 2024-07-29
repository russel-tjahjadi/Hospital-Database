
# 🏥 Hospital Database System

## Overview

Built a robust hospital database system using SQL, featuring efficient relational mapping and CRUD operations. Developed database relations, populated datasets, and optimized functionality with queries, views, and triggers. The process of creating the database involved relational mapping and the creation of an ER diagram.

## 📚 Table of Contents

- [⭐ Features](#features)
- [⚙️ Installation](#installation)
- [🚀 Usage](#usage)
- [📊 Database Schema](#database-schema)
- [🤝 Contributing](#contributing)
- [📜 License](#license)

## ⭐ Features

### VIEWS AND DESCRIPTIONS
- **Unpaid invoices:** Helps in finding out which patients have not paid their invoices.
- **Available rooms:** Lists all the rooms with at least 1 available bed at the moment.
- **Pending orders:** Provides concise information on the orders that have not been fully completed.

### TRIGGERS AND DESCRIPTIONS
- **Create payable for each room booking:** Makes it convenient for calculating the cost of rooms.
- **Monitor expensive procedures:** Ensures that physicians who order procedures costing more than $1000 monitor the patient for at least 2 hours, per hospital policy.
- **Unassign monitoring physician upon paid invoice:** Automatically frees up all physicians monitoring a patient once the patient has paid their invoice.

### QUERIES, RESULTS AND DESCRIPTIONS
- **People covered by insurance:** Finds the names and invoice amounts of patients billed at least $300 but didn't book rooms on the VIP 4th floor.
- **Most common administered medicine:** Identifies the most common medications given to improve logistics efficiency.
- **Unused rooms in April 2023:** Lists out the room numbers that were not used by any patient in April 2023.

(AND many more features listed in the pdf...)

## ⚙️ Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/hospital-database-system.git
   cd hospital-database-system
   ```

2. **Set up the database:**
   - Ensure you have a running SQL server instance.
   - Create a new database for the project.
   - Run the provided SQL scripts to create tables and populate initial data.

3. **Configuration:**
   - Update the database connection string in the configuration file.

## 🚀 Usage

1. **Running Queries:**
   - Use the provided SQL scripts to perform various CRUD operations.
   - Utilize views to fetch data in a structured format.
   - Execute triggers for automated data management.

2. **Database Management:**
   - Add, update, and delete records as needed.
   - Optimize and maintain database performance using the provided queries and views.

## 📊 Database Schema

(Include a diagram or description of your database schema here.)

## 🤝 Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Create a new Pull Request.

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
