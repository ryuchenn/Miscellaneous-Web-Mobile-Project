package com.example.roomapp
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.roomapp.databinding.ActivityMainBinding
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var adapter: BookAdapter
    private lateinit var bookDao: BookDao

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        bookDao = AppDatabase.getInstance(this).bookDao()

        settingForm()
        loadBooks()
    }

    override fun onResume() {
        super.onResume()
        loadBooks()
    }

    private fun settingForm() {
        adapter = BookAdapter(mutableListOf()) { book ->
            val intent = Intent(this, BookDetailActivity::class.java)
            intent.putExtra("BOOK_ID", book.id)
            startActivity(intent)
        }
        binding.rvBooks.layoutManager = LinearLayoutManager(this)
        binding.rvBooks.adapter = adapter

        binding.btnAddBook.setOnClickListener {
            val intent = Intent(this, NewBookActivity::class.java)
            startActivity(intent)
        }
    }

    private fun loadBooks() {
        lifecycleScope.launch {
            val books = bookDao.getAllBooks()
            adapter.updateBooks(books)
        }
    }
}