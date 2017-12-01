;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages audio)
  #:use-module (guix packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages wxwidgets)
  #:use-module (srfi srfi-1))

;; I don't like Audacity with GTK3
(define-public audacity-gtk2
  (package (inherit audacity)
    (name "audacity-gtk2")
    (inputs
     `(("gtk" ,gtk+-2)
       ("wxwidgets" ,wxwidgets-gtk2)
       ,@(alist-delete "gtk"
           (alist-delete "wxwidgets"
             (package-inputs audacity)))))))
