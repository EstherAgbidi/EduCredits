;; EduCredits - Academic Achievement Token System
;; A blockchain-based system for tracking and rewarding academic achievements

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-insufficient-credits (err u103))
(define-constant err-invalid-amount (err u104))

;; Data Variables
(define-data-var total-credits uint u0)
(define-data-var total-students uint u0)

;; Data Maps
(define-map student-credits principal uint)
(define-map student-achievements principal (list 20 (string-ascii 50)))
(define-map achievement-types (string-ascii 50) uint)
(define-map instructor-permissions principal bool)

;; Public Functions

;; Register a new student
(define-public (register-student (student principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-none (map-get? student-credits student)) err-already-exists)
    (map-set student-credits student u0)
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

;; Award credits to a student
(define-public (award-credits (student principal) (amount uint) (achievement (string-ascii 50)))
  (let (
    (current-credits (default-to u0 (map-get? student-credits student)))
    (is-instructor (default-to false (map-get? instructor-permissions tx-sender)))
    (current-achievements (default-to (list) (map-get? student-achievements student)))
    (updated-achievements (as-max-len? (append current-achievements achievement) u20))
  )
    (asserts! (or (is-eq tx-sender contract-owner) is-instructor) err-owner-only)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (is-some (map-get? student-credits student)) err-not-found)
    (asserts! (> (len achievement) u0) err-invalid-amount)
    (asserts! (is-some updated-achievements) err-invalid-amount)
    
    ;; Update student credits
    (map-set student-credits student (+ current-credits amount))
    
    ;; Add achievement to student record
    (map-set student-achievements student (unwrap! updated-achievements err-invalid-amount))
    
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

;; Get total credits in system
(define-read-only (get-total-credits)
  (ok (var-get total-credits))
)

;; Get total students registered
(define-read-only (get-total-students)
  (ok (var-get total-students))
)

;; Get achievement type count
(define-read-only (get-achievement-count (achievement-type (string-ascii 50)))
  (ok (default-to u0 (map-get? achievement-types achievement-type)))
)

;; Check if address is an instructor
(define-read-only (is-instructor (address principal))
  (ok (default-to false (map-get? instructor-permissions address)))
)