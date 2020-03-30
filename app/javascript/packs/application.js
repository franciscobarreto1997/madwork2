require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";
import './application.css';

import animateSearchText from '../functions/animate_search_text';
import responsiveNavbar from '../functions/responsive_navbar';
import fetchJobs from '../functions/fetch_jobs';
import autocomplete from '../functions/autocomplete';

animateSearchText();
responsiveNavbar();
fetchJobs('search', 'fetch_home');
fetchJobs('query', 'fetch_results');
autocomplete();
