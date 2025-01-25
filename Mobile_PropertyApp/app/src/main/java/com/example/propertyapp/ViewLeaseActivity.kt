package com.example.propertyapp

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.example.propertyapp.databinding.ActivityViewLeaseBinding
import com.example.propertyapp.models.Property
import com.example.propertyapp.models.PropertyAdapter
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class ViewLeaseActivity : AppCompatActivity() {
    private lateinit var binding: ActivityViewLeaseBinding
    private val db = Firebase.firestore
    private val properties = mutableListOf<Property>()
    private lateinit var adapter: PropertyAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityViewLeaseBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupRecyclerView()
        fetchProperties()
    }

    private fun setupRecyclerView() {
//        adapter = PropertyAdapter(properties, ::editProperty, ::deleteProperty, ::toggleAvailability)
//        binding.rvProperties.adapter = adapter
//        binding.rvProperties.layoutManager = LinearLayoutManager(this)
    }

    private fun fetchProperties() {
        db.collection("properties")
            .get()
            .addOnSuccessListener { documents ->
                if (documents.isEmpty) {
                    Log.d("FirestoreTEST", "No documents found in properties collection.")
                    Toast.makeText(this, "No properties available", Toast.LENGTH_SHORT).show()
                }
                else {
                    Log.d("FirestoreTEST", "Loaded ${documents.size()} properties.")
                    documents.forEach { document ->
                        Log.d("FirestoreTEST", "Document Data: ${document.data}")
                    }
                    properties.clear()
                    properties.addAll(documents.map { it.toObject(Property::class.java).apply { id = it.id } })
                    adapter.notifyDataSetChanged()
                }
            }
            .addOnFailureListener {
                Toast.makeText(this, "Failed to load properties", Toast.LENGTH_SHORT).show()
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

    private fun editProperty(property: Property) {
        val intent = Intent(this, EditLeaseActivity::class.java).apply {
            putExtra("property", property)
        }
        startActivity(intent)
    }

    private fun deleteProperty(property: Property) {
        db.collection("properties").document(property.id).delete()
            .addOnSuccessListener {
                properties.remove(property)
                adapter.notifyDataSetChanged()
                Toast.makeText(this, "Property deleted", Toast.LENGTH_SHORT).show()
            }
            .addOnFailureListener {
                Toast.makeText(this, "Failed to delete property", Toast.LENGTH_SHORT).show()
            }
    }

    private fun toggleAvailability(property: Property) {
        val updatedAvailability = !property.available
        db.collection("properties").document(property.id)
            .update("available", updatedAvailability)
            .addOnSuccessListener {
                property.available = updatedAvailability
                adapter.notifyDataSetChanged()
                val status = if (updatedAvailability) "available" else "unavailable"
                Toast.makeText(this, "Property marked as $status", Toast.LENGTH_SHORT).show()
            }
            .addOnFailureListener {
                Toast.makeText(this, "Failed to update availability", Toast.LENGTH_SHORT).show()
            }
    }
}
