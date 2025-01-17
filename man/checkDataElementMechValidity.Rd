% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checkDataElementMechanismValidity.R
\name{checkDataElementMechValidity}
\alias{checkDataElementMechValidity}
\title{checkDataElementMechValidity(data,organisationUnit,datasets, d2session)}
\usage{
checkDataElementMechValidity(
  d,
  datasets,
  return_violations = TRUE,
  d2session = d2_default_session
)
}
\arguments{
\item{datasets}{Should be a character vector of data set UIDs.}

\item{return_violations}{Return the invalid data if TRUE}

\item{d2session}{datimutils d2session object}

\item{data}{D2 compliant data frame}
}
\value{
Returns subset of data which contains
  invalid data element / attribute option combo associations. As an example, MER results
  data should always be submitted against mechanism, while other data may be
  reported against the "default" mechanism.
  If no violations are found, a boolean
  TRUE value is returned.
}
\description{
Returns a data frame invalid data elements which exist in the data
but which do not have a valid association with an attribute option combo (mechanism.)
}
\examples{
\dontrun{
     d <- d2Parser("myfile.csv", type = "csv")
     ds <- getCurrentMERDataSets(type = "RESULTS")
     checkDataElementOrgunitValidity(data = d,datasets = ds)
}

}
