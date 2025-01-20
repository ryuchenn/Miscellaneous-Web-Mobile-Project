package com.example.learningapp

import android.content.Context
import android.content.SharedPreferences

class SharedPreferences(private val context: Context) {
    private val sharedPreferences: SharedPreferences = context.applicationContext
        .getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)

    fun getString(key: String): String? {
        return sharedPreferences.getString(key, null) ?: return ""
    }

    fun getBooleanArray(key: String): BooleanArray? {
        val serializedArray = sharedPreferences.getString(key, null) ?: return null
        return serializedArray.split(",").map { it.toBoolean() }.toBooleanArray()
    }

    fun saveBooleanArray(key: String, array: BooleanArray) {
        val serializedArray = array.joinToString(",") { it.toString() }
        sharedPreferences.edit().putString(key, serializedArray).apply()
    }

    fun saveString(key: String, value: String) {
        sharedPreferences.edit().putString(key, value).apply()
    }

    fun clear() {
        sharedPreferences.edit().clear().apply()
    }
}