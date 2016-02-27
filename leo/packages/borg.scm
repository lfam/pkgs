;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages borg)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls))

(define-public borg
  (package
    (name "borg")
    (version "1.0.0rc1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "borgbackup" version))
              (sha256
               (base32
                "1iarvw9im183lsdmdp5ny1q5vs0iza60886y6mng76qwdg8m1j0g"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         ;; The build process needs PYTHON_EGG_CACHE to be writeable.
         (add-after 'unpack 'set-PYTHON_EGG_CACHE
           (lambda _ (setenv "PYTHON_EGG_CACHE" "/tmp")))
         (add-before 'build 'set-openssl-prefix
           (lambda* (#:key inputs #:allow-other-keys)
             (setenv "BORG_OPENSSL_PREFIX" (assoc-ref inputs "openssl"))
             #t))
         (add-before 'build 'set-lz4-prefix
           (lambda* (#:key inputs #:allow-other-keys)
             (setenv "BORG_LZ4_PREFIX" (assoc-ref inputs "lz4"))
             #t))
         (add-after 'install 'docs
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (man (string-append out "/share/man/man1")))
               (zero? (system* "make" "-C" "docs" "man"))
               (install-file "docs/_build/man/borg.1" man)))))))
    (native-inputs
     `(("python-setuptools-scm" ,python-setuptools-scm)
       ;; For building the documentation.
       ("python-sphinx" ,python-sphinx)
       ("python-sphinx-rtd-theme" ,python-sphinx-rtd-theme)))
    (inputs
     `(("acl" ,acl)
       ("lz4" ,lz4)
       ("openssl" ,openssl)
       ("python-msgpack" ,python-msgpack)

       ;; incompatible with llfuse > 0.41
       ;; Check again for borg > 1.0.0rc1
       ("python-llfuse-0.41" ,python-llfuse)))
    (synopsis "Deduplicated, encrypted, authenticated and compressed backups")
    (description "Borg is a deduplicating backup program.  Optionally, it
supports compression and authenticated encryption.  The main goal of Borg is to
provide an efficient and secure way to backup data.  The data deduplication
technique used makes Borg suitable for daily backups since only changes are
stored.  The authenticated encryption technique makes it suitable for backups
to not fully trusted targets.")
    (home-page "https://borgbackup.github.io/borgbackup/")
    (license license:bsd-3)))
