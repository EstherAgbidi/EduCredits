# EduCredits

A blockchain-based academic achievement token system built on Stacks blockchain that enables educational institutions to track, reward, and transfer academic achievements through a decentralized credit system with integrated grade tracking, GPA calculations, cross-institutional support, and **unique NFT achievement badges**.

## Overview

EduCredits transforms traditional academic recognition by creating a transparent, immutable record of student achievements across multiple educational institutions. Students earn credits for academic accomplishments, can transfer credits between peers (including across institutions), redeem them for rewards, and **earn unique NFT badges for special academic milestones**. The system includes comprehensive grade integration with automatic GPA calculations, course management, multi-institution support with partnership networks, and a verifiable NFT badge system for celebrating exceptional achievements.

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

### NFT Achievement Badge Features 🆕
- **Unique Digital Badges**: Mint NFT tokens for special academic milestones and achievements
- **Milestone Tracking**: Automatic milestone verification and badge eligibility checking
- **Badge Metadata**: Rich metadata including milestone type, description, institution, and award date
- **Transferable Badges**: NFT badges can be transferred between registered students
- **Predefined Milestones**: Built-in milestone types with automatic criteria validation
- **Custom Metadata URIs**: Support for external metadata links (IPFS, Arweave, etc.)
- **Institutional Badge Analytics**: Track NFT badges minted per institution
- **Immutable Proof**: Permanent, verifiable record of academic excellence on the blockchain

## NFT Achievement Badge System

### Predefined Milestone Types

1. **DEAN_LIST** 🎓
   - Criteria: GPA ≥ 3.5
   - Description: "Achieved Dean's List with GPA of 3.5 or higher"

2. **HONORS_GRADUATE** 🏆
   - Criteria: GPA ≥ 3.5 AND Credits ≥ 120
   - Description: "Graduated with Honors: 3.5 GPA and 120+ credits"

3. **SUMMA_CUM_LAUDE** ⭐
   - Criteria: GPA ≥ 3.9
   - Description: "Summa Cum Laude: Exceptional academic excellence with 3.9+ GPA"

4. **PERFECT_SEMESTER** 💯
   - Criteria: GPA = 4.0
   - Description: "Perfect Semester: Achieved 4.0 GPA"

5. **CENTURY_CLUB** 💪
   - Criteria: Credits ≥ 100
   - Description: "Century Club: Earned 100+ academic credits"

6. **RESEARCH_EXCELLENCE** 🔬
   - Criteria: Credits ≥ 50 (customizable)
   - Description: "Research Excellence: Outstanding contribution to academic research"

### NFT Badge Benefits

- **Permanent Achievement Record**: Badges are stored permanently on the blockchain
- **Verifiable Credentials**: Anyone can verify the authenticity of academic achievements
- **Portable Recognition**: NFT badges can be displayed in digital wallets and portfolios
- **Cross-Platform Compatibility**: Standard NFT format works across the Stacks ecosystem
- **Enhanced Credibility**: Blockchain-verified achievements carry more weight with employers
- **Collector Value**: Students build a comprehensive collection of their academic journey

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

#### NFT Achievement Badge Functions 🆕
- `mint-achievement-badge(student, milestone-type, description, metadata-uri)` - Mint a unique NFT badge for a student
- `transfer-achievement-badge(nft-id, recipient)` - Transfer an NFT badge to another registered student
- `auto-mint-milestone-badge(student, milestone-type)` - Automatically mint badge if milestone criteria is met

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

#### NFT Badge Information 🆕
- `get-nft-metadata(nft-id)` - Get complete metadata for an NFT badge
- `get-student-nft-badges(student)` - Get all NFT badges owned by a student
- `has-milestone-badge(student, milestone-type)` - Check if student has achieved a specific milestone
- `get-institution-nft-count(institution-id)` - Get total NFT badges minted by an institution
- `get-total-nfts-minted()` - Get total number of NFT badges minted system-wide
- `get-nft-owner(nft-id)` - Get the current owner of an NFT badge
- `get-last-token-id()` - Get the most recently minted NFT token ID
- `get-token-uri(nft-id)` - Get the metadata URI for an NFT badge (standard NFT function)

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

### NFT Achievement Badge Examples 🆕

```clarity
;; Mint a custom achievement badge
(contract-call? .educredits mint-achievement-badge 
  'ST1STUDENT123... 
  "RESEARCH_EXCELLENCE" 
  "Outstanding research contribution to quantum computing" 
  (some "ipfs://QmX..."))

;; Auto-mint Dean's List badge (checks criteria automatically)
(contract-call? .educredits auto-mint-milestone-badge 
  'ST1STUDENT123... 
  "DEAN_LIST")

;; Transfer badge to another student
(contract-call? .educredits transfer-achievement-badge u1 'ST1STUDENT456...)

;; Get all badges for a student
(contract-call? .educredits get-student-nft-badges 'ST1STUDENT123...)

;; Check if student has specific milestone
(contract-call? .educredits has-milestone-badge 'ST1STUDENT123... "SUMMA_CUM_LAUDE")

;; Get badge metadata
(contract-call? .educredits get-nft-metadata u1)

;; Get institution's total badges minted
(contract-call? .educredits get-institution-nft-count "MIT")
```

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
- `u114` - NFT not found 🆕
- `u115` - NFT already minted for this milestone 🆕
- `u116` - Milestone criteria not met 🆕
- `u117` - Invalid milestone type 🆕
- `u118` - Unauthorized action 🆕

## NFT Achievement Badge Benefits 🆕

### For Students
- **Digital Portfolio**: Build a verifiable collection of academic achievements
- **Enhanced Credibility**: Blockchain-verified badges provide tamper-proof credentials
- **Career Advancement**: Share badges with potential employers and graduate schools
- **Motivation**: Visual representation of achievements encourages continued excellence
- **Ownership**: True ownership of achievement records that can't be revoked

### For Institutions
- **Brand Recognition**: NFT badges carry institutional branding and prestige
- **Quality Assurance**: Verifiable proof of institutional standards and excellence
- **Alumni Engagement**: Create lasting connections through permanent achievement records
- **Innovation Leadership**: Demonstrate technological advancement in education
- **Analytics**: Track milestone achievements and student excellence trends

### For the Academic Community
- **Standardization**: Common framework for recognizing academic milestones
- **Transparency**: Public verification of academic achievements
- **Interoperability**: NFT badges work across different platforms and applications
- **Innovation**: Opens new possibilities for credential verification and recognition

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
- **NFT ownership**: Only NFT owners can transfer their badges
- **Milestone validation**: Automatic verification prevents fraudulent badge minting
- **Error handling**: Comprehensive error codes for all failure scenarios

## Technical Specifications

### NFT Standard Compliance
- Implements Stacks NFT trait with standard functions
- Compatible with Stacks wallets and NFT marketplaces
- Supports metadata URIs for rich media (IPFS, Arweave, etc.)
- Transferable with proper ownership verification

### Data Storage
- On-chain metadata for core achievement information
- Optional off-chain metadata URIs for additional content
- Efficient storage using uint identifiers and indexed maps
- Maximum 50 NFT badges per student (configurable)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/nft-achievement-badges`)
3. Make your changes
4. Add tests for new functionality
5. Run `clarinet check` to ensure contract validity
6. Submit a pull request
