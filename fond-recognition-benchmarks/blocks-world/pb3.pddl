(define (problem bw-pb3)
  (:domain blocks-domain)
  (:objects a b c d e f g h i j k l n m o - block)
  
  (:init (emptyhand) (ontable m) (on k m) (on f k) (clear f) (ontable h) (on e h) (on l e) (clear l) (ontable g) (on o g) (on n o) (on d n) (clear d) (ontable i) (on b i) (on c b) (on j c) (on a j) (clear a))
  (:goal (and (goal_state)))
)