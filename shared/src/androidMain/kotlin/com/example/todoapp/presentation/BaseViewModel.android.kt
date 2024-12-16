package com.example.todoapp.presentation

import androidx.lifecycle.ViewModel

actual abstract class BaseViewModel : ViewModel() {
    actual override fun onCleared() {
        super.onCleared()
    }
}
