(define (problem bw-pb4)
  (:domain blocks-domain)
  (:objects a b c d e f g h i j k l n m o - block)  
  (:init (emptyhand) (ontable a) (on k a) (on d k) (clear d) (ontable h) (on e h) (on l e) (clear l) (ontable g) (on o g) (on n o) (on f n) (clear f) (ontable i) (on b i) (on c b) (clear c) (ontable j) (on m j) (clear m))
  (:goal (and (goal_state)))
)

