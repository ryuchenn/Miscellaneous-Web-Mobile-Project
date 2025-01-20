package com.example.learningapp

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import coil.load
import com.example.learningapp.data.Lessons
import com.example.learningapp.databinding.ActivityLessonDetailBinding
import com.example.learningapp.models.Lesson

class  LessonDetail : AppCompatActivity() {
    private lateinit var binding: ActivityLessonDetailBinding
    private lateinit var sharedPreferences: com.example.learningapp.SharedPreferences
    private lateinit var completedLessons: BooleanArray
    private val lessonsList = Lessons().lessonList
    private val totalLessons = lessonsList.size
    private var isCompleted: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLessonDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val lesson: Lesson = intent.getSerializableExtra("LESSON_DETAIL") as Lesson

        sharedPreferences = SharedPreferences(this)

        completedLessons = sharedPreferences.getBooleanArray("KEY_COMPLETED_LESSONS") ?: BooleanArray(totalLessons)

        isCompleted = completedLessons[lesson.number - 1]
        if (isCompleted) {
            binding.complete.setBackgroundColor(ContextCompat.getColor(this, R.color.darkBlue))
            binding.complete.text = "Completed"
        }

        binding.cover.load(lesson.cover) {
            crossfade(true)  // Enable smooth image transition
        }

        binding.name.text = "${lesson.number}. ${lesson.name}"
        binding.length.text = "Length: ${"%.2f".format(lesson.length / 60)} mins"
        binding.description.text = lesson.description

        binding.watch.setOnClickListener {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(lesson.link))
            startActivity(intent)
        }

        binding.complete.setOnClickListener {
            // Update the completed lessons
            completedLessons[lesson.number - 1] = true
            sharedPreferences.saveBooleanArray("KEY_COMPLETED_LESSONS", completedLessons)

            finish()
        }
    }

}