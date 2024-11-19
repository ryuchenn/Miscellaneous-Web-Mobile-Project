package com.example.todolist


import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Switch
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class MainActivity : AppCompatActivity() {

    private lateinit var taskNameEditText: EditText
    private lateinit var prioritySwitch: Switch
    private lateinit var addTaskButton: Button
    private lateinit var updateTaskButton: Button
    private lateinit var tasksRecyclerView: RecyclerView

    private lateinit var taskAdapter: TaskAdapter
    private val taskList = mutableListOf<Task>()
    private var selectedTask: Int? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        taskNameEditText = findViewById(R.id.taskNameEditText)
        prioritySwitch = findViewById(R.id.prioritySwitch)
        addTaskButton = findViewById(R.id.addTaskButton)
        updateTaskButton = findViewById(R.id.updateTaskButton)
        tasksRecyclerView = findViewById(R.id.tasksRecyclerView)

        taskAdapter = TaskAdapter(taskList, this::onEditClicked, this::onDeleteClicked)
        tasksRecyclerView.adapter = taskAdapter
        tasksRecyclerView.layoutManager = LinearLayoutManager(this)

        addTaskButton.setOnClickListener {
            val taskName = taskNameEditText.text.toString()
            val isHighPriority = prioritySwitch.isChecked

            if (taskName.isNotBlank()) {
                taskList.add(Task(taskName, isHighPriority))
                taskAdapter.notifyDataSetChanged()
                clearForm()
            }
        }

        updateTaskButton.setOnClickListener {
            selectedTask?.let {
                val task = taskList[it]
                task.name = taskNameEditText.text.toString()
                task.isHighPriority = prioritySwitch.isChecked

                taskAdapter.notifyDataSetChanged()
                clearForm()
                toggleButtons(enableAdd = true)
            }
        }
    }

    private fun clearForm() {
        taskNameEditText.text.clear()
        prioritySwitch.isChecked = false
        selectedTask = null
    }

    private fun toggleButtons(enableAdd: Boolean) {
        addTaskButton.isEnabled = enableAdd
        updateTaskButton.isEnabled = !enableAdd

        val addButtonColor = if (enableAdd) R.color.purple_500 else R.color.gray
        val updateButtonColor = if (enableAdd) R.color.gray else R.color.purple_500

        addTaskButton.setBackgroundColor(ContextCompat.getColor(this, addButtonColor))
        updateTaskButton.setBackgroundColor(ContextCompat.getColor(this, updateButtonColor))
    }

    private fun onEditClicked(position: Int) {
        val task = taskList[position]
        taskNameEditText.setText(task.name)
        prioritySwitch.isChecked = task.isHighPriority
        selectedTask = position
        toggleButtons(enableAdd = false)
    }

    private fun onDeleteClicked(position: Int) {
        taskList.removeAt(position)
        taskAdapter.notifyDataSetChanged()
    }
}