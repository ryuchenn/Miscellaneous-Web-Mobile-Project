package com.example.propertyapp

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.drawerlayout.widget.DrawerLayout
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.propertyapp.databinding.ActivityWatchListBinding
import com.example.propertyapp.models.Property
import com.example.propertyapp.models.PropertyAdapter
import com.example.propertyapp.models.User
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class WatchlistActivity : AppCompatActivity() {
    private lateinit var binding: ActivityWatchListBinding
    private lateinit var sharedPreferences: com.example.propertyapp.SharedPreferences
    private val db = Firebase.firestore
    private var drawerLayout: DrawerLayout? = null
    private val properties = mutableListOf<Property>()
    private lateinit var adapter: PropertyAdapter
    private lateinit var user: User

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWatchListBinding.inflate(layoutInflater)
        setContentView(binding.root)
        sharedPreferences = SharedPreferences(this)

        // Get user details
        user = SharedPreferences(this).getUser()!!

        fetchProperties()
        setupRecyclerView()
    }

    override fun onResume() {
        super.onResume()

        fetchProperties()
        setupRecyclerView()
    }

    private fun setupRecyclerView() {
        adapter = PropertyAdapter(
            properties,
            ::showOnMap,
            ::goDetailActivity,
        )
        binding.rvProperties.adapter = adapter
        binding.rvProperties.layoutManager = LinearLayoutManager(this)
    }

    private fun fetchProperties() {
        properties.clear()

        db.collection("favorites")
            .whereEqualTo("userId", user.id)
            .get()
            .addOnSuccessListener { querySnapshot ->
                val propertyIds = querySnapshot.documents.map { it.getString("propertyId") }.filterNotNull()

                if (propertyIds.isNotEmpty()) {
                    db.collection("properties")
                        .whereIn("id", propertyIds)
                        .whereEqualTo("available", true)
                        .get()
                        .addOnSuccessListener { documents ->
                            if (documents.isEmpty) {
                                Log.d("Firebase", "No documents found in properties collection.")
                                Toast.makeText(this, "No properties available", Toast.LENGTH_SHORT).show()
                            }
                            else {
                                Log.d("Firebase", "Loaded ${documents.size()} properties.")
                                properties.clear()
                                properties.addAll(documents.map { it.toObject(Property::class.java).apply { id = it.id } })
                                adapter.notifyDataSetChanged()
                            }
                        }
                        .addOnFailureListener {
                            Toast.makeText(this, "Failed to load properties", Toast.LENGTH_SHORT).show()
                        }
                }
            }
    }

    private fun updatePropertyInView(updatedProperty: Property) {
        properties.find { it.id == updatedProperty.id }?.apply {
            name = updatedProperty.name
            address = updatedProperty.address
            price = updatedProperty.price
            image = updatedProperty.image
            totalBedrooms = updatedProperty.totalBedrooms
            available = updatedProperty.available
        }
        adapter.notifyDataSetChanged()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (resultCode == RESULT_OK) {
            val updatedProperty = data?.getSerializableExtra("updatedProperty") as? Property
            updatedProperty?.let {
                updatePropertyInView(it)
            }
        }
    }

    private fun showOnMap(property: Property) {
        val intent = Intent(this, MapActivity::class.java).apply {
            putExtra("PROPERTY_DETAIL", property)
        }
        startActivity(intent)
    }

    private fun goDetailActivity(property: Property) {
        val intent = Intent(this, PropertyDetailActivity::class.java).apply {
            putExtra("PROPERTY_DETAIL", property)
        }
        startActivity(intent)
    }
}