const express = require('express');
const router = express.Router();
const TaskSchema = require('../model/assigment1_md');

//////////// 3. API Routes && 4. Input Validation && 5. Error Handling ////////////

// Input and Update Validation Function
async function valid(req,res, next){
    const { title, description, dueDate, priority, completed } = req.body;

    if (!title || typeof(title) !== 'string') {
        return res.status(400).json({ error: 'Title is required and must be a string' });
    }

    if (!priority || !['low', 'medium', 'high'].includes(priority)) {
        return res.status(400).json({ error: 'Priority must be either low, medium, or high' });
    }

    if (dueDate && isNaN(Date.parse(dueDate))) {
        return res.status(400).json({ error: 'Invalid due date' });
    }

    if (completed !== undefined && typeof(completed) !== 'boolean') {
        return res.status(400).json({ error: 'Completed must be a boolean' });
    }
    next()
}

// 3-1. GET /tasks - Retrieve all tasks
router.get('/tasks', async (req, res) => {
    try {
        const tasks = await TaskSchema.find();
        res.json(tasks);
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});

// GET /tasks/:id - Retrieve a specific task by ID
router.get('/tasks/:id', async (req, res) => {
    try {
        const task = await TaskSchema.findById(req.params.id);
        if (!task) {
            return res.status(404).json({ error: 'Task not found' });
        }
        res.json(task);
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});

// POST /tasks - Create a new task
router.post('/tasks', valid, async (req, res) => {
    try {
        const task = new TaskSchema(req.body);
        task.save()

        res.status(201).json(task);
    } catch (err) {
        res.status(400).json({ error: 'Invalid task data' });
    }
});

// PUT /tasks/:id - Update an existing task
router.put('/tasks/:id', valid, async (req, res) => {
    try {
        const task = await TaskSchema.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true,
        });
        if (!task) {
            return res.status(404).json({ error: 'Task not found' });
        }
        res.json(task);
    } catch (err) {
        res.status(400).json({ error: 'Invalid task data' });
    }
});

// DELETE /tasks/:id - Delete a task
router.delete('/tasks/:id', async (req, res) => {
    try {
        const task = await TaskSchema.findByIdAndDelete(req.params.id);
        if (!task) {
            return res.status(404).json({ error: 'Task not found' });
        }
        res.json({ message: 'Task deleted' });
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;