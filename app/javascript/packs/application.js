require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";

import animateSearchText from '../functions/animate_search_text';
import responsiveNavbar from '../functions/responsive_navbar';
import fetchJobs from '../functions/fetch_jobs';

animateSearchText();
responsiveNavbar();
fetchJobs();
