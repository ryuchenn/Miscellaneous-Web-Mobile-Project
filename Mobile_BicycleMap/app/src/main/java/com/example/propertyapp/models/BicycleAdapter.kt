package com.example.propertyapp.models

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.example.propertyapp.databinding.BicycleRowBinding

class BicycleAdapter(
    private val bicycles: List<Bicycle>,
    private val returnBicycle: (Bicycle) -> Unit
) : RecyclerView.Adapter<BicycleAdapter.BicycleViewHolder>() {

    class BicycleViewHolder(val binding: BicycleRowBinding) : RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BicycleViewHolder {
        val binding = BicycleRowBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return BicycleViewHolder(binding)
    }

    override fun onBindViewHolder(holder: BicycleViewHolder, position: Int) {
        val bicycle = bicycles[position]
        holder.binding.apply {
            tvName.text = bicycle.name
            tvAddress.text = bicycle.address

            btnReturn.setOnClickListener {
                returnBicycle(bicycle)
            }

            btnReturn.visibility = if (!bicycle.isReturned) View.VISIBLE else View.GONE
        }
    }

    override fun getItemCount() = bicycles.size
}