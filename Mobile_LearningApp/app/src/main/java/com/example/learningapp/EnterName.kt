package com.example.learningapp

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.example.learningapp.data.Lessons
import com.example.learningapp.databinding.ActivityEnterNameBinding

class  EnterName : AppCompatActivity() {
    private lateinit var binding: ActivityEnterNameBinding
    private lateinit var sharedPreferences: com.example.learningapp.SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityEnterNameBinding.inflate(layoutInflater)
        setContentView(binding.root)

        sharedPreferences = SharedPreferences(this)

        binding.btnContinue.setOnClickListener {
            val userName = binding.enterUserName.text.toString().trim()

            if (userName.isEmpty()) {
                Toast.makeText(this, "Please enter your name", Toast.LENGTH_SHORT).show()
            } else {
                sharedPreferences.saveString("KEY_LOGGED_IN_USER", userName)
                sharedPreferences.saveBooleanArray("KEY_COMPLETED_LESSONS", BooleanArray(Lessons().lessonList.size))

                val intent = Intent(this, WelcomeBack::class.java)
                startActivity(intent)
                finish()
            }
        }
    }
}