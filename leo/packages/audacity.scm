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

(define-module (leo packages audacity)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mp3)
  #:use-module (gnu packages music)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages video)
  #:use-module (gnu packages wxwidgets)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages xml))

;; Audacity 3 has some problems in Guix:
;; https://issues.guix.gnu.org/53591

(define-public audacity
  (package
    (name "audacity")
    (version "2.4.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/audacity/audacity")
             (commit (string-append "Audacity-" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0lklcvqkxrr2gkb9gh3422iadzl2rv9v0a8s76rwq43lj2im7546"))
       (patches (search-patches "audacity-build-with-system-portaudio.patch"
                                "audacity-add-include.patch"))
       (modules '((guix build utils)))
       (snippet
        ;; Remove bundled libraries.
        '(begin
           (for-each
            (lambda (dir)
              (delete-file-recursively (string-append "lib-src/" dir)))
            '("expat" "ffmpeg" "lame" "libflac" "libid3tag" "libmad" "libogg"
              "libsndfile" "libsoxr" "libvamp" "libvorbis" "lv2"
              "portmidi" "soundtouch" "twolame"
              ;; FIXME: these libraries have not been packaged yet:
              ;; "libnyquist"
              ;; "libscorealign"
              ;; "libwidgetextra"
              ;; "portburn"
              ;; "portsmf"
              ;; "portmixer"

              ;; FIXME: we have this library, but it differs in that the Slide
              ;; class does not have a member "getInverseStretchedTime".
              ;; "sbsms"
              ))
           #t))))
    (build-system cmake-build-system)
    (inputs
     (list wxwidgets
           gtk+
           alsa-lib
           jack-1
           expat
           ffmpeg
           lame
           flac
           libid3tag
           libmad
           ;;("libsbsms" ,libsbsms)         ;bundled version is modified
           libsndfile
           soundtouch
           soxr ;replaces libsamplerate
           twolame
           vamp
           libvorbis
           lv2
           lilv ;for lv2
           suil ;for lv2
           portmidi))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("gettext" ,gettext-minimal)     ;for msgfmt
       ("libtool" ,libtool)
       ("pkg-config" ,pkg-config)
       ("python" ,python)
       ("which" ,which)))
    (arguments
     `(#:configure-flags
       (list
        ;; Loading FFmpeg dynamically is problematic.
        "-Daudacity_use_ffmpeg=linked"
        "-Daudacity_use_lame=system"
        "-Daudacity_use_portsmf=system")
       #:imported-modules ((guix build glib-or-gtk-build-system)
                           ,@%cmake-build-system-modules)
       #:modules
       ((guix build utils)
        (guix build cmake-build-system)
        ((guix build glib-or-gtk-build-system) #:prefix glib-or-gtk:))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'comment-out-revision-ident
           (lambda _
             (substitute* "src/AboutDialog.cpp"
               (("(.*RevisionIdent\\.h.*)" include-line)
                (string-append "// " include-line)))))
         (add-after 'unpack 'use-upstream-headers
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* '("src/NoteTrack.cpp"
                            "src/AudioIO.cpp"
                            "src/AudioIO.h"
                            "src/AudioIOBase.cpp")
               (("../lib-src/portmidi/pm_common/portmidi.h") "portmidi.h")
               (("../lib-src/portmidi/porttime/porttime.h") "porttime.h"))
             (substitute* "src/prefs/MidiIOPrefs.cpp"
               (("../../lib-src/portmidi/pm_common/portmidi.h") "portmidi.h"))))
         (add-after 'wrap-program 'glib-or-gtk-wrap
           (assoc-ref glib-or-gtk:%standard-phases 'glib-or-gtk-wrap)))
         ;; The test suite is not "well exercised" according to the developers,
         ;; and fails with various errors.  See
         ;; <http://sourceforge.net/p/audacity/mailman/message/33524292/>.
         #:tests? #f))
    (home-page "https://www.audacityteam.org/")
    (synopsis "Software for recording and editing sounds")
    (description
     "Audacity is a multi-track audio editor designed for recording, playing
and editing digital audio.  It features digital effects and spectrum analysis
tools.")
    (license license:gpl2+)))
