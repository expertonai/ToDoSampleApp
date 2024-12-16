package com.example.todoapp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform