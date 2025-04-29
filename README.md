# CuidaPet API
CuidaPet API is a RESTful API built using the Shelf framework, designed to support both mobile and web applications. The API handles functionalities such as user management, pet services, chat, and scheduling, leveraging the MVVM architecture and the GetIt state management library for clean and modular code. The data is persisted in a MySQL database. This project is part of the Flutter Academy, developed for learning purposes and to enhance skills in developing RESTful APIs using Dart and the Shelf framework.

## Features

### User Management

- **Account Creation**: Users can register with their details.
- **Authentication**: Secure login using token-based authentication.
- **User Profile Management**: Users can view and update their profile information.

### Pet Services

- **Service Listings**: Fetch available services offered by pet care providers.
- **Service Details**: View detailed information about a specific service.

### Scheduling

- **Service Booking**: Schedule appointments for selected services.
- **Appointment Management**: View, reschedule, or cancel appointments.

### Chat

- **Real-time Messaging**: Users can chat with pet care providers.
- **Message History**: View past conversations with service providers.

### Administrator Features

- **Manage Services**: Add, update, or delete services offered.
- **View Appointments**: Access all bookings made by users.

## Architecture

The API follows the MVVM architecture, which separates responsibilities into three main layers:

- **Model**: Contains the business logic and data layer, interacting with the MySQL database.
- **ViewModel**: Acts as an intermediary, handling application logic and preparing data for the routes.
- **View**: In the context of the API, this layer is represented by the endpoints/routes exposed to the client applications.

## State Management with GetIt

The API uses GetIt, a dependency injection and service locator library, to efficiently manage state and dependencies throughout the application. This approach ensures that services, controllers, and other components are easily reusable and maintainable.

## Database Integration

CuidaPet API uses MySQL as its database. The database schema is designed to store user data, services, and appointment details in a structured manner. All data access is handled using repository classes to maintain a clean separation of concerns.

### Database Tables
Refer to the `db_model` directory for detailed information about the database schema, including table definitions, relationships, and sample data. The directory contains SQL scripts and documentation to help you understand the database structure and how to interact with it.

- **Users**: Stores user information such as name, email, and password.
- **Services**: Contains information about the pet services offered.
- **Appointments**: Manages user bookings, including dates and service details.
- **Messages**: Stores chat messages between users and service providers.

## Getting Started

### Prerequisites

- Dart SDK: [https://dart.dev/get-dart](https://dart.dev/get-dart)
- MySQL Server: [https://www.mysql.com/downloads/](https://www.mysql.com/downloads/)

### Steps to Run the API

1. **Clone the Repository**:
    ```sh
    gh repo clone StephaneAntonieto/cuidapet_api
    cd cuidapet_api
    ```

2. **Install Dependencies**:
    ```sh
    dart pub get
    ```

3. **Set Up the Database**:
    - Create a MySQL database.
    - Execute the SQL script in `db_model/schema.sql` to create the required tables.

4. **Configure Environment Variables**:
    - Create a `.env` file in the root directory.
    - Add the following variables:
        ```env
        DB_HOST=localhost
        DB_PORT=3306
        DB_USER=root
        DB_PASSWORD=yourpassword
        DB_NAME=cuidapet
        ```

5. **Run the API**:
    ```sh
    dart bin/server.dart
    ```

6. **Access the API**:
    - The API will be available at [http://localhost:8080](http://localhost:8080).
