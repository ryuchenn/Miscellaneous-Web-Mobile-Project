package com.example.roomapp


import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.example.roomapp.databinding.ActivityNewBookBinding
import kotlinx.coroutines.launch

class NewBookActivity : AppCompatActivity() {
    private lateinit var binding: ActivityNewBookBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityNewBookBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val bookDao = AppDatabase.getInstance(this).bookDao()

        binding.btnSave.setOnClickListener {
            val title = binding.etTitle.text.toString()
            val author = binding.etAuthor.text.toString()
            val price = binding.etPrice.text.toString().toDoubleOrNull() ?: 0.0
            val quantity = binding.etQuantity.text.toString().toIntOrNull() ?: 0

            if (title.isBlank() || author.isBlank() || price <= 0 || quantity <= 0) {
                Toast.makeText(this, "Please fill all fields correctly", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            val book = Book(title = title, author = author, price = price, quantity = quantity)
            lifecycleScope.launch {
                bookDao.insertBook(book)
                finish()
            }
        }
    }
}