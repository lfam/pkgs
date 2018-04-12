;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016, 2017 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages ssh)
  #:use-module (guix packages) ; package-input-rewriting
  #:use-module (guix download) ; url-fetch
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages tls)
  #:use-module (srfi srfi-1))

; This is required for Python 3.5. With Python 3.6, this can be removed.
(define libressl-2.5
  (package (inherit libressl)
    (name "libressl")
    (version "2.5.5")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://openbsd/LibreSSL/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "1i77viqy1afvbr392npk9v54k9zhr9zq2vhv6pliza22b0ymwzz5"))))))

(define libressl-instead-of-openssl
  (package-input-rewriting `((,openssl . ,libressl-2.5))))

;; This is OpenSSH built with LibreSSL instead of OpenSSL.
;; XXX LibreSSL 2.6 is not compatible with Python 3.6. And I don't think
;; we need to rewrite the entire dependency graph anyways; does openssh
;; refer to Python after it's built? Or any other openssl linkages?
;(define-public openssh-libressl
;  (package
;    (inherit (libressl-instead-of-openssl openssh))
;    (name "openssh-libressl")))

(define-public openssh-libressl
  (package
    (inherit openssh)
    (name "openssh-libressl")
    (inputs
     `(("libressl" ,libressl)
       ,@(alist-delete "openssl" (package-inputs openssh))))))
