(define-module (leo packages sent)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages image)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define-public sent
  (package
    (name "sent")
    (version "0.1")
    (source (origin
             (method url-fetch)
             (uri (string-append
                  "http://dl.suckless.org/tools/sent-"
                  version ".tar.gz"))
             (sha256
              (base32
               "09fhq3qi0q6cn3skl2wd706wwa8wxffp0hrzm22bafzqxaxsaslz"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (delete 'check)) ; no test suite
       #:make-flags (list
                      "CC=gcc"
                      (string-append "PREFIX=" %output)
                      (string-append "INCS +="
                                     " -I" (assoc-ref %build-inputs "freetype")
                                     "/include/freetype2"))))
    (inputs
      `(("libpng" ,libpng)
        ("libx11" ,libx11)
        ("libxft" ,libxft)
        ("freetype" ,freetype)))
    (synopsis "Simple plaintext presentation tool")
    (description "Uses plaintext files and PNG images to create slideshow
presentations.  Each paragraph represents a slide in the presentation.
Especially for presentations using the Takahashi method this is very nice and
allows you to write down the presentation for a quick lightning talk within a
few minutes.")
    (home-page "http://tools.suckless.org/sent")
    (license license:x11)))
