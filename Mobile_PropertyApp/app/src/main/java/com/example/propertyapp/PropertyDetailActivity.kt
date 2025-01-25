package com.example.propertyapp

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import coil.load
import com.example.propertyapp.databinding.ActivityPropertyDetailBinding
import com.example.propertyapp.models.Property
import com.example.propertyapp.models.User
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class PropertyDetailActivity : AppCompatActivity() {
    private lateinit var binding: ActivityPropertyDetailBinding
    private lateinit var property: Property
    private lateinit var user: User
    private lateinit var landlord: User

    private val db = Firebase.firestore

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPropertyDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Get user details
        user = SharedPreferences(this).getUser()!!

        // Get Property details from intent
        property = intent.getSerializableExtra("PROPERTY_DETAIL") as Property

        // Populate property details
        binding.cover.load(property?.image) {
            placeholder(R.drawable.property)
            error(R.drawable.property)
            crossfade(true)
        }
        binding.tvPropertyName.setText(property.name)
        binding.tvPropertyAddress.setText(property.address)
        binding.tvPropertyPrice.setText(property.price.toString())
        binding.tvPropertyBedrooms.setText(property.totalBedrooms)

        // Set up listeners
        setupListeners()

        // Update the favorite button
        updateFavoriteStatus()

        // Check if the current user has edit permission
        checkEditPermission()

        // Enable the phone call button if the landlord has a phone number
        hasPhoneNumber()
    }

    private val requestCallPhonePermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()) {
            permissionGranted:Boolean ->

        if (permissionGranted) {
            makePhoneCall()
        } else {
            Dialog(this).error("Permission Required", "Phone call permission is required to make a call. Please enable it in your app settings.")
        }
    }

    private fun makePhoneCall() {
        val phoneNumber:String = "tel:${landlord.phone}"
        val intent:Intent = Intent(Intent.ACTION_CALL)
        intent.setData(Uri.parse(phoneNumber))
        startActivity(intent)
    }

    private fun updateFavoriteStatus() {
        if (user != null) {
            db.collection("favorites")
                .whereEqualTo("userId", user.id)
                .whereEqualTo("propertyId", property.id)
                .limit(1)
                .get()
                .addOnSuccessListener { querySnapshot ->
                    val isFavorite = !querySnapshot.isEmpty
                    if (isFavorite) {
                        binding.btnLike.imageTintList = ContextCompat.getColorStateList(this, R.color.white)
                        binding.btnLike.setBackgroundColor(ContextCompat.getColor(this, R.color.darkBlue))
                    } else {
                        binding.btnLike.imageTintList = ContextCompat.getColorStateList(this, R.color.darkBlue)
                        binding.btnLike.setBackgroundColor(ContextCompat.getColor(this, R.color.white))
                    }
                }
                .addOnFailureListener { exception ->
                    Log.e("Firebase", "Failed to fetch favorite status", exception)
                }
        }
    }

    private fun checkEditPermission() {
        if (user.id == property.userId) {
            binding.btnEdit.isVisible = true
        }
    }

    private fun hasPhoneNumber() {
        if (property.userId.isNotEmpty()) {
            db.collection("users")
                .document(property.userId)
                .get()
                .addOnSuccessListener { document ->
                    document?.toObject(User::class.java)?.let { landlord ->
                        this.landlord = landlord
                        if (landlord.phone.isNotEmpty()) {
                            binding.btnPhoneCall.isEnabled = true
                        }
                    }
                }
                .addOnFailureListener { exception ->
                    Log.e("Firebase", "Failed to fetch the property details", exception)
                }
        }
    }

    private fun setupListeners() {
        binding.btnPhoneCall.setOnClickListener {
            requestCallPhonePermissionLauncher.launch(android.Manifest.permission.CALL_PHONE)
        }

        binding.btnEdit.setOnClickListener {
            val intent = Intent(this, EditLeaseActivity::class.java).apply {
                putExtra("property", property)
            }
            startActivity(intent)
        }

        binding.tvPropertyAddress.setOnClickListener {
            val intent = Intent(this, MapActivity::class.java).apply {
                putExtra("PROPERTY_DETAIL", property)
            }
            startActivity(intent)
        }

        binding.btnLike.setOnClickListener {
            db.collection("favorites")
                .whereEqualTo("userId", user.id)
                .whereEqualTo("propertyId", property.id)
                .limit(1)
                .get()
                .addOnSuccessListener { querySnapshot ->
                    if (!querySnapshot.isEmpty) {
                        val documentId = querySnapshot.documents[0].id
                        db.collection("favorites").document(documentId)
                            .delete()
                            .addOnSuccessListener {
                                Toast.makeText(this, "Favorite removed successfully", Toast.LENGTH_SHORT).show()
                                updateFavoriteStatus()
                            }
                    } else {
                        val data = hashMapOf(
                            "userId" to user.id,
                            "propertyId" to property.id
                        )
                        db.collection("favorites").add(data)
                            .addOnSuccessListener {
                                Toast.makeText(this, "Favorite added successfully", Toast.LENGTH_SHORT).show()
                                updateFavoriteStatus()
                            }
                    }
                }
                .addOnFailureListener { e ->
                    Log.e("Firebase", "Failed to fetch favorite", e)
                }
        }
    }
}