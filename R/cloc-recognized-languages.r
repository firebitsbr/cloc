#' Return a data frame of `cloc` recognized languages and associated extensions
#'
#' Some file extensions map to multiple languages:
#'
#' - `.cl` files could be Lisp or OpenCL
#' - `.d` files could be D or dtrace
#' - `.f` or `.for` files could be Fortran or Forth
#' - `.fs` files could be Forth or F#
#' - `.inc` files could be PHP or Pascal
#' - `.jl` files could be Lisp or Julia
#' - `.m` files could be MATLAB, Mathematica, Mercury, MUMPS, or Objective C
#' - `.pl` files could be Perl or Prolog
#' - `.pp` files could be Pascal or Puppet
#' - `.pro` files could be IDL, Prolog, or a Qt Project
#' - `.ts` files could be TypeScript or Qt Linguist
#' - `.v` files Coq or Verilog/SystemVerilog
#'
#' `cloc` has subroutines that attempt to identify the correct language based
#' on the file's contents for these special cases. Language identification
#' accuracy is a function of how much code the file contains; .m files with
#' just one or two lines for example, seldom have enough information to
#' correctly distinguish between MATLAB, Mercury, MUMPS, or Objective C.
#' @md
#' @return tibble
#' @export
#' @examples
#' cloc_reognized_languages()
cloc_reognized_languages <- function() {

  perl <- Sys.which("perl")

  if (perl == "") {
    stop(
      "Cannot find 'perl'. cloc requires perl to be installed and on the PATH.",
      call. = FALSE
    )
  }

  sprintf(
    "%s %s --show-lang",
    perl,
    system.file("bin/cloc.pl", package = "cloc"),
    source
  ) -> cmd

  dat <- system(cmd, intern = TRUE)

  dplyr::bind_rows(
    lapply(
      strsplit(dat, "\\("),
      function(.x) {
        lang <- trimws(.x[1])
        extensions <- trimws(.x[2])
        extensions <- sub("\\)", "", extensions)
        dplyr::data_frame(
          lang = lang,
          extensions = extensions
        )
      }
    )
  )

}
