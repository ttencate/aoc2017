#!/usr/bin/clojure

(require ['clojure.string :as 'string])

(defrecord Step [x y])
(defn turn-left [step]
  (->Step (- (:y step)) (:x step)))
(defn turn-right [step]
  (->Step (:y step) (- (:x step))))
(defn steps-to-try [step]
  [step (turn-left step) (turn-right step)])

(defrecord Pos [x y])
(defn plus [pos step] (->Pos (+ (:x pos) (:x step)) (+ (:y pos) (:y step))))

(defn char-at [lines pos]
  (get (get lines (:y pos)) (:x pos)))
(defn char-after-step [lines pos step]
  (char-at lines (plus pos step)))
(defn can-walk-on [char]
  (not= char \space))
(defn can-walk-at [lines pos]
  (can-walk-on (char-at lines pos)))

(defrecord State [pos step num-steps])
(defn find-start-state [lines]
  (->State (->Pos (string/index-of (get lines 0) "|") 0) (->Step 0 1) 1))
(defn find-next-step [lines cur-pos cur-step]
  (first (filter
           #(can-walk-at lines (plus cur-pos %))
           (steps-to-try cur-step))))
(defn find-next-state [lines cur-state]
  (let [next-step (find-next-step lines (:pos cur-state) (:step cur-state))]
    (if (nil? next-step)
      nil
      (let [next-pos (plus (:pos cur-state) next-step)]
        (let [next-num-steps (+ (:num-steps cur-state) 1)]
          (->State next-pos next-step next-num-steps))))))
(defn walk [lines]
  (take-while some? (iterate #(find-next-state lines %) (find-start-state lines))))

(let [lines (string/split-lines (slurp *in*))]
  (let [end-state (last (walk lines))]
    (println (:num-steps end-state))))
