package com.example.pizza

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class ReceiptActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_receipt)

        val receiptTextView = findViewById<TextView>(R.id.receiptTextView)
        val orderDetails = intent.getStringExtra("order")

        receiptTextView.text = orderDetails
    }
}
