package com.example.learningapp

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.example.learningapp.data.Lessons
import com.example.learningapp.databinding.ActivityWelcomeBackBinding


class  WelcomeBack : AppCompatActivity() {
    private lateinit var binding: ActivityWelcomeBackBinding
    private lateinit var sharedPreferences: com.example.learningapp.SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWelcomeBackBinding.inflate(layoutInflater)
        setContentView(binding.root)

        sharedPreferences = SharedPreferences(this)
        setupProgress()

        binding.btnContinue.setOnClickListener {
            val intent = Intent(this, LessonList::class.java)
            startActivity(intent)
        }

        binding.btnDelete.setOnClickListener {
            sharedPreferences.clear()
            val intent = Intent(this, EnterName::class.java)
            startActivity(intent)
            finish()
        }
    }

    override fun onResume() {
        super.onResume()
        setupProgress()
    }

    private fun setupProgress() {
        val userName = sharedPreferences.getString("KEY_LOGGED_IN_USER")
        val totalLessons = Lessons().lessonList.size
        val completedLessons = sharedPreferences.getBooleanArray("KEY_COMPLETED_LESSONS") ?: BooleanArray(totalLessons)
        val completedCount = completedLessons.count { it }
        val remainingCount = totalLessons - completedCount

        binding.welcomeBack.text = "${userName} \uD83D\uDC4B"
        binding.completeCourse.text = "You've completed $completedCount out of $totalLessons courses!"
        binding.lessonCompleted.text = completedCount.toString()
        binding.lessonRemaining.text = remainingCount.toString()

        binding.progressBar.setProgress(((completedCount.toFloat() / totalLessons.toFloat()) * 100).toInt(), true)
        binding.progressPercent.text = "${((completedCount.toFloat() / totalLessons.toFloat()) * 100).toInt().toString()}%"
    }
}