% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deprecate.R
\name{build_drake_graph}
\alias{build_drake_graph}
\title{Deprecated function \code{build_drake_graph}}
\usage{
build_drake_graph(plan = read_drake_plan(), targets = plan$target,
  envir = parent.frame(), verbose = drake::default_verbose(),
  jobs = 1, sanitize_plan = FALSE, console_log_file = NULL,
  trigger = drake::trigger(), cache = NULL)
}
\arguments{
\item{plan}{workflow plan data frame.
A workflow plan data frame is a data frame
with a \code{target} column and a \code{command} column.
(See the details in the \code{\link[=drake_plan]{drake_plan()}} help file
for descriptions of the optional columns.)
Targets are the objects and files that drake generates,
and commands are the pieces of R code that produce them.
Use the function \code{\link[=drake_plan]{drake_plan()}} to generate workflow plan
data frames easily, and see functions \code{\link[=plan_analyses]{plan_analyses()}},
\code{\link[=plan_summaries]{plan_summaries()}}, \code{\link[=evaluate_plan]{evaluate_plan()}},
\code{\link[=expand_plan]{expand_plan()}}, and \code{\link[=gather_plan]{gather_plan()}} for
easy ways to generate large workflow plan data frames.}

\item{targets}{character vector, names of targets to build.
Dependencies are built too. Together, the \code{plan} and
\code{targets} comprise the workflow network
(i.e. the \code{graph} argument).
Changing either will change the network.}

\item{envir}{environment to use. Defaults to the current
workspace, so you should not need to worry about this
most of the time. A deep copy of \code{envir} is made,
so you don't need to worry about your workspace being modified
by \code{make}. The deep copy inherits from the global environment.
Wherever necessary, objects and functions are imported
from \code{envir} and the global environment and
then reproducibly tracked as dependencies.}

\item{verbose}{logical or numeric, control printing to the console.
Use \code{pkgconfig} to set the default value of \code{verbose}
for your R session:
for example, \code{pkgconfig::set_config("drake::verbose" = 2)}.
\itemize{
\item \code{0} or \code{FALSE}: print nothing.
\item \code{1} or \code{TRUE}: print only targets to build.
\item \code{2}: also print checks and cache info.
\item \code{3}: also print any potentially missing items.
\item \code{4}: also print imports and writes to the cache.
}}

\item{jobs}{maximum number of parallel workers for processing the targets.
If you wish to parallelize the imports and preprocessing as well, you can
use a named numeric vector of length 2, e.g.
\code{make(jobs = c(imports = 4, targets = 8))}.
\code{make(jobs = 4)} is equivalent to \code{make(jobs = c(imports = 1, targets = 4))}.

Windows users should not set \code{jobs > 1} if
\code{parallelism} is \code{"mclapply"} because
\code{\link[=mclapply]{mclapply()}} is based on forking. Windows users
who use \code{parallelism = "Makefile"} will need to
download and install Rtools.

You can experiment with \code{\link[=predict_runtime]{predict_runtime()}}
to help decide on an appropriate number of jobs.
For details, visit
\url{https://ropenscilabs.github.io/drake-manual/time.html}.}

\item{sanitize_plan}{deprecated}

\item{console_log_file}{character scalar,
connection object (such as \code{stdout()}) or \code{NULL}.
If \code{NULL}, console output will be printed
to the R console using \code{message()}.
If a character scalar, \code{console_log_file}
should be the name of a flat file, and
console output will be appended to that file.
If a connection object (e.g. \code{stdout()})
warnings and messages will be sent to the connection.
For example, if \code{console_log_file} is \code{stdout()},
warnings and messages are printed to the console in real time
(in addition to the usual in-bulk printing
after each target finishes).}

\item{trigger}{Name of the trigger to apply to all targets.
Ignored if \code{plan} has a \code{trigger} column.
See \code{\link[=trigger]{trigger()}} for details.}

\item{cache}{drake cache as created by \code{\link[=new_cache]{new_cache()}}.
See also \code{\link[=get_cache]{get_cache()}} and \code{\link[=this_cache]{this_cache()}}.}
}
\value{
An \code{igraph} object.
}
\description{
Use \code{\link[=drake_config]{drake_config()}} instead.
}
\details{
Deprecated on 2018-11-02.
}
\examples{
# See ?drake_config for examples.
}
\keyword{internal}
