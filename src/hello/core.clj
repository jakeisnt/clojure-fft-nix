(ns hello.core
  (:require
    [clojure.string :as string]
    [tesser.core :as t]
    [clojure.core.matrix :as m])
  (:gen-class))


(defn -main
  [& args]

  (let
    [k 7
     n 10000

     ;; k * k matrix of zeroes
     zero (m/zero-matrix k k)
     ;;
     vecs (for [_ (range n)] (shuffle (range k)))
     a (->> vecs
            (map m/permutation-matrix)
            (reduce m/add zero))
     b (->> (t/map m/permutation-matrix)
            (t/reduce m/add zero)
            (t/tesser [vecs]))
     matrices-equal (if (= a b) "Yes" "No")]
    (println (str "\n\nAre a and b equal? " matrices-equal "\n"))
    (m/pm a))

  (println (str "Hello from " (string/upper-case "clojure!!!"))))
