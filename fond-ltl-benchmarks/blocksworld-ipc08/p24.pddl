(define (problem bw_15_24)
  (:domain blocks-domain)
  (:objects a b c d e f g h i j k l n m o - block)
  
  (:init (emptyhand) (ontable m) (on k m) (on f k) (clear f) (ontable h) (on e h) (on l e) (clear l) (ontable g) (on o g) (on n o) (on d n) (clear d) (ontable i) (on b i) (on c b) (on j c) (on a j) (clear a))
  
  ;(:goal (and (emptyhand) (ontable m) (on a m) (on j a) (on d j) (on e d) (on b e) (clear b) (ontable o) (on f o) (on n f) (clear n) (ontable c) (on l c) (on k l) (on g k) (on h g) (on i h) (clear i)))
  ;(:goal (and (emptyhand) (ontable m) (on a m) (on j a) (on d j) (on e d) (on o e) (clear o) (ontable b) (on f b) (on n f) (clear n) (ontable g) (on l g) (on k l) (on c k) (on h c) (on i h) (clear i)))
  ;(:goal (and (emptyhand) (ontable d) (on a d) (on j a) (on m j) (on f m) (on o f) (clear o) (ontable b) (on e b) (on n e) (clear n) (ontable g) (on l g) (on k l) (on i k) (on h i) (on c h) (clear c)))
  ;(:goal (and (emptyhand) (ontable d) (on a d) (on j a) (on m j) (on b m) (on o b) (clear o) (ontable f) (on e f) (on g e) (clear g) (ontable n) (on l n) (on h l) (on i h) (on k i) (on c k) (clear c)))
  ;(:goal (and (emptyhand) (ontable e) (on a e) (on b a) (on m b) (on j m) (on f j) (clear f) (ontable o) (on d o) (on g d) (clear g) (ontable i) (on l i) (on c l) (on n c) (on k n) (on h k) (clear h)))
  (:goal (and (emptyhand) (ontable e) (on f e) (on b f) (on o b) (on j o) (on a j) (clear a) (ontable m) (on d m) (on g d) (clear g) (ontable n) (on l n) (on c l) (on i c) (on k i) (on h k) (clear h)))
)
