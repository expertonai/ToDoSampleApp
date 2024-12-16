package com.example.todoapp.presentation

import com.example.todoapp.model.TodoRepository
import com.example.todoapp.model.TodoTask
import kotlinx.coroutines.flow.StateFlow

expect abstract class BaseViewModel() {
    protected fun onCleared()
}

class TodoViewModel(
    private val repository: TodoRepository
) : BaseViewModel() {
    val tasks: StateFlow<List<TodoTask>> = repository.getAllTasks()

    fun addTask(title: String) {
        if (title.isNotBlank()) {
            repository.addTask(title)
        }
    }

    fun deleteTask(id: String) {
        repository.deleteTask(id)
    }

    fun toggleTask(id: String) {
        repository.toggleTask(id)
    }
}
