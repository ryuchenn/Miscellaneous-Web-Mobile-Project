package com.example.propertyapp.models

import com.google.firebase.firestore.DocumentId

data class Favorite(
    @DocumentId

    var userId:String = "",

    var propertyId:String = "",
)
