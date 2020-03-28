require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";

import animateSearchText from '../functions/animate_search_text';
import responsiveNavbar from '../functions/responsive_navbar';
import fetchJobs from '../functions/fetch_jobs';
import sendParamsToFetchResults from '../functions/send_params_to_fetch_results';


animateSearchText();
responsiveNavbar();
fetchJobs('search', 'fetch_home');
fetchJobs('query', 'fetch_results');
sendParamsToFetchResults();

