package com.example.propertyapp

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.example.propertyapp.databinding.ActivitySignupBinding
import com.example.propertyapp.models.User
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class SignupActivity : AppCompatActivity() {
    private lateinit var binding: ActivitySignupBinding
    private lateinit var sharedPreferences: com.example.propertyapp.SharedPreferences
    private lateinit var auth: FirebaseAuth
    private val db = Firebase.firestore

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySignupBinding.inflate(layoutInflater)
        setContentView(binding.root)
        sharedPreferences = SharedPreferences(this)

        auth = Firebase.auth

        binding.btnSignUp.setOnClickListener {
            val name = binding.enterUserName.text?.trim().toString()
            val email = binding.enterUserEmail.text?.trim().toString()
            val password = binding.enterUserPassword.text?.trim().toString()
            val avatar = binding.enterUserAvatar.text?.trim().toString()
            val phone = binding.enterUserPhone.text?.trim().toString()

            val errorMessages = mutableListOf<String>()

            if (name.isEmpty()) {
                errorMessages.add("Name")
            }
            if (email.isEmpty()) {
                errorMessages.add("Email")
            }
            if (password.isEmpty()) {
                errorMessages.add("Password")
            }
            if (phone.isEmpty()) {
                errorMessages.add("Phone")
            }

            if (errorMessages.isNotEmpty()) {
                val message = "${errorMessages.joinToString(", ")} ${if (errorMessages.count() > 1) "are" else "is"} required."
                Dialog(this).error(null, message)
            } else {
                signup(email, password, name, phone, avatar)
            }
        }

        binding.signin.setOnClickListener {
            finish()
        }
    }

    private fun signup(email:String = "", password:String = "", name:String = "", phone:String = "", avatar:String = "") {
        auth.createUserWithEmailAndPassword(email, password)
            .addOnSuccessListener {
                val data = User(name = name, phone = phone, avatar = avatar)

                db.collection("users")
                    .document(auth.currentUser!!.uid)
                    .set(data)
                    .addOnSuccessListener {
                        Dialog(this).ok(
                            null,
                            "Your account has been successfully created!",
                            {
                                finish()
                            }
                        )
                    }
                    .addOnFailureListener { error ->
                        Snackbar.make(binding.root, error.message.toString(), Snackbar.LENGTH_LONG).show()
                        Log.d("User", "signUpWithEmail:failure", error)
                    }
            }
            .addOnFailureListener { error ->
                Snackbar.make(binding.root, error.message.toString(), Snackbar.LENGTH_LONG).show()
                Log.d("User", "signUpWithEmail:failure", error)
            }
    }
}