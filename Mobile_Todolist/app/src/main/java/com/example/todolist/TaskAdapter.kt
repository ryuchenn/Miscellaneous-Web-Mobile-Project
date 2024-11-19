package com.example.todolist

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class TaskAdapter(
    private val tasks: List<Task>,
    private val onEdit: (Int) -> Unit,
    private val onDelete: (Int) -> Unit
) : RecyclerView.Adapter<TaskAdapter.TaskViewHolder>() {

    inner class TaskViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val taskName: TextView = itemView.findViewById(R.id.taskNameTextView)
        val priorityIcon: ImageView = itemView.findViewById(R.id.priorityIcon)
        val editIcon: ImageView = itemView.findViewById(R.id.editIcon)
        val deleteIcon: ImageView = itemView.findViewById(R.id.deleteIcon)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TaskViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_task, parent, false)
        return TaskViewHolder(view)
    }

    override fun onBindViewHolder(holder: TaskViewHolder, position: Int) {
        val task = tasks[position]
        holder.taskName.text = task.name
        holder.priorityIcon.setImageResource(
            if (task.isHighPriority) R.drawable.ic_priority else R.drawable.ic_white
        )
        holder.editIcon.setOnClickListener { onEdit(position) }
        holder.deleteIcon.setOnClickListener { onDelete(position) }
    }

    override fun getItemCount(): Int = tasks.size
}
