#' @export
#' @importFrom ISOweek ISOweek2date
#' @importFrom lubridate days
#' @importFrom lubridate years
#' @title Get Period Type
#'
#' @description Utility function return a DHIS2 period type from an ISO string
#'
#' @inheritParams datim_validation_params
#'
#' @return Returns a a character of the period, like "Monthly"
#' @examples
#' getPeriodType("2018Q3")
#' getPeriodType("2018")
#' getPeriodType("19730221")
#' getPeriodType("201904")
#' getPeriodType("2018Q4")
#'
getPeriodType <- function(iso) {
  # nolint
  # nolint start
  if (grepl("^\\d{8}$", iso, perl = TRUE)) {return("Daily")}
  else if (grepl("^\\d{4}W\\d{1,2}$", iso, perl = TRUE))  {return("Weekly")}
  else if (grepl("^\\d{6}$", iso, perl = TRUE))  {return("Monthly")}
  else if (grepl("^\\d{4}Q\\d{1}$", iso, perl = TRUE))  {return("Quarterly")}
  else if (grepl("^\\d{4}$", iso, perl = TRUE))  {return("Yearly")}
  else if (grepl("^\\d{4}Oct$", iso, perl = TRUE))  {return("FinancialOct")}
  else {return(NA)}
  # nolint end
}

#' @export
#' @title Get Period from ISO
#'
#' @description Utility function return a data frame of a periods start date,
#' end date, ISO character and periodtype
#'
#' @inheritParams datim_validation_params
#'
#' @return Returns a data frame consisting of iso (character), startDate (Date),
#' endDate (Date) and period type (character)
#' @examples
#'  getPeriodFromISO("2018Q1")
#'  getPeriodFromISO("201801")
#'  getPeriodFromISO("20180901")
#'
getPeriodFromISO <- function(iso) {
  if (is.na(iso)) {
    stop("You must supply a period identifier")
  }
  pt <- getPeriodType(iso)
  startDate <- NA
  endDate <- NA
  if (pt == "Daily") {
    startDate <- as.Date(iso, "%Y%m%d")
    endDate <- as.Date(iso, "%Y%m%d")
  } else if (pt == "Weekly") {
    y <- substr(iso, 1, 4)
    wk <- as.numeric(gsub("W", "", stringr::str_extract(iso, "W.+")))
    if (wk <= 10) {
      wk <- paste0("0", as.character(wk))
    }
    startDate <- ISOweek2date(paste0(y, "-W", wk, "-1"))
    endDate <- ISOweek2date(paste0(y, "-W", wk, "-7"))
  } else if (pt == "Monthly") {
    startDate <- as.Date(paste0(iso, "01"), "%Y%m%d")
    endDate <- startDate + months(1) - days(1)
  } else if (pt == "Quarterly") {
    y <- substr(iso, 1, 4)
    q <- substr(iso, 6, 6)
    if (q == "1") {
      m <- "01"
    } else if (q == "2") {
      m <- "04"
    } else if (q == "3") {
      m <- "07"
    } else if (q == 4) {
      m <- "10"
    }  else {
      (stop(paste("Invalid quarter specified in ", iso)))
    }
    add.months <- function(date, n) {
      seq(date, by = paste(n, "months"), length = 2)[2]
    }
    startDate <- as.Date(paste0(y, m, "01"), "%Y%m%d")
    endDate <- add.months(startDate, 3) - 1
  } else if (pt == "Yearly") {
    startDate <- as.Date(paste0(iso, "0101"), "%Y%m%d")
    endDate <- startDate + years(1) - days(1)

  } else if (pt == "FinancialOct") {
    y <- as.integer(substr(iso, 1, 4))
    startDate <- as.Date(paste0(y, "1001"), "%Y%m%d")
    endDate <- startDate + years(1) - days(1)
  }

  period <- data.frame(
    iso = iso,
    startDate = startDate,
    endDate = endDate,
    periodType = pt,
    stringsAsFactors = FALSE)

  if (anyNA(period) || is.null(period)) {
    stop(paste0(iso, "is not a valid period."))
  }

  return(period)
}


#' @export
#' @title Check Period Identifiers
#'
#' @description Expect an error if any invalid period identifiers are
#' supplied in the file.
#'
#' @inheritParams datim_validation_params
#'
#' @return TRUE if all periods are valid.
#' @examples \dontrun{
#'     d <- d2Parser("myfile.csv", type = "csv")
#'     #Should return no error if all period identifiers are valid
#'     checkPeriodIdentifiers(d)
#' }
#'
checkPeriodIdentifiers <- function(data) {
  do.call(rbind.data.frame, lapply(data$period, getPeriodFromISO))
  return(TRUE)
}
