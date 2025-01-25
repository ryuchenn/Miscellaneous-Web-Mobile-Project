package com.example.propertyapp.models

import com.google.firebase.firestore.DocumentId

data class User(
    @DocumentId

    var id:String = "",

    var name:String = "",

    var avatar:String = "",

    var phone:String = "",
)
