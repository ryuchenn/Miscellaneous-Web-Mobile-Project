package com.example.learningapp

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.learningapp.adapters.LessonAdapter
import com.example.learningapp.data.Lessons
import com.example.learningapp.databinding.ActivityLessonListBinding

class LessonList : AppCompatActivity(), ClickDetectorInterface {
    private lateinit var binding: ActivityLessonListBinding
    private lateinit var sharedPreferences: com.example.learningapp.SharedPreferences
    private lateinit var lessonAdapter: LessonAdapter
    private val lessonsList = Lessons().lessonList
    private val totalLessons = lessonsList.size
    private lateinit var completedLessons: BooleanArray

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLessonListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        sharedPreferences = SharedPreferences(this)
        completedLessons = sharedPreferences.getBooleanArray("KEY_COMPLETED_LESSONS") ?: BooleanArray(totalLessons)

        lessonAdapter = LessonAdapter(
            lessonsList,
            this
        )
        lessonAdapter.updateCompletedLessons(completedLessons)
        binding.rv.adapter = lessonAdapter
        binding.rv.layoutManager = LinearLayoutManager(this)
    }

    override fun onResume() {
        super.onResume()

        completedLessons = sharedPreferences.getBooleanArray("KEY_COMPLETED_LESSONS") ?: BooleanArray(totalLessons)
        lessonAdapter.updateCompletedLessons(completedLessons)
    }

    override fun onClick(position: Int) {
        val i = Intent(this@LessonList, LessonDetail::class.java)
        i.putExtra("LESSON_DETAIL", Lessons().lessonList[position])
        startActivity(i)
    }
}