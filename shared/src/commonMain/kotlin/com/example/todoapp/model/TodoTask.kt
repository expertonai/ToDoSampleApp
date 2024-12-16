package com.example.todoapp.model

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.datetime.Clock

data class TodoTask(
    val id: String,
    val title: String,
    val isCompleted: Boolean = false
)

// Repository interface in the same file since it's a small app
interface TodoRepository {
    fun getAllTasks(): StateFlow<List<TodoTask>>
    fun addTask(title: String)
    fun deleteTask(id: String)
    fun toggleTask(id: String)
}

// In-memory implementation
class InMemoryTodoRepository : TodoRepository {
    private val _tasks = MutableStateFlow<List<TodoTask>>(emptyList())
    override fun getAllTasks(): StateFlow<List<TodoTask>> = _tasks.asStateFlow()

    override fun addTask(title: String) {
        val newTask = TodoTask(
            id = Clock.System.now().toEpochMilliseconds().toString(),
            title = title
        )
        _tasks.value = _tasks.value + newTask
    }

    override fun deleteTask(id: String) {
        _tasks.value = _tasks.value.filter { it.id != id }
    }

    override fun toggleTask(id: String) {
        _tasks.value = _tasks.value.map { task ->
            if (task.id == id) task.copy(isCompleted = !task.isCompleted)
            else task
        }
    }
}
