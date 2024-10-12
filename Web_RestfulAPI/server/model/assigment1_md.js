//////////// 2. MongoDB and Mongoose ////////////

const mongoose = require('mongoose');

// 2-1. Create schema
/** 
 * Task Manager
 * @param {string} title - Task. This column is required.
 * @param {string} description - Description.
 * @param {date} dueDate - dueDate.
 * @param {string} priority - low or medium or high
 * @param {false} completed - true or false. default is false.
 */
const TaskSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
    },
    description: {
        type: String,
        default: '',
    },
    dueDate: {
        type: Date,
        default: null,
    },
    priority: {
        type: String,
        enum: ['low', 'medium', 'high'],
        default: 'low',
    },
    completed: {
        type: Boolean,
        default: false,
    },
})

//// Create table 
// const CreateTaskModel = () => {
//     return mongoose.models.Assignment1_Tasks || mongoose.model('Assignment1_Tasks', TaskSchema);
// }

module.exports = mongoose.model('Assignment1_Tasks', TaskSchema)