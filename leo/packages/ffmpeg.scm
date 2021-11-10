;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2018, 2020, 2021 Leo Famulari <leo@famulari.name>
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

(define-module (leo packages ffmpeg)
  #:use-module (guix download)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build-system python)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages video))

(define-public ffmpeg-with-aac
  ;; FFmpeg with the libfdk AAC library.
  (package (inherit ffmpeg)
    (name "ffmpeg-with-aac")
    (arguments
     `(,@(substitute-keyword-arguments
           `(#:modules ((guix build gnu-build-system)
                        (guix build utils))
                        ,@(package-arguments ffmpeg))
            ((#:configure-flags flags)
             `(append ,flags
                      (list "--enable-libfdk-aac"
                            ;; libfdk is free, but incompatible with FFmpeg...
                            "--enable-nonfree")))
            ((#:phases phases)
             `(modify-phases ,phases
                (add-after 'unpack 'disable-banner
                  (lambda _
                    (substitute* "fftools/cmdutils.c"
                      (("int hide_banner = 0")
                        "int hide_banner = 1"))
                    #t)))))))
    (inputs
     `(("libfdk" ,libfdk)
       ,@(package-inputs ffmpeg)))))

(define-public python-ffmpeg-progress-yield
  (package
    (name "python-ffmpeg-progress-yield")
    (version "0.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "ffmpeg-progress-yield" version))
        (sha256
          (base32 "081qmjfskmqcqbrgmq0dzdcccqficm89nqlm6syji17kbkzkdblj"))))
    (build-system python-build-system)
    (home-page "https://github.com/slhck/ffmpeg-progress-yield")
    (synopsis "Run an FFmpeg")
    (description "This package provides a method to run an FFmpeg command with
while printing a progress update.")
    (license expat)))

(define-public ffmpeg-normalize
  (package
    (name "ffmpeg-normalize")
    (version "1.22.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ffmpeg-normalize" version))
       (sha256
        (base32
         "1qw2d71ylmnyh04j9aqp53yqw3yygvwa0npgwpdip9g9i99ph2d2"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-colorama" ,python-colorama)
        ("python-ffmpeg-progress-yield" ,python-ffmpeg-progress-yield)
        ("python-tqdm" ,python-tqdm)))
    (home-page "https://github.com/slhck/ffmpeg-normalize/")
    (synopsis "Normalize audio")
    (description "This package provides @code{ffmpeg-normalize}, a program that
program normalizes media files to a certain loudness level using the EBU R 128
loudness normalization procedure. It can also perform RMS-based normalization
(where the mean is lifted or attenuated), or peak normalization to a certain
target level.

Batch processing of several input files is possible, including video files.")
    (license expat)))
