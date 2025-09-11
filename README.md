# EduCredits

A blockchain-based academic achievement token system built on Stacks blockchain that enables educational institutions to track, reward, and transfer academic achievements through a decentralized credit system with integrated grade tracking, GPA calculations, and **cross-institutional support**.

## Overview

EduCredits transforms traditional academic recognition by creating a transparent, immutable record of student achievements across multiple educational institutions. Students earn credits for academic accomplishments, can transfer credits between peers (including across institutions), and redeem them for rewards or recognition. The system now includes comprehensive grade integration with automatic GPA calculations, course management, and multi-institution support with partnership networks.

## Features

### Core Features
- **Student Registration**: Secure registration system for students on the blockchain with institution affiliation
- **Credit Awarding**: Instructors can award credits for various academic achievements
- **Grade Integration**: Complete grade tracking system with letter grades (A, B, C, D, F) and variations
- **GPA Calculation**: Automatic GPA calculation based on grades and credit hours
- **Course Management**: Create and manage courses with credit hour specifications and institutional affiliation
- **Achievement Tracking**: Comprehensive logging of all student achievements
- **Credit Transfer**: Peer-to-peer credit transfers between registered students (same or different institutions)
- **Credit Redemption**: Students can redeem accumulated credits for rewards
- **Instructor Management**: Permission-based system for instructor access with institutional verification
- **Analytics**: Track total credits, students, courses, institutions, and achievement distributions

### Multi-Institution Features
- **Institution Registration**: Register educational institutions with accreditation levels and administrative control
- **Partnership Networks**: Establish recognition partnerships between institutions with customizable transfer rates
- **Cross-Institutional Transfers**: Transfer credits between students at different institutions with partnership-based conversion rates
- **Institutional Analytics**: Track credits, transfers, and partnerships per institution
- **Distributed Administration**: Each institution manages its own students, instructors, and courses while maintaining interoperability

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

## Multi-Institution System

### Institution Structure
- **Institution ID**: Unique 10-character identifier for each institution
- **Accreditation Level**: 1-5 scale representing institutional accreditation status
- **Administrative Control**: Each institution has an admin who can manage students and instructors
- **Active Status**: Institutions can be activated/deactivated

### Partnership System
- **Bilateral Partnerships**: Institutions can establish mutual recognition agreements
- **Transfer Rates**: Customizable credit conversion rates (0-100%) between partner institutions
- **Cross-Institutional Transfers**: Students can transfer credits across institutions based on partnership agreements

### Examples of Transfer Rates
- **Full Partnership**: 100% transfer rate (1:1 credit conversion)
- **Standard Partnership**: 80% transfer rate (10 credits become 8 credits)
- **Limited Partnership**: 60% transfer rate (10 credits become 6 credits)

## Smart Contract Functions

### Public Functions

#### Institution Management
- `register-institution(institution-id, name, admin, accreditation-level)` - Register a new educational institution
- `establish-partnership(institution-a, institution-b, transfer-rate)` - Create partnership between institutions

#### Student & Instructor Management
- `register-student(student, institution-id)` - Register a new student with an institution
- `grant-instructor-permission(instructor, institution-id)` - Grant teaching permissions to an instructor at an institution

#### Course Management
- `create-course(course-id, course-name, credit-hours, institution-id)` - Create a new course at a specific institution

#### Grade & Credit Management
- `award-grade(student, course-id, grade)` - Award a grade for a course (automatically calculates credits and GPA)
- `award-credits(student, amount, achievement)` - Award credits for academic achievements (legacy function)
- `transfer-credits-cross-institution(recipient, amount)` - Transfer credits between students (supports cross-institutional transfers)
- `transfer-credits(recipient, amount)` - Transfer credits between students (wrapper for cross-institutional function)
- `redeem-credits(amount)` - Redeem credits for rewards

### Read-Only Functions

#### Institution Information
- `get-institution-info(institution-id)` - Get institution details including name, admin, and accreditation level
- `get-partnership-info(institution-a, institution-b)` - Get partnership details between two institutions
- `get-institution-credits(institution-id)` - Get total credits awarded by an institution
- `get-cross-institutional-transfers(from-institution, to-institution)` - Get transfer count between institutions

#### Student Information
- `get-student-credits(student)` - Get current credit balance for a student
- `get-student-achievements(student)` - Get list of student achievements
- `get-student-gpa(student)` - Get student's current GPA (multiplied by 100 for precision)
- `get-student-gpa-data(student)` - Get detailed GPA data including total grade points and credit hours
- `get-student-courses(student)` - Get list of courses taken by student
- `get-student-institution(student)` - Get student's affiliated institution

#### Course & Grade Information
- `get-course-grade(student, course-id)` - Get grade information for a specific course
- `get-course-info(course-id)` - Get course details including name, credit hours, and instructor
- `get-course-institution(course-id)` - Get institution offering a specific course
- `get-instructor-institution(instructor)` - Get instructor's affiliated institution

#### System Statistics
- `get-total-credits()` - Get total credits in the system
- `get-total-students()` - Get total number of registered students
- `get-total-courses()` - Get total number of courses created
- `get-total-institutions()` - Get total number of registered institutions
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

### Multi-Institution Setup
```clarity
;; Register institutions
(contract-call? .educredits register-institution "MIT" "Massachusetts Institute of Technology" 'ST1ADMIN123... u5)
(contract-call? .educredits register-institution "HARVARD" "Harvard University" 'ST1ADMIN456... u5)

;; Establish partnership (90% transfer rate)
(contract-call? .educredits establish-partnership "MIT" "HARVARD" u90)

;; Register students with their institutions
(contract-call? .educredits register-student 'ST1STUDENT123... "MIT")
(contract-call? .educredits register-student 'ST1STUDENT456... "HARVARD")
```

### Cross-Institutional Operations
```clarity
;; Grant instructor permissions at specific institution
(contract-call? .educredits grant-instructor-permission 'ST1INSTRUCTOR789... "MIT")

;; Create course at MIT
(contract-call? .educredits create-course "CS101" "Introduction to Computer Science" u3 "MIT")

;; Award grade to MIT student
(contract-call? .educredits award-grade 'ST1STUDENT123... "CS101" "A")

;; Transfer credits from MIT student to Harvard student (90% rate applies)
(contract-call? .educredits transfer-credits-cross-institution 'ST1STUDENT456... u100)
```

### Institution Analytics
```clarity
;; Get institution information
(contract-call? .educredits get-institution-info "MIT")

;; Check partnership details
(contract-call? .educredits get-partnership-info "MIT" "HARVARD")

;; Get institution's total credits awarded
(contract-call? .educredits get-institution-credits "MIT")

;; Get cross-institutional transfer statistics
(contract-call? .educredits get-cross-institutional-transfers "MIT" "HARVARD")
```

### Basic Operations
```clarity
;; Award a grade (automatically calculates credits and updates GPA)
(contract-call? .educredits award-grade 'ST1STUDENT123... "CS101" "A")

;; Check student's GPA (returns GPA * 100, so 350 = 3.50 GPA)
(contract-call? .educredits get-student-gpa 'ST1STUDENT123...)

;; Get detailed grade information for a course
(contract-call? .educredits get-course-grade 'ST1STUDENT123... "CS101")

;; Check student's institution
(contract-call? .educredits get-student-institution 'ST1STUDENT123...)
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
- `u109` - Institution not found
- `u110` - Institution already exists
- `u111` - Institution not recognized (no partnership)
- `u112` - Invalid institution ID
- `u113` - Transfer not allowed

## Multi-Institution Benefits

### For Students
- **Portable Credits**: Credits earned at one institution can be transferred to partner institutions
- **Cross-Institutional Recognition**: Academic achievements are recognized across institutional boundaries
- **Flexible Learning Paths**: Students can take courses at multiple institutions within the network

### For Institutions
- **Partnership Networks**: Build academic alliances with other institutions
- **Quality Assurance**: Accreditation levels help maintain academic standards
- **Administrative Control**: Each institution maintains control over its academic processes
- **Transparent Transfers**: All credit transfers are recorded on the blockchain for accountability

### For the Academic Community
- **Standardization**: Common credit system across participating institutions
- **Transparency**: All academic records and transfers are immutable and verifiable
- **Innovation**: Encourages new forms of academic collaboration and student mobility

## GPA Calculation

The system automatically calculates GPA using the standard 4.0 scale:
- GPA = (Total Grade Points) / (Total Credit Hours)
- Grade points are stored multiplied by 100 for precision
- Example: A student with 12 credit hours and all A's would have a GPA of 400 (representing 4.00)

## Security Features

- **Permission-based access**: Only contract owner can register institutions; institution admins manage their own students/instructors
- **Input validation**: All parameters are validated for type, length, and range
- **Institutional verification**: Only authorized personnel can perform actions within their institution
- **Partnership validation**: Credit transfers require established partnerships between institutions
- **Data integrity**: Immutable grade records and transfer history prevent tampering
- **Error handling**: Comprehensive error codes for all failure scenarios

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/multi-institution-support`)
3. Make your changes
4. Add tests for new functionality
5. Run `clarinet check` to ensure contract validity
6. Submit a pull request