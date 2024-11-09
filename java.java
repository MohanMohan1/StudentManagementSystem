package Mona;
spring.datasource.url=jdbc:mysql://localhost:3306/studentmangement;
	spring.datasource.username=root;
	spring.datasource.password=yourpassword;
	spring.jpa.hibernate.ddl-auto=update;
	spring.jpa.show-sql=true;
	spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL5Dialect;
	package com.example.studentmanagement.model;

	import javax.persistence.*;

	@Entity
	public class Student {

	    @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Long id;

	    private String firstName;
	    private String lastName;
	    private String email;
	    private int age;

	    // Getters and Setters
	}
	package com.example.studentmanagement.repository;

	import com.example.studentmanagement.model.Student;
	import org.springframework.data.jpa.repository.JpaRepository;

	public interface StudentRepository extends JpaRepository<Student, Long> {
	}
	package com.example.studentmanagement.service;

	import com.example.studentmanagement.model.Student;
	import com.example.studentmanagement.repository.StudentRepository;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;

	import java.util.List;
	import java.util.Optional;

	@Service
	public class StudentService {

	    @Autowired
	    private StudentRepository studentRepository;

	    public List<Student> getAllStudents() {
	        return studentRepository.findAll();
	    }

	    public Optional<Student> getStudentById(Long id) {
	        return studentRepository.findById(id);
	    }

	    public Student saveStudent(Student student) {
	        return studentRepository.save(student);
	    }

	    public Student updateStudent(Long id, Student studentDetails) {
	        Student student = studentRepository.findById(id)
	                .orElseThrow(() -> new RuntimeException("Student not found"));
	        
	        student.setFirstName(studentDetails.getFirstName());
	        student.setLastName(studentDetails.getLastName());
	        student.setEmail(studentDetails.getEmail());
	        student.setAge(studentDetails.getAge());
	        
	        return studentRepository.save(student);
	    }

	    public void deleteStudent(Long id) {
	        studentRepository.deleteById(id);
	    }
	}
	package com.example.studentmanagement.controller;

	import com.example.studentmanagement.model.Student;
	import com.example.studentmanagement.service.StudentService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.web.bind.annotation.*;

	import java.util.List;
	import java.util.Optional;

	@RestController
	@RequestMapping("/api/students")
	public class StudentController {

	    @Autowired
	    private StudentService studentService;

	    @GetMapping
	    public List<Student> getAllStudents() {
	        return studentService.getAllStudents();
	    }

	    @GetMapping("/{id}")
	    public Optional<Student> getStudentById(@PathVariable Long id) {
	        return studentService.getStudentById(id);
	    }

	    @PostMapping
	    public Student createStudent(@RequestBody Student student) {
	        return studentService.saveStudent(student);
	    }

	    @PutMapping("/{id}")
	    public Student updateStudent(@PathVariable Long id, @RequestBody Student studentDetails) {
	        return studentService.updateStudent(id, studentDetails);
	    }

	    @DeleteMapping("/{id}")
	    public void deleteStudent(@PathVariable Long id) {
	        studentService.deleteStudent(id);
	    }
	}
	@Configuration
	@EnableWebSecurity
	public class SecurityConfig extends WebSecurityConfigurerAdapter {

	    @Override
	    protected void configure(HttpSecurity http) throws Exception {
	        http.csrf().disable()
	            .authorizeRequests()
	            .antMatchers("/api/students/**").authenticated()
	            .and()
	            .httpBasic();
	    }

	    @Bean
	    public PasswordEncoder passwordEncoder() {
	        return new BCryptPasswordEncoder();
	    }
	}




public class java {

}
