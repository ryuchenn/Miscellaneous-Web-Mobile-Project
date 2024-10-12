# Task Manager API
## Introduction
This project is a simple Task Manager API built using Node.js, Express, and MongoDB with Mongoose. It allows users to create, read, update, and delete tasks. Tasks have attributes like title, description, due date, priority, and completion status.

## Features
- Basic RESTful API demonstration
- Unit testing demonstration
- Modular structure

## Installation

1. Install the libraries:
    ```bash
    npm install dotenv
    npm install express
    npm install jest
    npm install mongoose
    npm install nodemon
    npm install supertest
    ```

3. Set up environment variables:
   - Create a `.env` file in the project root.
   - Add the following environment variables:
     ```
     DB_USER=yourMongoDBUsername
     DB_PASSWORD=yourMongoDBPassword
     DB_NAME=yourMongoDBClusterName
     DB_USE=yourDatabaseName
     DB_DEFAULT_PORT=3005
     ```

4. Make sure MongoDB is running (either locally or via MongoDB Atlas).

## Running the Project

1. Start the Express server:
    ```bash
    cd server
    npm start
    ```

2. The server will run at `http://localhost:3005`. You can use a tool like Postman to interact with the API.

## API Endpoints

### 1. **GET /tasks**

Retrieve all tasks from the database.

- **URL**: `/assignment1/tasks`
- **Method**: `GET`
- **Response**:
    - Status: `200`
    - Body: An array of tasks in JSON format.
```json
[
  {
    "_id": "64f5a88f1c4d882ebd64b8b1",
    "title": "Sample Task",
    "description": "Description for the task",
    "dueDate": "2024-10-03T00:00:00.000Z",
    "priority": "medium",
    "completed": false
  }
]
```

### 2. **GET /tasks/:id**

Retrieve the tasks data by ID from the database.

- **URL**: `/assignment1/tasks`
- **Method**: `GET`
- **Response**:
    - Status: `200`
    - Body: An array of tasks in JSON format.


### 3. **POST /tasks**

Insert the tasks data by into the database.

- **URL**: `/assignment1/tasks`
- **Method**: `POST`
- **Response**:
    - Status: `201`
    - Body: An array of tasks in JSON format.


### 4. **PUT /tasks**

Update the tasks data by to the database.

- **URL**: `/assignment1/tasks`
- **Method**: `PUT`
- **Response**:
    - Status: `200`
    - Body: An array of tasks in JSON format.

### 5. **DELETE /tasks**

Delete the tasks data from the database.

- **URL**: `/assignment1/tasks`
- **Method**: `DELETE`
- **Response**:
    - Status: `200 `