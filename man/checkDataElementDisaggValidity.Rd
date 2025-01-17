% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checkDataElementDisaggValidity.R
\name{checkDataElementDisaggValidity}
\alias{checkDataElementDisaggValidity}
\title{Check Data Element Disagg Validity}
\usage{
checkDataElementDisaggValidity(
  data,
  datasets = NA,
  return_violations = TRUE,
  d2session = dynGet("d2_default_session", inherits = TRUE)
)
}
\arguments{
\item{data}{D2 compliant data frame object}

\item{datasets}{Should be a character vector of data set UIDs.
Alternatively, if left missing, user will be promted to choose from a list.}

\item{return_violations}{Boolean to return violations only.}

\item{d2session}{DHIS2 Session id}
}
\value{
Returns a data frame  of "dataElementName","categoryOptionComboName",
"dataElement","categoryOptionCombo"
of invalid data elements which are present the the data, if any.
If there are no violations, a boolean TRUE is returned.
}
\description{
Utility function to produce a data frame of
invalid data elements based on current
DATIM form specification.
}
\examples{
\dontrun{
  d <- d2Parser("myfile.csv",type="csv")
  ds <- getCurrentMERDataSets(type="RESULTS")
  checkDataElementDisaggValidity(d,ds)
}
}
