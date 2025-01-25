package com.example.propertyapp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.example.propertyapp.databinding.ActivityMapBinding
import com.example.propertyapp.models.Property
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions

class MapActivity : AppCompatActivity() {
    private lateinit var sharedPreferences: com.example.propertyapp.SharedPreferences
    private lateinit var binding: ActivityMapBinding

    private val callback = OnMapReadyCallback { googleMap ->
        googleMap.uiSettings.isZoomControlsEnabled = true

        val property: Property = intent.getSerializableExtra("PROPERTY_DETAIL") as Property

        addMarkerAndAnimateCamera(
            googleMap,
            LatLng(property.latitude, property.longitude),
            property.name,
            13F
        )
    }

    // Adds a marker and animates the camera to focus on it
    private fun addMarkerAndAnimateCamera(
        googleMap: GoogleMap,
        location: LatLng,
        title: String,
        zoomLevel: Float
    ) {
        googleMap.addMarker(
            MarkerOptions()
                .position(location)
                .title(title)
        )

        googleMap.animateCamera(
            CameraUpdateFactory.newLatLngZoom(location, zoomLevel)
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMapBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment?
        mapFragment?.getMapAsync(callback)
    }
}
