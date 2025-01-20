package com.example.learningapp.data

import com.example.learningapp.models.Lesson

data class Lessons(
    var lessonList:MutableList<Lesson> = mutableListOf(
        Lesson(1, "Introduction", "Hey gang, in this complete modern React tutorial we'll learn about React from the ground up - setup, JSX templates, components & events. We'll cover state & the use of hooks, the React Router & also how to handle asynchronous code in components.", "https://www.youtube.com/watch?v=j942wKiXFu8",363.6, "https://img.youtube.com/vi/j942wKiXFu8/0.jpg"),
        Lesson(2, "Creating a React Application", "In this React tutorial we'll see how to use the create-react-app tool to boilerplate a new React application. We'll also take a tour of the starter project.", "https://www.youtube.com/watch?v=kVeOpcw4GWY",780.6, "https://img.youtube.com/vi/kVeOpcw4GWY/0.jpg"),
        Lesson(3, "Components & Templates", "Hey gang, in this React tutorial we'll take a look at how components are made and how they return JSX templates (which are then rendered to the browser).", "https://www.youtube.com/watch?v=9D1x7-2FmTA",381.6, "https://img.youtube.com/vi/9D1x7-2FmTA/0.jpg"),
        Lesson(4, "Dynamic Values in Templates", "In this React tutorial we'll see how to output dynamic values & variables using curly braces { } in our React JSX templates.", "https://www.youtube.com/watch?v=pnhO8UaCgxg",318.6, "https://img.youtube.com/vi/pnhO8UaCgxg/0.jpg"),
        Lesson(5, "Multiple Components", "Hey gang, in this React tutorial we'll see how to add additional components to our React application (a navbar component and a homepage component).", "https://www.youtube.com/watch?v=0sSYmRImgRY",364.8, "https://img.youtube.com/vi/0sSYmRImgRY/0.jpg"),
    )
)
