package com.example.pizza.model

import kotlin.random.Random

class PizzaOrder(
    private val numSlices: Int,
    private val needsDelivery: Boolean,
    private val pizzaType: String
) {
    private val pricePerSlice: Double = if (pizzaType == "Vegetarian") 4.25 else 6.70
    private val deliveryCost: Double = if (needsDelivery) 5.25 else 0.0
    private val taxRate: Double = 0.13
    private val confirmationNumber: Int = Random.nextInt(1000, 9999)

    private val subtotal: Double = numSlices * pricePerSlice + deliveryCost
    private val taxAmount: Double = subtotal * taxRate
    val total: Double = subtotal + taxAmount

    override fun toString(): String {
        return """
            ======Order Details=======
            Confirmation Code: $confirmationNumber
            
            Your Receipt:
            Pizza Type: $pizzaType
            Number of slices: $numSlices
            Price per slice: $$pricePerSlice
            Delivery cost: $$deliveryCost
            Subtotal: $$subtotal
            Tax (13%): $$taxAmount
            Total: $$total
        """
    }
}