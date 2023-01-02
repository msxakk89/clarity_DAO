;;          >> Stacks Inheritence Contract <<
;; The purpose of this contract is for a person to lock STX funds to be claimed by beneficiary in the future
;; The beneficiary is to be determined by the contract deplyer
;; The beneficiary can claim the funds only if pre-specified amount of time has passed
;; The person can claim back portion or whole amount of funds at any moment after deploying the contract
;; Noone except the contract deployer can claim before the time has passed
;; Noone except contract deployer or beneficiary can claim after the time has passed

(define-constant contract-deployer tx-sender)
(define-constant err-not-contract-deployer (err u100))
(define-constant err-unlock-before (err u101))
(define-constant err-no-tokens-deployed (err u102))
(define-constant err-already-unlocked (err u103))
(define-constant err-not-enough-minutes (err u104))
(define-constant err-not-beneficiary (err u105))
(define-constant err-not-deployer (err u106))
(define-constant err-banaficiary-early-claim (err u107))

(define-data-var beneficiary principal tx-sender)
(define-data-var unlock-height uint u0)
(define-data-var unlock-minutes uint u0)

(define-read-only (get-unlock-height) 
    (var-get unlock-height)
)
(define-read-only (get-unlock-minutes) 
    (var-get unlock-minutes)
)
(define-read-only (infer-block-hight-from-minutes (minutes uint))
    (+ block-height (/ minutes u10))
)
(define-read-only (get-beneficiary) 
    (var-get beneficiary)
)

(define-public (lock (new-beneficiary principal) (new-unlock-minutes uint) (amount uint))
    (begin 
    ;; make sure contract deployer is a tx sender
    (asserts! (is-eq tx-sender contract-deployer) err-not-contract-deployer)
    ;; make sure more than 0 mSTX is transfered to the contract
    (asserts! (> amount u0) err-no-tokens-deployed)
    ;; make sure that contract has not been alread ydeployed before
    (asserts! (is-eq (get-unlock-height) u0) err-already-unlocked)
    ;; make sure that a minimum lock period of 3 months has been used
    (asserts! (> new-unlock-minutes u131400) err-not-enough-minutes)
    ;; update the unlock minutes
    (var-set unlock-minutes new-unlock-minutes)
    ;; update the unlock height
    (var-set unlock-height (+ (get-unlock-height) (infer-block-hight-from-minutes (get-unlock-minutes))))
    ;; make sure the unlock height is in the future
    (asserts! (> (get-unlock-height) block-height) err-unlock-before)
    (var-set beneficiary new-beneficiary)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender))) ;; as-contract will evaluate as a principal of the contract
    (ok true)
     )
)

(define-public (claim_beneficiary) 
    (begin 
    ;; make sure the claimant is a beneficiary
    (asserts! (is-eq (get-beneficiary) tx-sender) err-not-beneficiary)
    ;; make sure beneficiary doesn't claim before the unlock time
    (asserts! (< (get-unlock-height) block-height) err-banaficiary-early-claim)
    ;; notice that tx-sender inside as-contract is different from tx-sender outside the contract!
    (as-contract (stx-transfer? (stx-get-balance tx-sender) tx-sender (get-beneficiary))) 
    )
)

(define-public (claim_deployer) 
    (begin 
    ;; make sure the claimant is deployer
    (asserts! (is-eq contract-deployer tx-sender) err-not-deployer)
    (as-contract (stx-transfer? (stx-get-balance tx-sender) tx-sender contract-deployer)) 
    )
)