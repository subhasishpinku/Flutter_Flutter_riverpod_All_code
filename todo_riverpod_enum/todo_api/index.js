const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

let initialTodos = [
  { id: "1", desc: "Clean the room", completed: false },
  { id: "2", desc: "Wash the dish", completed: false },
  { id: "3", desc: "Do homework", completed: false },
];

let todos = [...initialTodos];

app.get('/todos', (req, res) => {
  res.json(todos);
});

app.post('/todos', (req, res) => {
  const newTodo = req.body;
  todos.push(newTodo);
  res.status(201).json(newTodo);
});

app.put('/todos/:id', (req, res) => {
  const { id } = req.params;
  const { desc } = req.body;
  todos = todos.map(todo => todo.id === id ? { ...todo, desc } : todo);
  res.json(todos.find(todo => todo.id === id));
});

app.patch('/todos/:id', (req, res) => {
  const { id } = req.params;
  todos = todos.map(todo => todo.id === id ? { ...todo, completed: !todo.completed } : todo);
  res.json(todos.find(todo => todo.id === id));
});

app.delete('/todos/:id', (req, res) => {
  const { id } = req.params;
  todos = todos.filter(todo => todo.id !== id);
  res.status(204).end();
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
