;; EduCredits - Academic Achievement Token System with Grade Integration
;; A blockchain-based system for tracking and rewarding academic achievements with grade integration

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-insufficient-credits (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-invalid-grade (err u105))
(define-constant err-course-exists (err u106))
(define-constant err-course-not-found (err u107))
(define-constant err-invalid-credit-hours (err u108))

;; Grade point constants (multiplied by 100 for precision)
(define-constant grade-a u400)  ;; 4.0 * 100
(define-constant grade-a-minus u367)  ;; 3.67 * 100
(define-constant grade-b-plus u333)  ;; 3.33 * 100
(define-constant grade-b u300)  ;; 3.0 * 100
(define-constant grade-b-minus u267)  ;; 2.67 * 100
(define-constant grade-c-plus u233)  ;; 2.33 * 100
(define-constant grade-c u200)  ;; 2.0 * 100
(define-constant grade-c-minus u167)  ;; 1.67 * 100
(define-constant grade-d-plus u133)  ;; 1.33 * 100
(define-constant grade-d u100)  ;; 1.0 * 100
(define-constant grade-f u0)    ;; 0.0 * 100

;; Data Variables
(define-data-var total-credits uint u0)
(define-data-var total-students uint u0)
(define-data-var total-courses uint u0)

;; Data Maps
(define-map student-credits principal uint)
(define-map student-achievements principal (list 20 (string-ascii 50)))
(define-map achievement-types (string-ascii 50) uint)
(define-map instructor-permissions principal bool)

;; Grade Integration Maps
(define-map student-courses principal (list 50 (string-ascii 20)))
(define-map course-grades {student: principal, course: (string-ascii 20)} {grade: (string-ascii 2), grade-points: uint, credit-hours: uint, credits-awarded: uint})
(define-map course-info (string-ascii 20) {name: (string-ascii 50), credit-hours: uint, instructor: principal})
(define-map student-gpa-data principal {total-grade-points: uint, total-credit-hours: uint, gpa: uint})

;; Public Functions

;; Register a new student
(define-public (register-student (student principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-none (map-get? student-credits student)) err-already-exists)
    (map-set student-credits student u0)
    (map-set student-gpa-data student {total-grade-points: u0, total-credit-hours: u0, gpa: u0})
    (var-set total-students (+ (var-get total-students) u1))
    (ok true)
  )
)

;; Grant instructor permissions
(define-public (grant-instructor-permission (instructor principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (not (is-eq instructor contract-owner)) err-invalid-amount)
    (map-set instructor-permissions instructor true)
    (ok true)
  )
)

;; Create a new course
(define-public (create-course (course-id (string-ascii 20)) (course-name (string-ascii 50)) (credit-hours uint))
  (let (
    (is-instructor (default-to false (map-get? instructor-permissions tx-sender)))
  )
    (asserts! (or (is-eq tx-sender contract-owner) is-instructor) err-owner-only)
    (asserts! (> (len course-id) u0) err-invalid-amount)
    (asserts! (> (len course-name) u0) err-invalid-amount)
    (asserts! (and (> credit-hours u0) (<= credit-hours u6)) err-invalid-credit-hours)
    (asserts! (is-none (map-get? course-info course-id)) err-course-exists)
    
    (map-set course-info course-id {name: course-name, credit-hours: credit-hours, instructor: tx-sender})
    (var-set total-courses (+ (var-get total-courses) u1))
    (ok true)
  )
)

;; Convert letter grade to grade points
(define-private (grade-to-points (grade (string-ascii 2)))
  (if (is-eq grade "A")
    grade-a
    (if (is-eq grade "A-")
      grade-a-minus
      (if (is-eq grade "B+")
        grade-b-plus
        (if (is-eq grade "B")
          grade-b
          (if (is-eq grade "B-")
            grade-b-minus
            (if (is-eq grade "C+")
              grade-c-plus
              (if (is-eq grade "C")
                grade-c
                (if (is-eq grade "C-")
                  grade-c-minus
                  (if (is-eq grade "D+")
                    grade-d-plus
                    (if (is-eq grade "D")
                      grade-d
                      grade-f
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)

;; Validate grade format
(define-private (is-valid-grade (grade (string-ascii 2)))
  (or 
    (is-eq grade "A") (is-eq grade "A-") (is-eq grade "B+") (is-eq grade "B") (is-eq grade "B-")
    (is-eq grade "C+") (is-eq grade "C") (is-eq grade "C-") (is-eq grade "D+") (is-eq grade "D") (is-eq grade "F")
  )
)

;; Award grade and credits
(define-public (award-grade (student principal) (course-id (string-ascii 20)) (grade (string-ascii 2)))
  (let (
    (course-data (unwrap! (map-get? course-info course-id) err-course-not-found))
    (course-credit-hours (get credit-hours course-data))
    (course-instructor (get instructor course-data))
    (is-instructor (default-to false (map-get? instructor-permissions tx-sender)))
    (grade-points (grade-to-points grade))
    (current-courses (default-to (list) (map-get? student-courses student)))
    (current-gpa-data (unwrap! (map-get? student-gpa-data student) err-not-found))
    (current-credits (default-to u0 (map-get? student-credits student)))
  )
    ;; Validate permissions
    (asserts! (or (is-eq tx-sender contract-owner) (and is-instructor (is-eq tx-sender course-instructor))) err-owner-only)
    ;; Validate inputs
    (asserts! (is-some (map-get? student-credits student)) err-not-found)
    (asserts! (is-valid-grade grade) err-invalid-grade)
    (asserts! (> (len course-id) u0) err-invalid-amount)
    ;; Check if student already has grade for this course
    (asserts! (is-none (map-get? course-grades {student: student, course: course-id})) err-already-exists)
    
    ;; Calculate credits awarded based on grade (A=full credits, B=80%, C=60%, D=40%, F=0%)
    (let (
      (credits-awarded 
        (if (>= grade-points grade-a) course-credit-hours
          (if (>= grade-points grade-b) (/ (* course-credit-hours u80) u100)
            (if (>= grade-points grade-c) (/ (* course-credit-hours u60) u100)
              (if (>= grade-points grade-d) (/ (* course-credit-hours u40) u100)
                u0
              )
            )
          )
        )
      )
      (updated-courses (unwrap! (as-max-len? (append current-courses course-id) u50) err-invalid-amount))
      (new-total-grade-points (+ (get total-grade-points current-gpa-data) (* grade-points course-credit-hours)))
      (new-total-credit-hours (+ (get total-credit-hours current-gpa-data) course-credit-hours))
      (new-gpa (if (> new-total-credit-hours u0) (/ new-total-grade-points new-total-credit-hours) u0))
    )
      
      ;; Store grade information
      (map-set course-grades 
        {student: student, course: course-id} 
        {grade: grade, grade-points: grade-points, credit-hours: course-credit-hours, credits-awarded: credits-awarded}
      )
      
      ;; Update student courses list
      (map-set student-courses student updated-courses)
      
      ;; Update student credits
      (map-set student-credits student (+ current-credits credits-awarded))
      
      ;; Update GPA data
      (map-set student-gpa-data student 
        {total-grade-points: new-total-grade-points, total-credit-hours: new-total-credit-hours, gpa: new-gpa}
      )
      
      ;; Update total credits
      (var-set total-credits (+ (var-get total-credits) credits-awarded))
      
      (ok true)
    )
  )
)

;; Award credits to a student (legacy function)
(define-public (award-credits (student principal) (amount uint) (achievement (string-ascii 50)))
  (let (
    (current-credits (default-to u0 (map-get? student-credits student)))
    (is-instructor (default-to false (map-get? instructor-permissions tx-sender)))
    (current-achievements (default-to (list) (map-get? student-achievements student)))
    (updated-achievements (unwrap! (as-max-len? (append current-achievements achievement) u20) err-invalid-amount))
  )
    (asserts! (or (is-eq tx-sender contract-owner) is-instructor) err-owner-only)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (is-some (map-get? student-credits student)) err-not-found)
    (asserts! (> (len achievement) u0) err-invalid-amount)
    
    ;; Update student credits
    (map-set student-credits student (+ current-credits amount))
    
    ;; Add achievement to student record
    (map-set student-achievements student updated-achievements)
    
    ;; Update achievement type counter
    (map-set achievement-types achievement (+ (default-to u0 (map-get? achievement-types achievement)) u1))
    
    ;; Update total credits
    (var-set total-credits (+ (var-get total-credits) amount))
    
    (ok true)
  )
)

;; Transfer credits between students
(define-public (transfer-credits (recipient principal) (amount uint))
  (let (
    (sender-credits (default-to u0 (map-get? student-credits tx-sender)))
    (recipient-credits (default-to u0 (map-get? student-credits recipient)))
  )
    (asserts! (>= sender-credits amount) err-insufficient-credits)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (is-some (map-get? student-credits recipient)) err-not-found)
    
    ;; Update sender credits
    (map-set student-credits tx-sender (- sender-credits amount))
    
    ;; Update recipient credits
    (map-set student-credits recipient (+ recipient-credits amount))
    
    (ok true)
  )
)

;; Redeem credits for rewards
(define-public (redeem-credits (amount uint))
  (let (
    (current-credits (default-to u0 (map-get? student-credits tx-sender)))
  )
    (asserts! (>= current-credits amount) err-insufficient-credits)
    (asserts! (> amount u0) err-invalid-amount)
    
    ;; Deduct credits from student
    (map-set student-credits tx-sender (- current-credits amount))
    
    ;; Update total credits
    (var-set total-credits (- (var-get total-credits) amount))
    
    (ok true)
  )
)

;; Read-only Functions

;; Get student credit balance
(define-read-only (get-student-credits (student principal))
  (ok (default-to u0 (map-get? student-credits student)))
)

;; Get student achievements
(define-read-only (get-student-achievements (student principal))
  (ok (default-to (list) (map-get? student-achievements student)))
)

;; Get student GPA (returns GPA * 100 for precision)
(define-read-only (get-student-gpa (student principal))
  (match (map-get? student-gpa-data student)
    gpa-data (ok (get gpa gpa-data))
    err-not-found
  )
)

;; Get student GPA data (detailed)
(define-read-only (get-student-gpa-data (student principal))
  (match (map-get? student-gpa-data student)
    gpa-data (ok gpa-data)
    err-not-found
  )
)

;; Get course grade for student
(define-read-only (get-course-grade (student principal) (course-id (string-ascii 20)))
  (match (map-get? course-grades {student: student, course: course-id})
    grade-data (ok grade-data)
    err-not-found
  )
)

;; Get student courses
(define-read-only (get-student-courses (student principal))
  (ok (default-to (list) (map-get? student-courses student)))
)

;; Get course information
(define-read-only (get-course-info (course-id (string-ascii 20)))
  (match (map-get? course-info course-id)
    course-data (ok course-data)
    err-course-not-found
  )
)

;; Get total credits in system
(define-read-only (get-total-credits)
  (ok (var-get total-credits))
)

;; Get total students registered
(define-read-only (get-total-students)
  (ok (var-get total-students))
)

;; Get total courses created
(define-read-only (get-total-courses)
  (ok (var-get total-courses))
)

;; Get achievement type count
(define-read-only (get-achievement-count (achievement-type (string-ascii 50)))
  (ok (default-to u0 (map-get? achievement-types achievement-type)))
)

;; Check if address is an instructor
(define-read-only (is-instructor (address principal))
  (ok (default-to false (map-get? instructor-permissions address)))
)