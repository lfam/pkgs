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

(define-module (leo packages nicotine)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages music)
  #:use-module (gnu packages python))

(define-public nicotine+
 (package
   (name "nicotine+")
   (version "1.4.1")
   (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/Nicotine-Plus/nicotine-plus/"
                           "archive/" version ".tar.gz"))
       (sha256
        (base32
         "1mmpjwa4c78b8325kxc8z629fa23653cr459dywlw7lqdlcyyf0v"))))
   (build-system python-build-system)
   (arguments
    `(#:python ,python-2
      #:phases
      (modify-phases %standard-phases
        (add-after 'unpack 'disable-exit-dialog
          ;; Disable the dialog that asks, "Are you sure you want to quit?"
          (lambda _
            (substitute* "pynicotine/config.py"
              (("\\\"exitdialog\\\": 1") "\"exitdialog\": 0"))
            #t))
        (add-after 'unpack 'default-chat-room
          ;; Don't join the 'nicotine' chat room by default.
          (lambda _
            (substitute* "pynicotine/config.py"
              (("\\\"autojoin\\\": \\[\\\"nicotine\\\"\\],")
               "\"autojoin\": [\"\"],"))))
        (add-after 'unpack 'patch-installation-paths
          (lambda* (#:key outputs #:allow-other-keys)
            (let* ((out (assoc-ref %outputs "out"))
                   (prefix (string-append "\"" out "\"")))
              (substitute* "setup.py"
                (("sys.prefix") prefix))
              #t))))))
   (propagated-inputs
    `(("python2-mutagen" ,python2-mutagen)
      ("python2-pygtk" ,python2-pygtk)))
   (home-page "https://www.nicotine-plus.org/")
   (synopsis "Graphical Soulseek client")
   (description "Nicotine+ is a graphical client for the SoulSeek peer-to-peer
file-sharing system.")
   (license gpl3+)))
