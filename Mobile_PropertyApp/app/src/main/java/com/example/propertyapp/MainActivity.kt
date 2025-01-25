package com.example.propertyapp

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.example.propertyapp.databinding.ActivityMainBinding
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var sharedPreferences: com.example.propertyapp.SharedPreferences
    private val db = Firebase.firestore

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        sharedPreferences = SharedPreferences(this)

        val user = sharedPreferences.getUser()

        if (sharedPreferences.getUser() != null) {
            val i = Intent(this@MainActivity, WelcomeActivity::class.java)
            startActivity(i)
        } else {
            val i = Intent(this@MainActivity, SigninActivity::class.java)
            startActivity(i)
        }

        finish()
    }
}