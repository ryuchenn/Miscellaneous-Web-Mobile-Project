package com.example.propertyapp.models

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import coil.load
import com.example.propertyapp.R
import com.example.propertyapp.databinding.PropertyRowBinding

class PropertyAdapter(
    private val properties: List<Property>,
//    private val onEdit: (Property) -> Unit,
//    private val onDelete: (Property) -> Unit,
//    private val onToggleAvailability: (Property) -> Unit,
    private val showOnMap: (Property) -> Unit,
    private val goDetailActivity: (Property) -> Unit
) : RecyclerView.Adapter<PropertyAdapter.PropertyViewHolder>() {

    class PropertyViewHolder(val binding: PropertyRowBinding) : RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PropertyViewHolder {
        val binding = PropertyRowBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return PropertyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: PropertyViewHolder, position: Int) {
        val property = properties[position]
        holder.binding.apply {
            tvPropertyName.text = property.name
            tvPropertyAddress.text = property.address
            tvPropertyPrice.text = "$${property.price}"
            tvPropertyBedrooms.text = "Layout: ${property.totalBedrooms}"

            showOnMap.setOnClickListener{ showOnMap(property) }

            ivPropertyImage.setOnClickListener { goDetailActivity(property) }
            tvPropertyName.setOnClickListener{ goDetailActivity(property) }

//            btnToggleAvailability.text = if (property.available) "Unavailable" else "Available"
//            btnEdit.setOnClickListener { onEdit(property) }
//            btnDelete.setOnClickListener { onDelete(property) }
//            btnToggleAvailability.setOnClickListener { onToggleAvailability(property) }

            // Image
            ivPropertyImage.load(property.image) {
                placeholder(R.drawable.property)
                error(R.drawable.property)
                crossfade(true)
            }
        }
    }

    override fun getItemCount() = properties.size
}
