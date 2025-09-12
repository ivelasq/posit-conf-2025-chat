library(rvest)
library(glue)
library(chromote)
library(purrr)
library(readr)
library(fs)
library(lubridate)

# Define the URLs for the conference agenda
days <- 20250916:20250918
urls <- glue::glue("https://reg.rainfocus.com/flow/posit/positconf25/attendee-portal/page/sessioncatalog?tab.day={days}")

# Define function to read the HTML content of the page
grab_catalog_results <- function(url) {
  chromote:::set_default_chromote_object(chromote::Chromote$new())
  Sys.sleep(2)
  page <- rvest::read_html_live(url)
  Sys.sleep(10)
  
  # Extract session result
  session_nodes <- page %>%
    rvest::html_elements(".rf-tile")

  # Extract grouped info from each session node
  session_info <- purrr::map(session_nodes, function(node) {
    abstract <- node %>% 
      rvest::html_elements("p.rf-tile-info.rf-tile-line-two, ul") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")
    
    list(
      title    = node %>% rvest::html_element(".rf-tile-title") %>% rvest::html_text2(),
      abstract = abstract,
      date     = node %>% rvest::html_element(".session-date") %>% rvest::html_text2(),
      time     = node %>% rvest::html_element(".session-time") %>% rvest::html_text2(),
      location = node %>% rvest::html_element(".session-time-in-person") %>% rvest::html_text2()
    )
  })
  
  return(session_info)
}

# Map across the URLs and extract the session info into a flat vector
conf_agenda <- purrr::map(urls, grab_catalog_results) |>
  flatten()

# Format each session as Markdown
format_session_as_md <- function(session) {
  # Clean text
  abstract <- gsub("\n{2,}", "\n\n", session$abstract)
  abstract <- gsub("\n", "  \n", abstract)
  
  # Extract date/time/room from `time` if needed
  # time_clean <- gsub("Add to Schedule\\n", "", session$time)
  # time_lines <- unlist(strsplit(time_clean, "\n"))
  # time_line <- time_lines[1]
  time_line <- glue::glue("{session$date} {session$time}")
  
  room_line <- session$location
  
  glue::glue("
## Session Title: {session$title}

**Date/Time:** {time_line}  
**Location:** {room_line}

**Session Info:**  
{abstract}
")
}

sessions_md <- purrr::map_chr(conf_agenda, format_session_as_md) |>
  purrr::set_names(
    purrr::map(conf_agenda, \(x) x$title)
  )

chunks_df <- data.frame(
  title = names(sessions_md),
  text = sessions_md,
  stringsAsFactors = FALSE
)

readr::write_csv(
  chunks_df,
  file.path("data", "posit-conf-2025-sessions.csv")
)

# write last modified date based on CSV as text file

info <- fs::file_info(file.path("data", "posit-conf-2025.ragnar.duckdb"))

last_modified_date <- lubridate::date(info$modification_time)

writeLines(
  as.character(last_modified_date),
  file.path("data", "retrieval-date.txt")
)
