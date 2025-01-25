package com.example.propertyapp

import android.content.Context
import android.util.Log
import com.example.propertyapp.models.User
import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.google.gson.Gson

class SharedPreferences(private val context: Context) {
    private val db = Firebase.firestore
    private val auth = Firebase.auth

    private val sharedPreferences: android.content.SharedPreferences =
        context.applicationContext.getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)

    fun getUser(): User? {
        val json = sharedPreferences.getString("USER_PROFILE", null)
        return if (json != null) {
            val gson = Gson()
            gson.fromJson(json, User::class.java)
        } else {
            null
        }
    }

    fun signIn(email: String = "", password: String = "", onSuccess: (User) -> Unit, onFailure: (Exception) -> Unit) {
        var auth = Firebase.auth

        auth.signInWithEmailAndPassword(email, password)
            .addOnSuccessListener {
                // Retrieve user profile and save it
                db.collection("users")
                    .document(auth.currentUser?.uid.toString())
                    .get()
                    .addOnSuccessListener { documentSnapshot ->
                        val profile = documentSnapshot.toObject(User::class.java)
                        val user = User(
                            id = auth.currentUser?.uid.toString(),
                            name = profile?.name.toString(),
                            avatar = if (profile?.avatar.isNullOrEmpty()) {
                                "https://avatar.iran.liara.run/username?username=${profile?.name.orEmpty()}"    // Set a default image if no specific avatar
                            } else {
                                profile?.avatar.orEmpty()
                            }
                        )

                        val gson = Gson()
                        val json = gson.toJson(user)
                        sharedPreferences.edit().putString("USER_PROFILE", json).apply()

                        onSuccess(user)
                    }
            }
            .addOnFailureListener {
                error ->
                onFailure(error)
                Log.d("User", "signInWithEmail:failure", error)
            }
    }

    fun signOut() {
        auth.signOut()
        sharedPreferences.edit().clear().apply()
    }
}