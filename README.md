# posit::conf(2025) chat app

This repository contains a chat application built for [posit::conf(2025)](https://posit.co/conference/). The project is implemented in R and consists of several scripts and an interactive app. This app is **NOT** officially affiliated with Posit. It's just a fun project I did over a Sunday evening. It uses agenda data scraped from the conference website.

## General Implementation

- **Data Collection:** The `00-scrape-webpages.R` script scrapes and collects data from specified web sources.
- **Data Processing:** The `01-ragnar-store.R` script processes the scraped data and stores it in a structured format for efficient access by the app.
- **App Launch:** The `app.R` script launches the interactive chat application, using the processed data.

For questions or contributions, please open an issue or submit a pull request.

## Acknowledgments

I'm grateful to several people who helped make this project better:

**[@LibbyHeeren](https://github.com/LibbyHeeren/)** reviewed the initial version of the app and provided valuable feedback that guided key improvements.

**[@astrowonk](https://github.com/astrowonk/)** shared helpful tips and reference Python code for the API call, which streamlined the development process significantly.

**[@ivelasq](https://github.com/ivelasq)** went above and beyond by publishing a separate instance of the app on Posit Connect using a Posit API key and writing [this excellent blog post](https://posit.co/blog/posit-conf-2025-agenda/) about the project.

Your contributions and support made this project much better than it would have been otherwise. Thank you!
