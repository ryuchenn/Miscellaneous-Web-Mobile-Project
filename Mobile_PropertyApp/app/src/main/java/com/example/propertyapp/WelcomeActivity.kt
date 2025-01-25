package com.example.propertyapp

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.PopupMenu
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.recyclerview.widget.LinearLayoutManager
import coil.load
import com.example.propertyapp.databinding.ActivityWelcomeBinding
import com.example.propertyapp.models.Property
import com.example.propertyapp.models.PropertyAdapter
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class WelcomeActivity : AppCompatActivity() {
    private lateinit var binding: ActivityWelcomeBinding
    private lateinit var sharedPreferences: com.example.propertyapp.SharedPreferences
    private val db = Firebase.firestore
    private var drawerLayout: DrawerLayout? = null
    private val properties = mutableListOf<Property>()
    private lateinit var adapter: PropertyAdapter
    private var maximumPrice: Double = 0.0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWelcomeBinding.inflate(layoutInflater)
        setContentView(binding.root)
        sharedPreferences = SharedPreferences(this)

        val user = sharedPreferences.getUser()

        drawerLayout = binding.drawerLayout

        binding.openDrawerButton.setOnClickListener {
            drawerLayout!!.openDrawer(GravityCompat.START)
        }

        binding.userButton.load(user?.avatar) {
            crossfade(true)
        }

        binding.navView.setNavigationItemSelectedListener { menuItem ->
            when (menuItem.itemId) {
                R.id.addLease -> {
                    val i = Intent(this@WelcomeActivity, EditLeaseActivity::class.java)
                    startActivity(i)
                    drawerLayout!!.closeDrawer(GravityCompat.START)
                    true
                }
                R.id.watchlist -> {
                    val i = Intent(this@WelcomeActivity, WatchlistActivity::class.java)
                    startActivity(i)
                    drawerLayout!!.closeDrawer(GravityCompat.START)
                    true
                }
                else -> {
                    drawerLayout!!.closeDrawer(GravityCompat.START)
                    false
                }
            }
        }

        binding.userButton.setOnClickListener {
            val popupMenu: PopupMenu = PopupMenu(this, binding.userButton, Gravity.END, 0, R.style.PopupMenu)
            popupMenu.menuInflater.inflate(R.menu.user_menu, popupMenu.menu)
            popupMenu.setOnMenuItemClickListener { item ->
                when (item.itemId) {
                    R.id.signout -> {
                        sharedPreferences.signOut()
                        val i = Intent(this@WelcomeActivity, SigninActivity::class.java)
                        startActivity(i)
                        finish()
                        return@setOnMenuItemClickListener true
                    }
                    else -> {
                        return@setOnMenuItemClickListener false
                    }
                }
            }
            popupMenu.show()
        }

        binding.btnFilter.setOnClickListener {
            maximumPrice = binding.enterMaxPrice.text.toString().toDoubleOrNull() ?: 0.0
            refreshList()
        }

        refreshList()
    }

    override fun onResume() {
        super.onResume()

        refreshList()
    }

    override fun onBackPressed() {
        if (drawerLayout!!.isDrawerOpen(GravityCompat.START)) {
            drawerLayout!!.closeDrawer(GravityCompat.START)
        } else {
            super.onBackPressed()
        }
    }

    private fun refreshList() {
        setupRecyclerView()
        fetchProperties(maximumPrice)
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

    private fun fetchProperties(range: Double) {
        properties.clear()

        db.collection("properties")
            .whereGreaterThan("price", maximumPrice)
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