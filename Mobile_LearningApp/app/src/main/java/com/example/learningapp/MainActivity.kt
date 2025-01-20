package com.example.learningapp

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.example.learningapp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val sharedPreferences = getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)
        val userName = sharedPreferences.getString("KEY_LOGGED_IN_USER", null)

        Log.i("userName", userName.toString());

        if (userName != null) {
            val i = Intent(this@MainActivity, WelcomeBack::class.java)
            startActivity(i)
        } else {
            val i = Intent(this@MainActivity, EnterName::class.java)
            startActivity(i)
        }

        finish()
    }
}
