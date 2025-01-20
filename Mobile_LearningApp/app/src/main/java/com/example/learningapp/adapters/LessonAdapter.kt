package com.example.learningapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.example.learningapp.ClickDetectorInterface
import com.example.learningapp.R
import com.example.learningapp.databinding.LessonRowLayoutBinding
import com.example.learningapp.models.Lesson

class LessonAdapter (private val myItems:MutableList<Lesson>, private val clickInterface: ClickDetectorInterface) : RecyclerView.Adapter<LessonAdapter.ViewHolder>() {
    private lateinit var completedLessons: BooleanArray

    inner class ViewHolder(val binding: LessonRowLayoutBinding) : RecyclerView.ViewHolder (binding.root) {
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = LessonRowLayoutBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return myItems.size
    }

    fun updateCompletedLessons(newCompletedLessons: BooleanArray) {
        completedLessons = newCompletedLessons
        notifyDataSetChanged()
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val lesson: Lesson = this.myItems[position]
        if (completedLessons[position]) {
            holder.binding.isCompleted.setImageResource(R.drawable.complete)
        } else {
            holder.binding.isCompleted.setImageResource(R.drawable.play)
        }
        holder.binding.name.text = lesson.name
        holder.binding.length.text = "Length: ${"%.2f".format(lesson.length / 60)} mins"
        holder.binding.number.text = (position + 1).toString()
        holder.binding.lesson.setOnClickListener {
            clickInterface.onClick(position)
        }
    }
}