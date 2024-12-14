package com.example.propertyapp

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.propertyapp.databinding.ActivityBicycleListBinding
import com.example.propertyapp.models.Bicycle
import com.example.propertyapp.models.BicycleAdapter
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class BicycleListActivity : AppCompatActivity() {

    private lateinit var binding: ActivityBicycleListBinding
    private lateinit var adapter: BicycleAdapter
    private var drawerLayout: DrawerLayout? = null
    private val bicycles = mutableListOf<Bicycle>()
    private val db = Firebase.firestore

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityBicycleListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        drawerLayout = binding.drawerLayout
        binding.openDrawerButton.setOnClickListener {
            drawerLayout!!.openDrawer(GravityCompat.START)
        }
        binding.navView.setNavigationItemSelectedListener { menuItem ->
            when (menuItem.itemId) {
                R.id.bicycleMap -> {
                    val i = Intent(this@BicycleListActivity, MainActivity::class.java)
                    startActivity(i)
                    drawerLayout!!.closeDrawer(GravityCompat.START)
                    true
                }
                R.id.bicycleList -> {
                    val i = Intent(this@BicycleListActivity, BicycleListActivity::class.java)
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

        refreshList()
    }

    private fun loadBicycles() {
        db.collection("bicycles").get()
            .addOnSuccessListener { documents ->
                bicycles.clear()
                for (doc in documents) {
                    val bicycle = doc.toObject(Bicycle::class.java)
                    bicycles.add(bicycle)
                }
                adapter.notifyDataSetChanged()
            }
    }

    private fun markAsReturned(bicycle: Bicycle) {
        bicycle.isReturned = true
        db.collection("bicycles").document(bicycle.documentId).set(bicycle)
            .addOnSuccessListener {
                loadBicycles()
            }
    }

    private fun refreshList() {
        setupRecyclerView()
        loadBicycles()
    }

    private fun setupRecyclerView() {
        adapter = BicycleAdapter(bicycles) { bicycle ->
            markAsReturned(bicycle)
        }
        binding.rvBicycle.adapter = adapter
        binding.rvBicycle.layoutManager = LinearLayoutManager(this)
    }
}
