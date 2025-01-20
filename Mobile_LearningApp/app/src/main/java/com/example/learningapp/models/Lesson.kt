package com.example.learningapp.models

import java.io.Serializable

class Lesson: Serializable {
    var number:Int
    var name:String
    var description:String
    var link:String
    var length:Double
    var cover:String

    constructor(number: Int, name: String, description: String, link: String, length: Double, cover: String) {
        this.number = number
        this.name = name
        this.description = description
        this.link = link
        this.length = length
        this.cover = cover
    }
}