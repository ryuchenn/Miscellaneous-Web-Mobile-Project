package com.example.propertyapp

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.example.propertyapp.databinding.ActivitySigninBinding
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class SigninActivity : AppCompatActivity() {
    private lateinit var binding: ActivitySigninBinding
    private lateinit var sharedPreferences: com.example.propertyapp.SharedPreferences
    private val db = Firebase.firestore

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySigninBinding.inflate(layoutInflater)
        setContentView(binding.root)
        sharedPreferences = SharedPreferences(this)

        binding.btnSignIn.setOnClickListener {
            val email = binding.enterUserEmail.text?.trim().toString()
            val password = binding.enterUserPassword.text?.trim().toString()

            val errorMessages = mutableListOf<String>()

            if (email.isEmpty()) {
                errorMessages.add("Email")
            }
            if (password.isEmpty()) {
                errorMessages.add("Password")
            }

            if (errorMessages.isNotEmpty()) {
                val message = "${errorMessages.joinToString(", ")} ${if (errorMessages.count() > 1) "are" else "is"} required."
                Dialog(this).error(null, message)
            } else {
                loginUser(email, password)
            }
        }

        binding.signin.setOnClickListener {
            val i = Intent(this@SigninActivity, SignupActivity::class.java)
            startActivity(i)
        }
    }

    private fun loginUser(email:String = "", password:String = "") {
        sharedPreferences.signIn(
            email,
            password,
            {
                val intent = Intent(this@SigninActivity, MainActivity::class.java)
                startActivity(intent)
                finish()
            },
            { error ->
                Snackbar.make(binding.root, error.message.toString(), Snackbar.LENGTH_LONG).show()
            }
        )
    }
}