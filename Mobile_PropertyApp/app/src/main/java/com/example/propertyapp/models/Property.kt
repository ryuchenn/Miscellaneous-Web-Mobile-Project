package com.example.propertyapp.models

import com.google.firebase.firestore.DocumentId
import java.io.Serializable

data class Property(
    @DocumentId
    var documentId: String = "",

    var id: String = "",

    //Landlord
    var userId:String = "",

    var name:String = "",

    var address:String = "",

    /*
    When the form is submitted to the database, the address and corresponding latitude and longitude should be saved to the
    database. Use geocoding to convert address to coordinates and vice-versa.
     */
    var latitude:Double = 0.0,
    var longitude:Double = 0.0,

    var image:String = "",

    //Monthly rental price
    var price:Double = 0.0,

    //Number of bedrooms
    var totalBedrooms:String = "0", // 0: "Studio", 1: "1BD", 2: "1+1BD", 3: "2BD", 4: "2+1BD", 5: "3BD+"

    var available: Boolean = true
):Serializable
