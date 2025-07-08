# EduCredits

A blockchain-based academic achievement token system built on Stacks blockchain that enables educational institutions to track, reward, and transfer academic achievements through a decentralized credit system.

## Overview

EduCredits transforms traditional academic recognition by creating a transparent, immutable record of student achievements. Students earn credits for academic accomplishments, can transfer credits between peers, and redeem them for rewards or recognition.

## Features

- **Student Registration**: Secure registration system for students on the blockchain
- **Credit Awarding**: Instructors can award credits for various academic achievements
- **Achievement Tracking**: Comprehensive logging of all student achievements
- **Credit Transfer**: Peer-to-peer credit transfers between registered students
- **Credit Redemption**: Students can redeem accumulated credits for rewards
- **Instructor Management**: Permission-based system for instructor access
- **Analytics**: Track total credits, students, and achievement distributions

## Smart Contract Functions

### Public Functions

- `register-student(student)` - Register a new student in the system
- `grant-instructor-permission(instructor)` - Grant teaching permissions to an instructor
- `award-credits(student, amount, achievement)` - Award credits for academic achievements
- `transfer-credits(recipient, amount)` - Transfer credits between students
- `redeem-credits(amount)` - Redeem credits for rewards

### Read-Only Functions

- `get-student-credits(student)` - Get current credit balance for a student
- `get-student-achievements(student)` - Get list of student achievements
- `get-total-credits()` - Get total credits in the system
- `get-total-students()` - Get total number of registered students
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

4. Deploy to testnet
```bash
clarinet deploy --testnet
```

## Usage Example

```clarity
;; Register a student
(contract-call? .educredits register-student 'ST1STUDENT123...)

;; Award credits for completing an assignment
(contract-call? .educredits award-credits 'ST1STUDENT123... u100 "Assignment Completion")

;; Transfer credits between students
(contract-call? .educredits transfer-credits 'ST1STUDENT456... u50)

;; Check student balance
(contract-call? .educredits get-student-credits 'ST1STUDENT123...)
```

## Error Codes

- `u100` - Owner only operation
- `u101` - Student/record not found
- `u102` - Student already exists
- `u103` - Insufficient credits
- `u104` - Invalid amount

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request
