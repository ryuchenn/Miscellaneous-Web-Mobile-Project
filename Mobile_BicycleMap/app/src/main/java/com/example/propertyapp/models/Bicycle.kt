package com.example.propertyapp.models

import com.google.firebase.firestore.DocumentId

data class Bicycle(
    @DocumentId
    var documentId: String = "",

    var isReturned: Boolean = false,

    var lat: Double = 0.0,

    var lng: Double = 0.0,

    var address: String = "",

    var name: String = "", //  BIKE-XXX 0~999

    var updateTime: Long = 0

)