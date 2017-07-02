Bizsearch
================

Intended primarily for personal use, Bizsearch provides a GUI (Rails app run locally) to interface with business listings found via [searchbot](https://github.com/kdonovan/searchbot).

Usage
================
Generate a User, SearchGroup (just a name to hold individual searches), and one or more attached SavedSearch instances. Run #update! on the SavedSearches (or Searcher.import_search_results!).

Maybe need to manually create Site records (one for each Site Searchbot supports) first?