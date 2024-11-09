<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 80%;
            margin: auto;
        }
        h1, h2 {
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid black;
            padding: 10px;
            text-align: left;
        }
        form {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Student Management System</h1>
        
        <h2>Add New Student</h2>
        <form id="studentForm" onsubmit="addStudent(); return false;">
            <input type="text" id="firstName" placeholder="First Name" required>
            <input type="text" id="lastName" placeholder="Last Name" required>
            <input type="email" id="email" placeholder="Email" required>
            <input type="number" id="age" placeholder="Age" required>
            <button type="submit">Add Student</button>
        </form>

        <h2>Students List</h2>
        <table id="studentTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Age</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- Student data will appear here -->
            </tbody>
        </table>
    </div>

    <script>
        const apiUrl = 'http://localhost:8080/api/students';

        // Fetch students when the page loads
        document.addEventListener('DOMContentLoaded', fetchStudents);

        function fetchStudents() {
            fetch(apiUrl)
                .then(response => response.json())
                .then(data => {
                    const studentTable = document.getElementById('studentTable').getElementsByTagName('tbody')[0];
                    studentTable.innerHTML = '';
                    data.forEach(student => {
                        const row = studentTable.insertRow();
                        row.innerHTML = `
                            <td>${student.id}</td>
                            <td>${student.firstName}</td>
                            <td>${student.lastName}</td>
                            <td>${student.email}</td>
                            <td>${student.age}</td>
                            <td>
                                <button onclick="editStudent(${student.id})">Edit</button>
                                <button onclick="deleteStudent(${student.id})">Delete</button>
                            </td>
                        `;
                    });
                })
                .catch(error => console.error('Error fetching students:', error));
        }

        function addStudent() {
            const student = {
                firstName: document.getElementById('firstName').value,
                lastName: document.getElementById('lastName').value,
                email: document.getElementById('email').value,
                age: document.getElementById('age').value
            };

            fetch(apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(student)
            })
            .then(response => {
                if (response.ok) {
                    fetchStudents();
                    document.getElementById('studentForm').reset();
                }
            })
            .catch(error => console.error('Error adding student:', error));
        }

        function editStudent(id) {
            const firstName = prompt("Enter new first name:");
            const lastName = prompt("Enter new last name:");
            const email = prompt("Enter new email:");
            const age = prompt("Enter new age:");

            const student = { firstName, lastName, email, age };

            fetch(`${apiUrl}/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(student)
            })
            .then(response => {
                if (response.ok) {
                    fetchStudents();
                }
            })
            .catch(error => console.error('Error updating student:', error));
        }

        function deleteStudent(id) {
            if (confirm("Are you sure you want to delete this student?")) {
                fetch(`${apiUrl}/${id}`, { method: 'DELETE' })
                    .then(response => {
                        if (response.ok) {
                            fetchStudents();
                        }
                    })
                    .catch(error => console.error('Error deleting student:', error));
            }
        }
    </script>
</body>
</html>
