;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2022 Leo Famulari <leo@famulari.name>
;;;
;;; This file is NOT part of GNU Guix, but is supposed to be used with GNU
;;; Guix and thus has the same license.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (leo packages python2)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages gimp)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages python))

;;; Package definitions that remove Python 2 dependencies.

(define-public gimp-without-python
  ;; Gimp depends on Python 2, which is EOL. The upcoming Gimp 3,
  ;; released as 2.99.* will use Python 3.
  ;;
  ;; You will no longer be able to extend Gimp using Python scripts.
  (package (inherit gimp)
    (name "gimp-without-python")
    (arguments
     `(,@(substitute-keyword-arguments
           `(#:modules ((guix build gnu-build-system)
                        (guix build utils))
                        ,@(package-arguments gimp))
            ((#:configure-flags flags)
             `(append ,flags
                      (list "--disable-python")))
            ((#:phases phases)
             `(modify-phases ,phases
                (delete 'install-sitecustomize.py))))))
    (inputs
      (modify-inputs (package-inputs gimp)
        (delete "python" "python2-pygtk")))))
