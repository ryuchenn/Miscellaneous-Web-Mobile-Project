package com.example.roomapp


import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.example.roomapp.databinding.ActivityBookDetailBinding
import kotlinx.coroutines.launch

class BookDetailActivity : AppCompatActivity() {
    private lateinit var binding: ActivityBookDetailBinding
    private var bookId: Int = -1
    private lateinit var bookDao: BookDao

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityBookDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)

        bookDao = AppDatabase.getInstance(this).bookDao()
        bookId = intent.getIntExtra("BOOK_ID", -1)

        if (bookId == -1) {
            Toast.makeText(this, "Invalid Book ID", Toast.LENGTH_SHORT).show()
            finish()
            return
        }

        loadBookDetails()

        binding.btnSave.setOnClickListener { saveBookDetails() }
        binding.btnDelete.setOnClickListener { deleteBook() }
    }

    private fun loadBookDetails() {
        lifecycleScope.launch {
            val book = bookDao.getBookById(bookId)
            binding.etTitle.setText(book.title)
            binding.etAuthor.setText(book.author)
            binding.etPrice.setText(book.price.toString())
            binding.etQuantity.setText(book.quantity.toString())
        }
    }

    private fun saveBookDetails() {
        val updatedTitle = binding.etTitle.text.toString()
        val updatedAuthor = binding.etAuthor.text.toString()
        val updatedPrice = binding.etPrice.text.toString().toDoubleOrNull() ?: 0.0
        val updatedQuantity = binding.etQuantity.text.toString().toIntOrNull() ?: 0

        if (updatedTitle.isBlank() || updatedAuthor.isBlank() || updatedPrice <= 0 || updatedQuantity <= 0) {
            Toast.makeText(this, "Please fill all fields correctly", Toast.LENGTH_SHORT).show()
            return
        }

        val updatedBook = Book(
            id = bookId,
            title = updatedTitle,
            author = updatedAuthor,
            price = updatedPrice,
            quantity = updatedQuantity
        )

        lifecycleScope.launch {
            bookDao.updateBook(updatedBook)
            Toast.makeText(this@BookDetailActivity, "Book Updated", Toast.LENGTH_SHORT).show()
            finish()
        }
    }

    private fun deleteBook() {
        lifecycleScope.launch {
            val book = bookDao.getBookById(bookId)
            bookDao.deleteBook(book)
            Toast.makeText(this@BookDetailActivity, "Book Deleted", Toast.LENGTH_SHORT).show()
            finish()
        }
    }
}


