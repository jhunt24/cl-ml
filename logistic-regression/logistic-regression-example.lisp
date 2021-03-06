;;;; Martin Kersner, m.kersner@gmail.com
;;;; 2016/06/07
;;;;
;;;; Logistic regression example for two dimensional data with binary labels.

(defun compute-y-coordinate (weights x)
  (let ((w0 (nth 0 weights))
        (w1 (nth 1 weights))
        (w2 (nth 2 weights)))

    (/ (- (- w0) (* w1 x)) w2)))

;;; Load data.
(defparameter *dataset-path* "datasets/logistic-regression/dataset_small.csv")
(defparameter *dataset* (matrix-from-data (read-csv *dataset-path*)))

;;; Data preprocessing.
(defparameter *label-col-idx* 2)
(defparameter *data*   (remove-col *dataset* *label-col-idx*))
(defparameter *labels* (nth-col *dataset* *label-col-idx*))

;(defparameter *mean* (mean-cols *data*))
;(defparameter *std* (std-cols *data* *mean*))
;(setf *data* (normalize *data* *mean* *std*))

;;; INITIALIZATION
(defparameter *logreg* (make-instance 'logistic-regression))

;;; Train model.
(defparameter *params*
  (generate-params '((num-epoch 50)
                     (lr        0.005))))
(fit *logreg* *data* *labels* *params*)

;;; Extract parameters of trained model.
(setf *weights*
  (nth 0 (matrix-data (transpose (get-weights *logreg*)))))

;;; Logistic regression computation.
;(defparameter *weights* (matrix-data (grad-ascent *data* *labels*)))
;(defparameter *weights* (matrix-data (grad-ascent *data* *labels* :lr 0.01)))
;(defparameter *weights* (matrix-data (grad-ascent *data* *labels* :lr 0.001 :max_iter 10)))

;;; Stochastic logistic regression.
;(defparameter *weights* (matrix-data (stochastic-grad-ascent *data* *labels*)))

;;; Processing weights for plotting decision boundary.
(defparameter *col-idx* 0)
(defparameter *x-min* (nth-col-min *data* *col-idx*))
(defparameter *x-max* (nth-col-max *data* *col-idx*))
(defparameter *y-min* (compute-y-coordinate *weights* *x-min*))
(defparameter *y-max* (compute-y-coordinate *weights* *x-max*))

;;; Denormalize points of decision boundary.
;(defparameter *mean-list* (matrix-data-peel *mean*))
;(defparameter *std-list* (matrix-data-peel *std*))
;(defparameter *mean-x* (car *mean-list*))
;(defparameter *mean-y* (cadr *mean-list*))
;(defparameter *std-x* (car *std-list*))
;(defparameter *std-y* (cadr *std-list*))
;(setf *x-min* (+ (* *x-min* *std-x*) *mean-x*))
;(setf *x-max* (+ (* *x-max* *std-x*) *mean-x*))
;(setf *y-min* (+ (* *y-min* *std-y*) *mean-y*))
;(setf *y-max* (+ (* *y-max* *std-y*) *mean-y*))

;;; Plot decision boundary.
(defparameter *fig* (make-instance 'figure
                                   :nokey t))
(xlabel *fig* "feature 1")
(ylabel *fig* "feature 2")
(arrow *fig* *x-min* *y-min* *x-max* *y-max* :nohead t)
(scatter *fig* (matrix-data *dataset*)
         :palette t
         :pt 7
         :ps 2
         :with 'points)
(show *fig*)
