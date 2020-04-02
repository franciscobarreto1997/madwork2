require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";
import './application.css';
import introJs from 'intro.js';

import animateSearchText from '../functions/animate_search_text';
import responsiveNavbar from '../functions/responsive_navbar';
import fetchJobs from '../functions/fetch_jobs';
import autocomplete from '../functions/autocomplete';
import injectCountries from '../functions/inject_countries';
import injectCities from '../functions/inject_cities';
import injectCitiesOnPageLoad from '../functions/inject_cities_on_page_load';

injectCountries();
injectCitiesOnPageLoad();
injectCities();
animateSearchText();
responsiveNavbar();
fetchJobs('search', 'fetch_home');
fetchJobs('query', 'fetch_results');
autocomplete();
introJs().start();
