package com.example.todoapp.presentation

actual abstract class BaseViewModel {
    protected actual fun onCleared() {
        // iOS cleanup if needed
    }
}
