package com.example.propertyapp

import android.app.AlertDialog
import android.content.Context

class Dialog(private val context: Context) {
    fun error(
        title: String? = "Error",
        content: String = "An error occurred",
        callback: () -> Unit = {}
    ) {
        AlertDialog.Builder(context)
            .setTitle(title)
            .setMessage(content)
            .setPositiveButton("Ok") { dialog, _ ->
                dialog.dismiss()
                callback()
            }
            .show()
    }

    fun ok(
        title: String? = "Success",
        content: String = "Operation successful",
        callback: () -> Unit = {}
    ) {
        AlertDialog.Builder(context)
            .setTitle(title)
            .setMessage(content)
            .setPositiveButton("Ok") { dialog, _ ->
                dialog.dismiss()
                callback()
            }
            .show()
    }

    fun confirm(
        title: String? = "Confirm Deletion",
        content: String? = "Are you sure you want to remove this item?",
        okText: String? = "Yes",
        cancelText: String? = "Cancel",
        onOk: () -> Unit = {},
        onCancel: () -> Unit = {}
    ) {
        val builder = AlertDialog.Builder(context)
            .setTitle(title)
            .setMessage(content)
            .setPositiveButton(okText) { dialog, _ ->
                dialog.dismiss()
                onOk()
            }
            .setNegativeButton(cancelText) { dialog, _ ->
                dialog.dismiss()
                onCancel()
            }

        val dialog = builder.create()

        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(true)

        dialog.show()
    }
}