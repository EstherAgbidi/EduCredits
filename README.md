# EduCredits

A blockchain-based academic achievement token system built on Stacks blockchain that enables educational institutions to track, reward, and transfer academic achievements through a decentralized credit system with integrated grade tracking and GPA calculations.

## Overview

EduCredits transforms traditional academic recognition by creating a transparent, immutable record of student achievements. Students earn credits for academic accomplishments, can transfer credits between peers, and redeem them for rewards or recognition. The system now includes comprehensive grade integration with automatic GPA calculations and course management.

## Features

- **Student Registration**: Secure registration system for students on the blockchain
- **Credit Awarding**: Instructors can award credits for various academic achievements
- **Grade Integration**: Complete grade tracking system with letter grades (A, B, C, D, F) and variations
- **GPA Calculation**: Automatic GPA calculation based on grades and credit hours
- **Course Management**: Create and manage courses with credit hour specifications
- **Achievement Tracking**: Comprehensive logging of all student achievements
- **Credit Transfer**: Peer-to-peer credit transfers between registered students
- **Credit Redemption**: Students can redeem accumulated credits for rewards
- **Instructor Management**: Permission-based system for instructor access
- **Analytics**: Track total credits, students, courses, and achievement distributions

## Grade Integration System

### Grade Points Scale
- **A**: 4.0 points (Full credit hours awarded)
- **A-**: 3.67 points (Full credit hours awarded)
- **B+**: 3.33 points (80% of credit hours awarded)
- **B**: 3.0 points (80% of credit hours awarded)
- **B-**: 2.67 points (80% of credit hours awarded)
- **C+**: 2.33 points (60% of credit hours awarded)
- **C**: 2.0 points (60% of credit hours awarded)
- **C-**: 1.67 points (60% of credit hours awarded)
- **D+**: 1.33 points (40% of credit hours awarded)
- **D**: 1.0 points (40% of credit hours awarded)
- **F**: 0.0 points (No credits awarded)

### Credit Award System
Credits are automatically awarded based on the grade received:
- A grades: 100% of course credit hours
- B grades: 80% of course credit hours
- C grades: 60% of course credit hours
- D grades: 40% of course credit hours
- F grades: 0% of course credit hours

## Smart Contract Functions

### Public Functions

#### Student & Instructor Management
- `register-student(student)` - Register a new student in the system
- `grant-instructor-permission(instructor)` - Grant teaching permissions to an instructor

#### Course Management
- `create-course(course-id, course-name, credit-hours)` - Create a new course with specified credit hours

#### Grade & Credit Management
- `award-grade(student, course-id, grade)` - Award a grade for a course (automatically calculates credits and GPA)
- `award-credits(student, amount, achievement)` - Award credits for academic achievements (legacy function)
- `transfer-credits(recipient, amount)` - Transfer credits between students
- `redeem-credits(amount)` - Redeem credits for rewards

### Read-Only Functions

#### Student Information
- `get-student-credits(student)` - Get current credit balance for a student
- `get-student-achievements(student)` - Get list of student achievements
- `get-student-gpa(student)` - Get student's current GPA (multiplied by 100 for precision)
- `get-student-gpa-data(student)` - Get detailed GPA data including total grade points and credit hours
- `get-student-courses(student)` - Get list of courses taken by student

#### Course & Grade Information
- `get-course-grade(student, course-id)` - Get grade information for a specific course
- `get-course-info(course-id)` - Get course details including name, credit hours, and instructor

#### System Statistics
- `get-total-credits()` - Get total credits in the system
- `get-total-students()` - Get total number of registered students
- `get-total-courses()` - Get total number of courses created
- `get-achievement-count(achievement-type)` - Get count of specific achievement type
- `is-instructor(address)` - Check if address has instructor permissions

## Getting Started

### Prerequisites

- Clarinet CLI installed
- Stacks wallet for testing
- Node.js and npm (for frontend integration)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/educredits.git
cd educredits
```

2. Install dependencies
```bash
clarinet install
```

3. Run tests
```bash
clarinet test
```

4. Check contract validity
```bash
clarinet check
```

5. Deploy to testnet
```bash
clarinet deploy --testnet
```

## Usage Examples

### Basic Setup
```clarity
;; Register a student
(contract-call? .educredits register-student 'ST1STUDENT123...)

;; Grant instructor permissions
(contract-call? .educredits grant-instructor-permission 'ST1INSTRUCTOR456...)

;; Create a course
(contract-call? .educredits create-course "CS101" "Introduction to Computer Science" u3)
```

### Grade Management
```clarity
;; Award a grade (automatically calculates credits and updates GPA)
(contract-call? .educredits award-grade 'ST1STUDENT123... "CS101" "A")

;; Check student's GPA (returns GPA * 100, so 350 = 3.50 GPA)
(contract-call? .educredits get-student-gpa 'ST1STUDENT123...)

;; Get detailed grade information for a course
(contract-call? .educredits get-course-grade 'ST1STUDENT123... "CS101")
```

### Legacy Credit System
```clarity
;; Award credits for completing an assignment (legacy function)
(contract-call? .educredits award-credits 'ST1STUDENT123... u100 "Assignment Completion")

;; Transfer credits between students
(contract-call? .educredits transfer-credits 'ST1STUDENT456... u50)

;; Check student balance
(contract-call? .educredits get-student-credits 'ST1STUDENT123...)
```

## Error Codes

- `u100` - Owner only operation
- `u101` - Student/record not found
- `u102` - Student/course already exists
- `u103` - Insufficient credits
- `u104` - Invalid amount
- `u105` - Invalid grade format
- `u106` - Course already exists
- `u107` - Course not found
- `u108` - Invalid credit hours (must be 1-6)

## GPA Calculation

The system automatically calculates GPA using the standard 4.0 scale:
- GPA = (Total Grade Points) / (Total Credit Hours)
- Grade points are stored multiplied by 100 for precision
- Example: A student with 12 credit hours and all A's would have a GPA of 400 (representing 4.00)

## Security Features

- **Permission-based access**: Only contract owner can register students and grant instructor permissions
- **Input validation**: All parameters are validated for type, length, and range
- **Instructor verification**: Only authorized instructors can award grades for their courses
- **Data integrity**: Immutable grade records prevent tampering
- **Error handling**: Comprehensive error codes for all failure scenarios

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/grade-integration`)
3. Make your changes
4. Add tests for new functionality
5. Run `clarinet check` to ensure contract validity
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.