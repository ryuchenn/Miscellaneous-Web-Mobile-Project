package com.example.propertyapp

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Address
import android.location.Geocoder
import android.location.Location
import android.location.LocationManager
import android.os.Bundle
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.motion.widget.Debug.getLocation
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import com.example.propertyapp.databinding.ActivityEditLeaseBinding
import com.example.propertyapp.models.Property
import com.example.propertyapp.models.User
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.tasks.CancellationTokenSource
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import java.util.Locale

class EditLeaseActivity : AppCompatActivity() {
    private lateinit var binding: ActivityEditLeaseBinding
    private val db = Firebase.firestore
    private var isEditMode = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityEditLeaseBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val user = SharedPreferences(this).getUser()
        val property: Property? = intent.getSerializableExtra("property") as? Property

        // Set up listeners
        setupListeners(user, property)

        // Set up spinner options
        settingOptions()
    }

    private fun addressToLatLng(strAddress: String): LatLng? {
        var latLng: LatLng? = null
        val geocoder = Geocoder(this, Locale.getDefault())

        val geoResults: List<Address>? = geocoder.getFromLocationName(strAddress, 1)
        if (!geoResults.isNullOrEmpty()) {
            val addr = geoResults[0]
            latLng = LatLng(addr.latitude, addr.longitude)
        }

        return latLng
    }

    private fun settingOptions(){
        val bedroomOptions = listOf("Studio", "1BD", "1+1BD", "2BD", "2+1BD", "3BD+")
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, bedroomOptions)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spBedrooms.adapter = adapter
    }

    private fun setEditValue(property: Property){
        property?.let {
            binding.enterName.setText(it.name)
            binding.enterAddress.setText(it.address)
            binding.enterPrice.setText(it.price.toString())
            binding.enterImage.setText(it.image)
            binding.spStatus.isChecked = it.available

            binding.spBedrooms.post {
                val bedroomIndex = when (it.totalBedrooms) {
                    "Studio" -> 0
                    "1BD" -> 1
                    "1+1BD" -> 2
                    "2BD" -> 3
                    "2+1BD" -> 4
                    "3BD+" -> 5
                    else -> 0
                }
                binding.spBedrooms.setSelection(bedroomIndex)
            }
        }
    }

    private fun setupListeners(user: User?, property: Property?) {
        if (property != null) {
            setEditValue(property)
            isEditMode = true
            binding.activityName.setText("Edit Lease")
            binding.btnDelete.isVisible = true

            binding.btnDelete.setOnClickListener {
                Dialog(this).confirm(
                    onOk = {
                        db.collection("properties").document(property.id).delete()
                            .addOnSuccessListener {
                                val intent = Intent(this, WelcomeActivity::class.java)
                                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
                                startActivity(intent)
                            }
                            .addOnFailureListener {
                                Toast.makeText(this, "Failed to delete property", Toast.LENGTH_SHORT).show()
                            }
                    }
                )
            }
        }

        binding.btnSubmit.setOnClickListener {
            val name = binding.enterName.text?.trim().toString()
            val address = binding.enterAddress.text?.trim().toString()
            val price = binding.enterPrice.text?.trim().toString().toDoubleOrNull()
            val image = binding.enterImage.text?.trim().toString()
            val totalBedrooms = binding.spBedrooms.selectedItem.toString()
            val available = binding.spStatus.isChecked

            val errorMessages = mutableListOf<String>()

            if (address.isEmpty()) {
                errorMessages.add("Address")
            }
            if (price == null) {
                errorMessages.add("Price")
            }
            if (image.isEmpty()) {
                errorMessages.add("Image")
            }

            if (errorMessages.isNotEmpty()) {
                val message = "${errorMessages.joinToString(", ")} ${if (errorMessages.count() > 1) "are" else "is"} required."
                Dialog(this).error(null, message)
            } else {
                var addr = addressToLatLng(address)

                if (addr != null) {
                    val data = Property(
                        name = name,
                        address = address,
                        image = image,
                        price = price?: 0.0,
                        totalBedrooms = totalBedrooms,
                        userId = user?.id  ?: "",
                        latitude = addr!!.latitude,
                        longitude = addr!!.longitude,
                        available = available,
                    )

                    if(!isEditMode){
                        db.collection("properties")
                            .add(data)
                            .addOnSuccessListener { documentReference ->
                                val documentId = documentReference.id
                                documentReference.update("id", documentId)
                                    .addOnSuccessListener {
                                        Dialog(this).ok(
                                            null,
                                            "Your lease has been successfully added!",
                                            {
                                                finish()
                                            }
                                        )
                                    }
                            }
                            .addOnFailureListener { exception ->
                                Dialog(this).error(
                                    null,
                                    "There was an error adding the lease. Please try again later"
                                )
                            }
                    } else {
                        property?.let {
                            val updatedProperty = mapOf(
                                "name" to name,
                                "address" to address,
                                "price" to price,
                                "image" to image,
                                "totalBedrooms" to totalBedrooms,
                                "userId" to it.userId,
                                "available" to available,
                            )
                            db.collection("properties").document(it.id).update(updatedProperty)
                                .addOnSuccessListener {
                                    Dialog(this).ok(
                                        null,
                                        "Your lease has been successfully updated!",
                                        {
                                            val intent = Intent(this, WelcomeActivity::class.java)
                                            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
                                            startActivity(intent)
                                        }
                                    )
                                }
                                .addOnFailureListener { e ->
                                    Toast.makeText(
                                        this,
                                        "Failed to update property: ${e.message}",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                        }
                    }
                } else {
                    Dialog(this).error(
                        content = "Failed to retrieve the address. Please verify that the address you entered is correct."
                    )
                }
            }
        }

        val requestPermissionLauncher = registerForActivityResult(ActivityResultContracts.RequestPermission()) { permissionGranted: Boolean ->
            if (permissionGranted) {
                getLocation()
            } else {
                Dialog(this).error(
                    "Permission Required",
                    "Location permission is required to fetch your current position. Please enable it in your app settings."
                )
            }
        }

        binding.place.setOnClickListener {
            var fusedLocationClient: FusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this)

            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
                fusedLocationClient.getCurrentLocation(
                    LocationRequest.PRIORITY_HIGH_ACCURACY,
                    CancellationTokenSource().token
                ).addOnSuccessListener { location: Location? ->
                    if (location != null) {
                        val geocoder = Geocoder(this)
                        val addresses = geocoder.getFromLocation(location.latitude, location.longitude, 1)
                        if (addresses != null) {
                            val address = addresses[0].getAddressLine(0)
                            binding.enterAddress.setText(address)
                        } else {
                            Toast.makeText(this, "Failed to fetch location", Toast.LENGTH_SHORT).show()
                        }
                    } else {
                        Log.e("LOCATION", "Failed to fetch location")
                    }
                }.addOnFailureListener { exception ->
                    Log.e("LOCATION", "Failed to fetch location", exception)
                }
            } else {
                requestPermissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
            }
        }
    }
}