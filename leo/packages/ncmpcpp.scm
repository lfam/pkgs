;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2021 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages ncmpcpp)
  #:use-module (gnu packages mpd)
  #:use-module (guix build-system gnu)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1)) ; for FOLD

(define-public ncmpcpp-without-taglib
  ;; ncmpcpp without the ability to edit music tags
  (package (inherit ncmpcpp)
    (name "ncmpcpp-without-taglib")
    (arguments
     (substitute-keyword-arguments (package-arguments ncmpcpp)
       ((#:modules modules %gnu-build-system-modules)
        `((srfi srfi-1)
          ,@modules))
       ((#:configure-flags flags)
        `(fold delete
               ,flags
               '("--with-taglib")))))
    (inputs (fold alist-delete
                  (package-inputs ncmpcpp)
                                  '("taglib")))))
