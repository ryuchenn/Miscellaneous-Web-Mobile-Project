package com.example.propertyapp

import android.content.Intent
import android.location.Geocoder
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import com.example.propertyapp.databinding.ActivityMainBinding
import com.example.propertyapp.models.Bicycle
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Marker
import com.google.android.gms.maps.model.MarkerOptions
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import java.util.Locale

class MainActivity : AppCompatActivity(), OnMapReadyCallback {

    private lateinit var binding: ActivityMainBinding
    private lateinit var googleMap: GoogleMap
    private val db = Firebase.firestore
    private var drawerLayout: DrawerLayout? = null
    private val bicycleList = mutableListOf<Marker>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.btnReportBicycle.setOnClickListener {
            reportBicycle()
        }

        drawerLayout = binding.drawerLayout
        binding.openDrawerButton.setOnClickListener {
            drawerLayout!!.openDrawer(GravityCompat.START)
        }

        binding.navView.setNavigationItemSelectedListener { menuItem ->
            when (menuItem.itemId) {
                R.id.bicycleMap -> {
                    val i = Intent(this@MainActivity, MainActivity::class.java)
                    startActivity(i)
                    drawerLayout!!.closeDrawer(GravityCompat.START)
                    true
                }
                R.id.bicycleList -> {
                    val i = Intent(this@MainActivity, BicycleListActivity::class.java)
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

        binding.btnFilter.setOnClickListener {
            val bikeName = binding.enterBicycleName.text.toString()
            if (bikeName.isNotBlank()) {
                searchBicycleByName(bikeName)
            } else {
                loadBicycles()
            }
        }

        // Map
        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
    }

    private fun reportBicycle() {
        val lat = generateTorontoLat()
        val lng = generateTorontoLng()
        val address = getAddressFromCoordinates(lat, lng)

        val bicycle = Bicycle().apply {
            val randomNumber = (1..999).random()
            name = "BIKE-${randomNumber}"
            this.lat = lat
            this.lng = lng
            this.address = address
            isReturned = false
            updateTime = System.currentTimeMillis()
        }

        db.collection("bicycles").add(bicycle)
            .addOnSuccessListener {
                Toast.makeText(this, "Success!", Toast.LENGTH_SHORT).show()
                loadBicycles()
            }
            .addOnFailureListener {
                Toast.makeText(this, "Failed to report bicycle.", Toast.LENGTH_SHORT).show()
            }
    }

    private fun generateTorontoLat(): Double {
        val min = 43.58
        val max = 43.85
        return min + (max - min) * Math.random()
    }

    private fun generateTorontoLng(): Double {
        val min = -79.64
        val max = -79.12
        return min + (max - min) * Math.random()
    }

    private fun getAddressFromCoordinates(lat: Double, lng: Double): String {
        val geocoder = Geocoder(this, Locale.getDefault())
        return try {
            val addresses = geocoder.getFromLocation(lat, lng, 1)
            addresses?.get(0)?.getAddressLine(0) ?: "You got a wrong address"
        } catch (e: Exception) {
            "Error address"
        }
    }

    override fun onMapReady(map: GoogleMap) {
        googleMap = map
        googleMap.uiSettings.isZoomControlsEnabled = true

        val torontoLatLng = LatLng(43.65107, -79.347015)
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(torontoLatLng, 12f))

        loadBicycles()
    }

    private fun loadBicycles() {
//        googleMap.clear()

        db.collection("bicycles").whereEqualTo("returned", false)
            .get()
            .addOnSuccessListener { documents ->

                if (documents.isEmpty){
                    Toast.makeText(this, "NO ANY BICYCLES", Toast.LENGTH_SHORT).show()
                }
                else{
                    googleMap.clear()
                    for (doc in documents) {
                        val bicycle = doc.toObject(Bicycle::class.java)
                        val position = LatLng(bicycle.lat, bicycle.lng)

                        val mapInfo = googleMap.addMarker(
                            MarkerOptions().position(position).title(bicycle.name).snippet(bicycle.address))

                        if (mapInfo != null)
                        {
                            bicycleList.add(mapInfo)
                        }
                    }
                }

            }
    }

    private fun searchBicycleByName(name: String) {
        db.collection("bicycles").whereEqualTo("name", name).get()
            .addOnSuccessListener { documents ->
                googleMap.clear()
                bicycleList.clear()

                if (documents.isEmpty) {
                    Toast.makeText(this, "No bicycle found with name: $name", Toast.LENGTH_SHORT).show()
                } else {
                    for (doc in documents) {
                        val bicycle = doc.toObject(Bicycle::class.java)
                        val position = LatLng(bicycle.lat, bicycle.lng)
                        val marker = googleMap.addMarker(
                            MarkerOptions().position(position).title(bicycle.name).snippet(bicycle.address)
                        )
                        if (marker != null) {
                            bicycleList.add(marker)
                        }
                    }
                }
            }
            .addOnFailureListener {
                Toast.makeText(this, "Failed to search for bicycle.", Toast.LENGTH_SHORT).show()
            }
    }
}

