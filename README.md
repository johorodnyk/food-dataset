# Food sales and customers analysis project

This is a project built on PostgreSQL that includes the creation of a data model and analysis of food orders and sales. The goal of this project is to provide insights into the business of food delivery service by analyzing their order and sales data.

![Screenshot](Food%20sales%20and%20customers%20analysis.png)

## Data Model
The data model for this project includes the following tables:

customers: contains information about the customers who have placed orders, including their name, location anf referrals.
orders: contains information about individual orders placed by customers, including the order date, tips, rating.
order_item: contains information about the items included in each order, including the item name, quantity, and price.
product: contains information about the menu items offered by the business delivery service, including the item name, description, cost and price.

## Analysis
The analysis performed on this data model includes the following:

Top-selling items: identify the menu items that are most frequently ordered and generate reports to help optimize menu offerings and promotions.

Sales trends: analyze sales data over time to identify patterns and trends, such as the busiest week of the month.

Customer success: find percentage of returning customers, number of referred customers, sentimental analysis.

## Getting Started
To get started with this project, you will need to have access to a PostgreSQL database and have the necessary permissions to create tables and run queries. You will also need to have the appropriate data to populate the tables, such as customer information, order data, and menu item information.

To run the analysis, you can use a SQL client or IDE to connect to the database and run the queries included in this project. You may also need to modify the queries to fit your specific data model or analysis goals.

## Contributing
Contributions to this project are welcome! If you would like to contribute, please fork this repository, make your changes, and submit a pull request. Be sure to include a detailed description of your changes and any relevant testing or documentation updates.

## License
This project is licensed under the BSD-3 License - see the LICENSE.md file for details.
