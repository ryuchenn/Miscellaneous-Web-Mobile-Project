package com.example.pizza

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.Switch
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.pizza.model.PizzaOrder

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)

        val vegetarianRadio = findViewById<RadioButton>(R.id.vegetarianRadio)
        val sliceCountInput = findViewById<EditText>(R.id.sliceCountInput)
        val wholePizzaSwitch = findViewById<Switch>(R.id.wholePizzaSwitch)
        val deliverySwitch = findViewById<Switch>(R.id.deliverySwitch)
        val submitButton = findViewById<Button>(R.id.submitButton)

        wholePizzaSwitch.setOnCheckedChangeListener { _, isChecked ->
            sliceCountInput.setText(if (isChecked) "8" else "0")
        }

        submitButton.setOnClickListener {
            val pizzaType = if (vegetarianRadio.isChecked) "Vegetarian" else "Meat"
            val numSlices = sliceCountInput.text.toString().toIntOrNull() ?: 0
            val needsDelivery = deliverySwitch.isChecked

            val order = PizzaOrder(numSlices, needsDelivery, pizzaType)

            val intent = Intent(this, ReceiptActivity::class.java)
            intent.putExtra("order", order.toString())
            startActivity(intent)
        }

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }
}