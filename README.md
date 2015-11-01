These are Guix packages that are for some reason not suitable for
inclusion in the GNU Guix. Either they do not meet the standard of
quality or they have an incompatible license.

Assuming the path to this directory is ~/pkgs, you  can use these
packages with Guix by including the path to the repo in your
GUIX_PACKAGE_PATH, like this:

    $ GUIX_PACKAGE_PATH="~/pkgs" guix package -i package-name

or by specifying the load path, like this:

    guix package -L ~/pkgs -i package-name
