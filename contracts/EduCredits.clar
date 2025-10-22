;; EduCredits - Academic Achievement Token System with Multi-Institution Support and NFT Badges
;; A blockchain-based system for tracking and rewarding academic achievements with grade integration, cross-institutional support, and unique NFT achievement badges

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
(define-constant err-institution-not-found (err u109))
(define-constant err-institution-exists (err u110))
(define-constant err-institution-not-recognized (err u111))
(define-constant err-invalid-institution-id (err u112))
(define-constant err-transfer-not-allowed (err u113))
(define-constant err-nft-not-found (err u114))
(define-constant err-nft-already-minted (err u115))
(define-constant err-milestone-not-met (err u116))
(define-constant err-invalid-milestone-type (err u117))
(define-constant err-unauthorized (err u118))

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

;; NFT Trait
(define-non-fungible-token achievement-badge uint)

;; Data Variables
(define-data-var total-credits uint u0)
(define-data-var total-students uint u0)
(define-data-var total-courses uint u0)
(define-data-var total-institutions uint u0)
(define-data-var nft-id-counter uint u0)

;; Data Maps - Original
(define-map student-credits principal uint)
(define-map student-achievements principal (list 20 (string-ascii 50)))
(define-map achievement-types (string-ascii 50) uint)
(define-map instructor-permissions principal bool)

;; Grade Integration Maps - Original
(define-map student-courses principal (list 50 (string-ascii 20)))
(define-map course-grades {student: principal, course: (string-ascii 20)} {grade: (string-ascii 2), grade-points: uint, credit-hours: uint, credits-awarded: uint})
(define-map course-info (string-ascii 20) {name: (string-ascii 50), credit-hours: uint, instructor: principal})
(define-map student-gpa-data principal {total-grade-points: uint, total-credit-hours: uint, gpa: uint})

;; Multi-Institution Maps
(define-map institutions (string-ascii 10) {name: (string-ascii 100), admin: principal, accreditation-level: uint, active: bool})
(define-map institution-partnerships {institution-a: (string-ascii 10), institution-b: (string-ascii 10)} {recognized: bool, transfer-rate: uint})
(define-map student-institution principal (string-ascii 10))
(define-map instructor-institution principal (string-ascii 10))
(define-map course-institution (string-ascii 20) (string-ascii 10))
(define-map institution-credits (string-ascii 10) uint)
(define-map cross-institutional-transfers {from-institution: (string-ascii 10), to-institution: (string-ascii 10)} uint)

;; NFT Achievement Badge Maps
(define-map nft-metadata uint {
  milestone-type: (string-ascii 30),
  description: (string-ascii 200),
  institution: (string-ascii 10),
  awarded-at: uint,
  metadata-uri: (optional (string-ascii 256))
})
(define-map student-nft-badges principal (list 50 uint))
(define-map milestone-achievements {student: principal, milestone-type: (string-ascii 30)} bool)
(define-map institution-nft-count (string-ascii 10) uint)

;; Public Functions

;; Register a new institution
(define-public (register-institution (institution-id (string-ascii 10)) (name (string-ascii 100)) (admin principal) (accreditation-level uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> (len institution-id) u0) err-invalid-institution-id)
    (asserts! (<= (len institution-id) u10) err-invalid-institution-id)
    (asserts! (> (len name) u0) err-invalid-amount)
    (asserts! (<= (len name) u100) err-invalid-amount)
    (asserts! (<= accreditation-level u5) err-invalid-amount)
    (asserts! (> accreditation-level u0) err-invalid-amount)
    (asserts! (is-standard admin) err-invalid-amount)
    (asserts! (is-none (map-get? institutions institution-id)) err-institution-exists)
    
    (map-set institutions institution-id {
      name: name,
      admin: admin,
      accreditation-level: accreditation-level,
      active: true
    })
    (map-set institution-credits institution-id u0)
    (map-set institution-nft-count institution-id u0)
    (var-set total-institutions (+ (var-get total-institutions) u1))
    (ok true)
  )
)

;; Establish partnership between institutions
(define-public (establish-partnership (institution-a (string-ascii 10)) (institution-b (string-ascii 10)) (transfer-rate uint))
  (let (
    (inst-a-data (unwrap! (map-get? institutions institution-a) err-institution-not-found))
    (inst-b-data (unwrap! (map-get? institutions institution-b) err-institution-not-found))
    (is-admin-a (is-eq tx-sender (get admin inst-a-data)))
    (is-admin-b (is-eq tx-sender (get admin inst-b-data)))
  )
    (asserts! (or (is-eq tx-sender contract-owner) is-admin-a is-admin-b) err-owner-only)
    (asserts! (not (is-eq institution-a institution-b)) err-invalid-amount)
    (asserts! (<= transfer-rate u100) err-invalid-amount)
    (asserts! (get active inst-a-data) err-institution-not-found)
    (asserts! (get active inst-b-data) err-institution-not-found)
    
    ;; Set bidirectional partnership
    (map-set institution-partnerships {institution-a: institution-a, institution-b: institution-b} 
      {recognized: true, transfer-rate: transfer-rate})
    (map-set institution-partnerships {institution-a: institution-b, institution-b: institution-a} 
      {recognized: true, transfer-rate: transfer-rate})
    
    (ok true)
  )
)

;; Register a student with institution
(define-public (register-student (student principal) (institution-id (string-ascii 10)))
  (let (
    (institution-data (unwrap! (map-get? institutions institution-id) err-institution-not-found))
    (is-admin (is-eq tx-sender (get admin institution-data)))
  )
    (asserts! (or (is-eq tx-sender contract-owner) is-admin) err-owner-only)
    (asserts! (get active institution-data) err-institution-not-found)
    (asserts! (is-none (map-get? student-credits student)) err-already-exists)
    
    (map-set student-credits student u0)
    (map-set student-gpa-data student {total-grade-points: u0, total-credit-hours: u0, gpa: u0})
    (map-set student-institution student institution-id)
    (var-set total-students (+ (var-get total-students) u1))
    (ok true)
  )
)

;; Grant instructor permissions with institution
(define-public (grant-instructor-permission (instructor principal) (institution-id (string-ascii 10)))
  (let (
    (institution-data (unwrap! (map-get? institutions institution-id) err-institution-not-found))
    (is-admin (is-eq tx-sender (get admin institution-data)))
  )
    (asserts! (or (is-eq tx-sender contract-owner) is-admin) err-owner-only)
    (asserts! (get active institution-data) err-institution-not-found)
    (asserts! (not (is-eq instructor contract-owner)) err-invalid-amount)
    
    (map-set instructor-permissions instructor true)
    (map-set instructor-institution instructor institution-id)
    (ok true)
  )
)

;; Create a course with institution
(define-public (create-course (course-id (string-ascii 20)) (course-name (string-ascii 50)) (credit-hours uint) (institution-id (string-ascii 10)))
  (let (
    (institution-data (unwrap! (map-get? institutions institution-id) err-institution-not-found))
    (instructor-inst (map-get? instructor-institution tx-sender))
    (is-instructor (default-to false (map-get? instructor-permissions tx-sender)))
    (is-admin (is-eq tx-sender (get admin institution-data)))
  )
    (asserts! (or (is-eq tx-sender contract-owner) is-admin (and is-instructor (is-eq (some institution-id) instructor-inst))) err-owner-only)
    (asserts! (> (len course-id) u0) err-invalid-amount)
    (asserts! (<= (len course-id) u20) err-invalid-amount)
    (asserts! (> (len course-name) u0) err-invalid-amount)
    (asserts! (<= (len course-name) u50) err-invalid-amount)
    (asserts! (and (> credit-hours u0) (<= credit-hours u6)) err-invalid-credit-hours)
    (asserts! (is-none (map-get? course-info course-id)) err-course-exists)
    (asserts! (get active institution-data) err-institution-not-found)
    
    (map-set course-info course-id {name: course-name, credit-hours: credit-hours, instructor: tx-sender})
    (map-set course-institution course-id institution-id)
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
    (course-institution-id (unwrap! (map-get? course-institution course-id) err-course-not-found))
    (student-institution-id (unwrap! (map-get? student-institution student) err-not-found))
    (course-credit-hours (get credit-hours course-data))
    (course-instructor (get instructor course-data))
    (instructor-inst (map-get? instructor-institution tx-sender))
    (is-instructor (default-to false (map-get? instructor-permissions tx-sender)))
    (institution-data (unwrap! (map-get? institutions course-institution-id) err-institution-not-found))
    (is-admin (is-eq tx-sender (get admin institution-data)))
    (grade-points (grade-to-points grade))
    (current-courses (default-to (list) (map-get? student-courses student)))
    (current-gpa-data (unwrap! (map-get? student-gpa-data student) err-not-found))
    (current-credits (default-to u0 (map-get? student-credits student)))
    (current-inst-credits (default-to u0 (map-get? institution-credits course-institution-id)))
  )
    ;; Validate permissions
    (asserts! (or (is-eq tx-sender contract-owner) is-admin 
                  (and is-instructor (is-eq tx-sender course-instructor) (is-eq (some course-institution-id) instructor-inst))) err-owner-only)
    ;; Validate inputs
    (asserts! (is-some (map-get? student-credits student)) err-not-found)
    (asserts! (is-valid-grade grade) err-invalid-grade)
    (asserts! (> (len course-id) u0) err-invalid-amount)
    (asserts! (get active institution-data) err-institution-not-found)
    ;; Check if student already has grade for this course
    (asserts! (is-none (map-get? course-grades {student: student, course: course-id})) err-already-exists)
    
    ;; Calculate credits awarded based on grade
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
      
      ;; Update institution credits
      (map-set institution-credits course-institution-id (+ current-inst-credits credits-awarded))
      
      ;; Update total credits
      (var-set total-credits (+ (var-get total-credits) credits-awarded))
      
      (ok true)
    )
  )
)

;; Cross-institutional credit transfer
(define-public (transfer-credits-cross-institution (recipient principal) (amount uint))
  (let (
    (sender-credits (default-to u0 (map-get? student-credits tx-sender)))
    (recipient-credits (default-to u0 (map-get? student-credits recipient)))
    (sender-institution (unwrap! (map-get? student-institution tx-sender) err-not-found))
    (recipient-institution (unwrap! (map-get? student-institution recipient) err-not-found))
    (partnership (map-get? institution-partnerships {institution-a: sender-institution, institution-b: recipient-institution}))
    (transfer-count-key {from-institution: sender-institution, to-institution: recipient-institution})
    (current-transfer-count (default-to u0 (map-get? cross-institutional-transfers transfer-count-key)))
  )
    (asserts! (>= sender-credits amount) err-insufficient-credits)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (is-some (map-get? student-credits recipient)) err-not-found)
    
    ;; Check if institutions are different and have partnership
    (if (is-eq sender-institution recipient-institution)
      ;; Same institution transfer (normal transfer)
      (begin
        (map-set student-credits tx-sender (- sender-credits amount))
        (map-set student-credits recipient (+ recipient-credits amount))
        (ok true)
      )
      ;; Cross-institutional transfer
      (match partnership
        partnership-data
        (let (
          (transfer-rate (get transfer-rate partnership-data))
          (adjusted-amount (/ (* amount transfer-rate) u100))
        )
          (asserts! (get recognized partnership-data) err-institution-not-recognized)
          (asserts! (> adjusted-amount u0) err-transfer-not-allowed)
          
          ;; Update sender credits
          (map-set student-credits tx-sender (- sender-credits amount))
          
          ;; Update recipient credits with adjusted amount
          (map-set student-credits recipient (+ recipient-credits adjusted-amount))
          
          ;; Update transfer statistics
          (map-set cross-institutional-transfers transfer-count-key (+ current-transfer-count u1))
          
          (ok true)
        )
        err-institution-not-recognized
      )
    )
  )
)

;; Award credits to a student (legacy function)
(define-public (award-credits (student principal) (amount uint) (achievement (string-ascii 50)))
  (let (
    (current-credits (default-to u0 (map-get? student-credits student)))
    (student-inst (unwrap! (map-get? student-institution student) err-not-found))
    (instructor-inst (map-get? instructor-institution tx-sender))
    (is-instructor (default-to false (map-get? instructor-permissions tx-sender)))
    (institution-data (unwrap! (map-get? institutions student-inst) err-institution-not-found))
    (is-admin (is-eq tx-sender (get admin institution-data)))
    (current-achievements (default-to (list) (map-get? student-achievements student)))
    (updated-achievements (unwrap! (as-max-len? (append current-achievements achievement) u20) err-invalid-amount))
    (current-inst-credits (default-to u0 (map-get? institution-credits student-inst)))
  )
    (asserts! (or (is-eq tx-sender contract-owner) is-admin 
                  (and is-instructor (is-eq (some student-inst) instructor-inst))) err-owner-only)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (is-some (map-get? student-credits student)) err-not-found)
    (asserts! (> (len achievement) u0) err-invalid-amount)
    (asserts! (<= (len achievement) u50) err-invalid-amount)
    (asserts! (get active institution-data) err-institution-not-found)
    
    ;; Update student credits
    (map-set student-credits student (+ current-credits amount))
    
    ;; Add achievement to student record
    (map-set student-achievements student updated-achievements)
    
    ;; Update achievement type counter
    (map-set achievement-types achievement (+ (default-to u0 (map-get? achievement-types achievement)) u1))
    
    ;; Update institution credits
    (map-set institution-credits student-inst (+ current-inst-credits amount))
    
    ;; Update total credits
    (var-set total-credits (+ (var-get total-credits) amount))
    
    (ok true)
  )
)

;; Transfer credits between students (original function - now supports cross-institutional)
(define-public (transfer-credits (recipient principal) (amount uint))
  (transfer-credits-cross-institution recipient amount)
)

;; Redeem credits for rewards
(define-public (redeem-credits (amount uint))
  (let (
    (current-credits (default-to u0 (map-get? student-credits tx-sender)))
    (student-inst (unwrap! (map-get? student-institution tx-sender) err-not-found))
    (current-inst-credits (default-to u0 (map-get? institution-credits student-inst)))
  )
    (asserts! (>= current-credits amount) err-insufficient-credits)
    (asserts! (> amount u0) err-invalid-amount)
    
    ;; Deduct credits from student
    (map-set student-credits tx-sender (- current-credits amount))
    
    ;; Update institution credits
    (map-set institution-credits student-inst (- current-inst-credits amount))
    
    ;; Update total credits
    (var-set total-credits (- (var-get total-credits) amount))
    
    (ok true)
  )
)

;; NFT Achievement Badge Functions

;; Mint NFT achievement badge
(define-public (mint-achievement-badge 
  (student principal) 
  (milestone-type (string-ascii 30)) 
  (description (string-ascii 200))
  (metadata-uri (optional (string-ascii 256))))
  (let (
    (student-inst (unwrap! (map-get? student-institution student) err-not-found))
    (institution-data (unwrap! (map-get? institutions student-inst) err-institution-not-found))
    (instructor-inst (map-get? instructor-institution tx-sender))
    (is-instructor (default-to false (map-get? instructor-permissions tx-sender)))
    (is-admin (is-eq tx-sender (get admin institution-data)))
    (new-nft-id (+ (var-get nft-id-counter) u1))
    (current-badges (default-to (list) (map-get? student-nft-badges student)))
    (milestone-key {student: student, milestone-type: milestone-type})
    (current-inst-nft-count (default-to u0 (map-get? institution-nft-count student-inst)))
    (current-block-height stacks-block-height)
  )
    ;; Validate permissions
    (asserts! (or (is-eq tx-sender contract-owner) is-admin 
                  (and is-instructor (is-eq (some student-inst) instructor-inst))) err-owner-only)
    ;; Validate inputs
    (asserts! (is-some (map-get? student-credits student)) err-not-found)
    (asserts! (> (len milestone-type) u0) err-invalid-milestone-type)
    (asserts! (<= (len milestone-type) u30) err-invalid-milestone-type)
    (asserts! (> (len description) u0) err-invalid-amount)
    (asserts! (<= (len description) u200) err-invalid-amount)
    (asserts! (get active institution-data) err-institution-not-found)
    ;; Check if student already has this milestone badge
    (asserts! (is-none (map-get? milestone-achievements milestone-key)) err-nft-already-minted)
    
    ;; Validate metadata-uri if provided
    (match metadata-uri
      uri (asserts! (<= (len uri) u256) err-invalid-amount)
      true
    )
    
    ;; Mint NFT to student
    (try! (nft-mint? achievement-badge new-nft-id student))
    
    ;; Store NFT metadata
    (map-set nft-metadata new-nft-id {
      milestone-type: milestone-type,
      description: description,
      institution: student-inst,
      awarded-at: current-block-height,
      metadata-uri: (if (is-some metadata-uri) metadata-uri none)
    })
    
    ;; Add NFT to student's badge list
    (let (
      (updated-badges (unwrap! (as-max-len? (append current-badges new-nft-id) u50) err-invalid-amount))
    )
      (map-set student-nft-badges student updated-badges)
    )
    
    ;; Mark milestone as achieved
    (map-set milestone-achievements milestone-key true)
    
    ;; Update institution NFT count
    (map-set institution-nft-count student-inst (+ current-inst-nft-count u1))
    
    ;; Increment NFT counter
    (var-set nft-id-counter new-nft-id)
    
    (ok new-nft-id)
  )
)

;; Transfer NFT achievement badge
(define-public (transfer-achievement-badge (nft-id uint) (recipient principal))
  (let (
    (token-owner (unwrap! (nft-get-owner? achievement-badge nft-id) err-nft-not-found))
    (nft-meta (unwrap! (map-get? nft-metadata nft-id) err-nft-not-found))
    (recipient-inst-opt (map-get? student-institution recipient))
  )
    ;; Validate sender is the owner
    (asserts! (is-eq tx-sender token-owner) err-unauthorized)
    ;; Validate recipient is a registered student
    (asserts! (is-some recipient-inst-opt) err-not-found)
    
    ;; Transfer NFT
    (try! (nft-transfer? achievement-badge nft-id tx-sender recipient))
    
    ;; Update sender's badge list
    (let (
      (sender-badges (default-to (list) (map-get? student-nft-badges tx-sender)))
      (updated-sender-badges (filter-nft-from-list sender-badges nft-id))
    )
      (map-set student-nft-badges tx-sender updated-sender-badges)
    )
    
    ;; Update recipient's badge list
    (let (
      (recipient-badges (default-to (list) (map-get? student-nft-badges recipient)))
      (updated-recipient-badges (unwrap! (as-max-len? (append recipient-badges nft-id) u50) err-invalid-amount))
    )
      (map-set student-nft-badges recipient updated-recipient-badges)
    )
    
    (ok true)
  )
)

;; Helper function to filter NFT from list
(define-private (filter-nft-from-list (nft-list (list 50 uint)) (nft-to-remove uint))
  (filter is-not-target nft-list)
)

;; Helper function for filtering
(define-private (is-not-target (nft-id uint))
  (not (is-eq nft-id nft-id))
)

;; Auto-mint badge based on milestone criteria
(define-public (auto-mint-milestone-badge (student principal) (milestone-type (string-ascii 30)))
  (let (
    (student-data (unwrap! (map-get? student-gpa-data student) err-not-found))
    (credit-balance (default-to u0 (map-get? student-credits student)))
    (student-gpa (get gpa student-data))
    (milestone-met (check-milestone-criteria credit-balance student-gpa milestone-type))
  )
    (asserts! milestone-met err-milestone-not-met)
    
    ;; Mint badge with predefined descriptions
    (let (
      (description (get-milestone-description milestone-type))
      (validated-description (unwrap! description err-invalid-milestone-type))
    )
      (mint-achievement-badge student milestone-type validated-description none)
    )
  )
)

;; Check if milestone criteria is met
(define-private (check-milestone-criteria (credits uint) (gpa uint) (milestone-type (string-ascii 30)))
  (if (is-eq milestone-type "DEAN_LIST")
    (>= gpa u350)  ;; 3.5 GPA or higher
    (if (is-eq milestone-type "HONORS_GRADUATE")
      (and (>= gpa u350) (>= credits u120))  ;; 3.5 GPA and 120+ credits
      (if (is-eq milestone-type "SUMMA_CUM_LAUDE")
        (>= gpa u390)  ;; 3.9 GPA or higher
        (if (is-eq milestone-type "PERFECT_SEMESTER")
          (>= gpa u400)  ;; 4.0 GPA
          (if (is-eq milestone-type "CENTURY_CLUB")
            (>= credits u100)  ;; 100+ credits
            (if (is-eq milestone-type "RESEARCH_EXCELLENCE")
              (>= credits u50)  ;; Custom criteria
              false
            )
          )
        )
      )
    )
  )
)

;; Get milestone description
(define-private (get-milestone-description (milestone-type (string-ascii 30)))
  (if (is-eq milestone-type "DEAN_LIST")
    (some "Achieved Dean's List with GPA of 3.5 or higher")
    (if (is-eq milestone-type "HONORS_GRADUATE")
      (some "Graduated with Honors: 3.5 GPA and 120+ credits")
      (if (is-eq milestone-type "SUMMA_CUM_LAUDE")
        (some "Summa Cum Laude: Exceptional academic excellence with 3.9+ GPA")
        (if (is-eq milestone-type "PERFECT_SEMESTER")
          (some "Perfect Semester: Achieved 4.0 GPA")
          (if (is-eq milestone-type "CENTURY_CLUB")
            (some "Century Club: Earned 100+ academic credits")
            (if (is-eq milestone-type "RESEARCH_EXCELLENCE")
              (some "Research Excellence: Outstanding contribution to academic research")
              none
            )
          )
        )
      )
    )
  )
)

;; Read-only Functions

;; Get institution information
(define-read-only (get-institution-info (institution-id (string-ascii 10)))
  (match (map-get? institutions institution-id)
    institution-data (ok institution-data)
    err-institution-not-found
  )
)

;; Get partnership information
(define-read-only (get-partnership-info (institution-a (string-ascii 10)) (institution-b (string-ascii 10)))
  (ok (map-get? institution-partnerships {institution-a: institution-a, institution-b: institution-b}))
)

;; Get student institution
(define-read-only (get-student-institution (student principal))
  (ok (map-get? student-institution student))
)

;; Get instructor institution
(define-read-only (get-instructor-institution (instructor principal))
  (ok (map-get? instructor-institution instructor))
)

;; Get course institution
(define-read-only (get-course-institution (course-id (string-ascii 20)))
  (ok (map-get? course-institution course-id))
)

;; Get institution credits
(define-read-only (get-institution-credits (institution-id (string-ascii 10)))
  (ok (default-to u0 (map-get? institution-credits institution-id)))
)

;; Get cross-institutional transfer count
(define-read-only (get-cross-institutional-transfers (from-institution (string-ascii 10)) (to-institution (string-ascii 10)))
  (ok (default-to u0 (map-get? cross-institutional-transfers {from-institution: from-institution, to-institution: to-institution})))
)

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

;; Get total institutions registered
(define-read-only (get-total-institutions)
  (ok (var-get total-institutions))
)

;; Get achievement type count
(define-read-only (get-achievement-count (achievement-type (string-ascii 50)))
  (ok (default-to u0 (map-get? achievement-types achievement-type)))
)

;; Check if address is an instructor
(define-read-only (is-instructor (address principal))
  (ok (default-to false (map-get? instructor-permissions address)))
)

;; NFT Read-only Functions

;; Get NFT metadata
(define-read-only (get-nft-metadata (nft-id uint))
  (match (map-get? nft-metadata nft-id)
    metadata (ok metadata)
    err-nft-not-found
  )
)

;; Get student NFT badges
(define-read-only (get-student-nft-badges (student principal))
  (ok (default-to (list) (map-get? student-nft-badges student)))
)

;; Check if student has milestone badge
(define-read-only (has-milestone-badge (student principal) (milestone-type (string-ascii 30)))
  (ok (default-to false (map-get? milestone-achievements {student: student, milestone-type: milestone-type})))
)

;; Get institution NFT count
(define-read-only (get-institution-nft-count (institution-id (string-ascii 10)))
  (ok (default-to u0 (map-get? institution-nft-count institution-id)))
)

;; Get total NFTs minted
(define-read-only (get-total-nfts-minted)
  (ok (var-get nft-id-counter))
)

;; Get NFT owner
(define-read-only (get-nft-owner (nft-id uint))
  (ok (nft-get-owner? achievement-badge nft-id))
)

;; Get last token ID
(define-read-only (get-last-token-id)
  (ok (var-get nft-id-counter))
)

;; Get token URI (standard NFT function)
(define-read-only (get-token-uri (nft-id uint))
  (match (map-get? nft-metadata nft-id)
    metadata (ok (get metadata-uri metadata))
    err-nft-not-found
  )
)