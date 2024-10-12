//////////// 6. Testing (Unit Test) ////////////
const app = require('../index');
const request = require('supertest');
const mongoose = require('mongoose');
const TaskSchema= require('../model/assigment1_md');

//////////// Init ////////////
beforeAll(async() => {
    await TaskSchema.deleteMany({});
})

afterAll(async() => {
    await TaskSchema.deleteMany({});
})

//////////// Unit Test Start ////////////

describe('Task API', () => {
    // Get
    it('Get all tasks', async () => {
        const res = await request(app).get('/assignment1/tasks');
        expect(res.statusCode).toEqual(200);
        expect(res.body).toBeInstanceOf(Array);
    });

    // Get
    it('Get a task by ID', async () => {
        const task = await TaskSchema.create({
            title: 'Task to fetch',
            description: 'This task is to fetch by ID',
            priority: 'medium',
            completed: false,
        });

        const res = await request(app).get(`/assignment1/tasks/${task._id}`);
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty('_id', task._id.toString());
        expect(res.body).toHaveProperty('title', 'Task to fetch');
    });

    // Insert into 
    it('Create a new task (Correct)', async () => {
        const res = await request(app)
            .post('/assignment1/tasks')
            .send({
                title: 'Test Task',
                description: 'This is a test task',
                priority: 'low',
                completed: false,
            });
        expect(res.statusCode).toEqual(201);
        expect(res.body).toHaveProperty('_id');
        expect(res.body).toHaveProperty('title', 'Test Task');
    });

    // Insert into 
    it('Create a new task (Wrong)', async () => {
        const res = await request(app)
            .post('/assignment1/tasks')
            .send({
                title: "", // Required field
                description: 'This is a test task',
                priority: 'low',
                completed: false,
            });
        expect(res.statusCode).toEqual(400);
    });

    // Update
    it('Update a task', async () => {
        const task = await TaskSchema.create({
            title: 'Task to update',
            description: 'This task will be updated',
            priority: 'low',
            completed: false,
        });

        const res = await request(app)
            .put(`/assignment1/tasks/${task._id}`)
            .send({
                title: 'Updated Task',
                priority: 'high',
                completed: true,
            });
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty('_id', task._id.toString());
        expect(res.body).toHaveProperty('title', 'Updated Task');
        expect(res.body).toHaveProperty('priority', 'high');
        expect(res.body).toHaveProperty('completed', true);
    });

    // Delete
    it('Delete a task', async () => {
        const task = await TaskSchema.create({
            title: 'Task to delete',
            description: 'This task will be deleted',
            priority: 'low',
            completed: false,
        });

        const res = await request(app).delete(`/assignment1/tasks/${task._id}`);
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty('message', 'Task deleted');

        const findRes = await TaskSchema.findById(task._id);
        expect(findRes).toBeNull();
    });
});

//////////// Unit Test End ////////////
